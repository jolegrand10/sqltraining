

ALTER TABLE cours_t
ADD COLUMN categorie_f VARCHAR(100) DEFAULT 'Autre';

UPDATE cours_t
SET categorie_f="Informatique"
WHERE cours_t.matiere_f IN ('Android', 'Java', 'BdD', 'GUI', 'REST', 'Cordoba');

UPDATE cours_t
SET categorie_f="Management"
WHERE cours_t.matiere_f IN('SCRUM', 'Projet');

UPDATE cours_t 
SET categorie_f="Marketing personnel"
WHERE cours_t.matiere_f="Emploi";


