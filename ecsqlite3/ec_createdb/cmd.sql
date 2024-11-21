.headers on
.mode csv
.separator \;
.output data.csv
SELECT
  prenom_f,
	nom_f,
	email_f,
	matiere_f,
	cours_t.duree_f,
	scd_t.duree_f
FROM
  stagiaire_t,
	cours_t,
	scd_t
WHERE
	stagiaire_id=stagiaire_t.id AND
	cours_id= cours_t.id
;
.quit