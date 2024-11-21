/*
* Ajout de la colonne email
*/
ALTER TABLE stagiaire_t
ADD COLUMN email_f VARCHAR(255) 
DEFAULT "tbd@disney.com";

UPDATE stagiaire_t
SET email_f= lower(prenom_f)||"."||lower(nom_f)||"@"||"disneyland.com"
WHERE email_f="tbd@disney.com";

SELECT * from stagiaire_t;

	