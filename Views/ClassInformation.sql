select 
    Classes.ClassID,
S.SubjectName as [Subject name],
Classes.Topic,
Classes.Description,
L.LanguageName,
T.FirstName + '' + T.LastName as [Translator name],
ClassDateTime as Date,
Duration as Duration,
ClassPrice as Price,
PriceChange as [Price change],
LimitedPlaces as [Place limit],
CT.ClassTypeName as [Class type]
from Classes
JOIN dbo.Subjects S on Classes.SubjectID = S.SubjectID
JOIN dbo.Languages L on L.LanguageID = Classes.LanguageID
JOIN dbo.Translators T on T.TranslatorID = Classes.TranslatorID
Join dbo.ClassTypes CT on Classes.ClassTypeID = CT.ClassTypeID
