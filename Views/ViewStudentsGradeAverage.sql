CREATE VIEW ViewStudentsGradeAverage AS
   SELECT (SELECT StudenID, ISNULL(AVG(GradeValue), 0.0) Average_Grade FROM Students LEFT JOIN SubjectsGrades SG on Students.StudentID = SG.StudentID JOIN Grades G on SG.GradeID = G.GradeID) ; 
