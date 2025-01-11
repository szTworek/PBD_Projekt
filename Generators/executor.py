import pyodbc

class QueryExecutor:
    def __init__(self, password):
        self.connection = pyodbc.connect(
            'DRIVER={ODBC Driver 17 for SQL Server};'
            'Server=149.156.97.7,1433;'
            'Database=u_stworek;'
            f'UID=u_stworek;PWD={password}'
        )

    def use_cursor(func):
        """
        A function wrapper to create a cursor for the query
        """
        def wrapper(self, *args, **kwargs):
            cursor = self.connection.cursor()
            try:
                # Execute the wrapped function
                result = func(self, cursor, *args, **kwargs)
            except Exception as e:
                print(f"An error occurred: {e}")
                result = None
            finally:
                cursor.close()  # Always close the cursor
            return result  # Return the result of the wrapped function
        return wrapper

    def show_result(self, cursor):
        """
        Utility to fetch and display query results.
        """
        row = cursor.fetchone()
        while row:
            # print(row)
            row = cursor.fetchone()

    @use_cursor
    def show_all_tables(self, cursor):
        """
        Show all tables in the database.
        """
        cursor.execute("SELECT * FROM INFORMATION_SCHEMA.TABLES")
        self.show_result(cursor)

    @use_cursor
    def use_procedure(self, cursor, procedure_name, params):
        """
        Execute a stored procedure with the given parameters and commit changes.
        """
        try:
            # Execute the procedure
            procedure = f"EXEC {procedure_name} {params}"
            cursor.execute(procedure)

            # Commit the transaction to save changes
            self.connection.commit()
            # print(f"Success EXEC {procedure_name} {params}")
            try:
                return cursor.fetchall(),0
            except pyodbc.ProgrammingError:
                # No result set returned
                return None, 0
            
        except Exception as e:
            # Rollback in case of an error
            self.connection.rollback()
            print(f"An error occurred: {e}")
            return None, 1

    @use_cursor
    def select_all(self, cursor, tableName):
        """
        Select and display all rows from a given table.
        """
        cursor.execute(f'SELECT * FROM {tableName}')
        self.show_result(cursor)

    def __del__(self):
        """
        Destructor that handles closing the connection
        """
        print("Closing the connection")
        self.connection.close()
