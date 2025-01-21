select 
Students.StudentID,
Students.FirstName + ' ' + Students.LastName AS [Student Name],
C.CountryName AS Country,
A.Region AS Region,
C.CityName AS City,
A.StreetName AS Street
from Students
JOIN dbo.Addresses A on A.AddressID = Students.AddressID
JOIN dbo.City C on C.CityID = A.CityID
