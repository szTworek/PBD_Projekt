SELECT W.WebinarID, W.WebinarTopic, T.FirstName AS TranslatorFirstName, T.LastName AS TranslatorLastName
FROM Webinars W
         JOIN Translators T ON W.TranslatorID = T.TranslatorID
