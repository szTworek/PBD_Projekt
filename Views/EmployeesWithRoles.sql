SELECT E.EmployeeID, E.FirstName, E.LastName, E.Role, E.Phone, C.CountryName, A.Region, C.CityName, A.StreetName
FROM Employees E
JOIN dbo.Addresses A on A.AddressID = E.AddressID
JOIN dbo.City C on C.CityID = A.CityID
