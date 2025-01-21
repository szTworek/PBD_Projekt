CREATE ROLE Director;

-- Uprawnienia dla "Director": Dyrektor ma dostep do wszystkich widoków a takze do funkcji związanych 
-- zarządzaniem pracownikami, studentami i różnymi typami zajęć.
GRANT SELECT ON SCHEMA::dbo TO Director;
GRANT SELECT ON dbo.AllClassesTimetable TO Director;