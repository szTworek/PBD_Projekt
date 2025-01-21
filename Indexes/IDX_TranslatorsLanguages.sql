CREATE INDEX IDX_Translators_TranslatorID ON Translators (TranslatorID);
CREATE INDEX IDX_Translators_FirstName_LastName ON Translators (FirstName, LastName);
CREATE INDEX IDX_TranslatorsLanguages_LanguageID ON TranslatorsLanguages (LanguageID);
CREATE INDEX IDX_TranslatorsLanguages_TranslatorID_LanguageID ON TranslatorsLanguages (TranslatorID, LanguageID);
