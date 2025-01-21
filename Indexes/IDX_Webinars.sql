CREATE INDEX IDX_Webinars_WebinarID ON Webinars (WebinarID);
CREATE INDEX IDX_Webinars_WebinarTopic ON Webinars (WebinarTopic);
CREATE INDEX IDX_Webinars_TranslatorID ON Webinars (TranslatorID);
CREATE INDEX IDX_Webinars_WebinarID_DateTime ON Webinars (WebinarID, WebinarDateTime);