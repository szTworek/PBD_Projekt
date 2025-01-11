import csv
import random
from executor import QueryExecutor
from typing import List, Dict
def read_password(filename="pss.txt"):
    passwd = ''
    try:
        with open("pss.txt") as f:
            passwd = f.readline()
    except Exception as e:
        print(f"Error while reading the file {e}")
    finally:
        return passwd

def read_csv_to_dict(file_name: str) -> List[Dict[str, str]]:
    """Read data from a CSV file and return it as a list of dictionaries."""
    with open(f"{file_name}.csv", mode="r", encoding="utf-8") as file:
        reader = csv.DictReader(file)
        return list(reader)

def generate_procedure_params(data_sample: Dict[str, str], columns: List[str]) -> str:
    """Generate procedure parameters as a string from a data sample."""
    params = []

    for column in columns:
        value = data_sample[column]
        if isinstance(value, str) and value != '1' and value != '0':
            params.append(f"'{value}'")
        elif value is not None:
            params.append(f"{value}")
    return ", ".join(params)

def add_from_file(file_name: str, table_name: str, procedure_name: str, query_executor, samples: int = N):
    """
    Add rows to a table by calling a stored procedure with randomized data from a CSV file.
    """
    # Load data from the file
    data = read_csv_to_dict(file_name)
    columns = list(data[0].keys())
    error_count = 0
    # Generate and execute procedure calls
    for i in range(samples):
        random_sample = {column: data[i][column] for column in columns}
        # print(random_sample )
        procedure_params = generate_procedure_params(random_sample, columns)

        # print(f"Calling procedure {procedure_name} with params: {procedure_params}")
        _, was_error = query_executor.use_procedure(procedure_name, procedure_params)

        error_count += was_error
    # Show final data in the table
    # query_executor.select_all(table_name)
    return error_count

def main(*args, **kwargs):
    """
    Main function to test procedures for multiple tables.
    """
    # Test configuration: Each tuple contains (CSV file, table name, procedure name)
    test_configurations = [
        # (None,"CourseTypes","AddBaseCourseTypes"),
        # (None,"ClassTypes","AddBaseClassTypes"),
        # (None,"Grades","AddLegalGrades"),
        # ("Students", "Students", "AddStudent"),
        # ("Employees", "Employees", "AddEmployee"),
        # ("Translators", "Translators", "AddTranslatorWithLanguages"),
        # ("Buildings","Buildings","AddBuilding"),
        # ("Classrooms","Classrooms","AddClassroom"),
        # ("Syllabuses", "Syllabuses", "AddSyllabus"),
        # ("Subjects", "Subjects", "AddSubject"),
        # ("Classes","Classes","AddClass"),
        # ("Webinars","Webinars","AddWebinar"),
        # ("AddToCart", "Orders", "AddToCart"),
        # ("AddOrderPayment", "Orders", "AddOrderPayment"),
        # ("Courses", "Courses", "AddCourse"),
        # ("AddStudentToCourse", "StudentsCourses", "AddStudentToCourse"),
        # ("AddStudentToClass", "StudentsToClass", "AddStudentToClass"),
        # ("AddStudentToWebinar", "WebinarAvailabilities", "AddStudentToWebinar"),
        # ("AddStudentToMajor", "CollegeClass", "AddStudentToMajor"),
        # ("ClassAttendance","ClassesAttendances","AddClassAttendance"),
        # ("Internships","Internships","AddInternship"),
        # ("InternshipAttendance","InternshipAttendances","AddInternshipAttendance"),
        # ("SubjectsGrades","SubjectGrades","AddSubjectsGrade"),
        # ("FinalExamGrades","FinalExamGrades","AddFinalExamGrade"),
        # ("StudentToCourse", "StudentToCourse", "AddStudentToCourse"),
        # ("CourseModules", "CourseModules", "AddCourseModule"),
        ("CourseModuleMeetings", "CourseModuleMeetings", "AddCourseModuleMeeting"),
        ("CourseModuleAttendance", "CourseModuleAttendance", "AddCourseModuleAttendance")
    ]

    # Initialize QueryExecutor
    qe = QueryExecutor(read_password())
    procedures_error_count = {}
    # Execute test for each configuration
    try:
        for file_name, table_name, procedure_name in test_configurations:
            if not file_name:
                print(f"Running procedure '{procedure_name}'")
                qe.use_procedure(procedure_name,'')
                continue
            print(f"Testing table '{table_name}' with procedure '{procedure_name}'")
            error_count = add_from_file(file_name, table_name, procedure_name, qe)
            procedures_error_count[procedure_name] = error_count
    finally:
        # Ensure the connection is closed even if errors occur
        for key in procedures_error_count.keys():
            print(f"Procedure {key} with {procedures_error_count[key]} errors")
        # qe.__del__()


if __name__ == "__main__":
    main()


