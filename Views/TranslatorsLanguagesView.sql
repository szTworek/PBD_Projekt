SELECT T.TranslatorID, T.FirstName, T.LastName, L.LanguageName
FROM Translators T
         JOIN TranslatorsLanguages TL ON T.TranslatorID = TL.TranslatorID
         JOIN Languages L ON TL.LanguageID = L.LanguageID
