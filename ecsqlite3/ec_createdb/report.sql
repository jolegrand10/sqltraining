/*
* Rapport
*/
SELECT
 s.prenom_f AS p, s.nom_f AS n, c.matiere_f AS m, printf("%.2f", (1.0*scd.duree_f/(c.duree_f)))
FROM
	scd_t as scd, 
	stagiaire_t AS s, 
	cours_t AS c
WHERE
	scd.stagiaire_id=s.id AND
	scd.cours_id = c.id 
ORDER BY m ASC, n ASC, p ASC
;