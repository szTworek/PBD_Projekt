SELECT I.InternshipID, I.StartDate, COUNT(IA.StudentID) AS Participants
FROM Internships I
         JOIN InternshipsAttendances IA ON I.InternshipID = IA.InternshipID
GROUP BY I.InternshipID, I.StartDate
