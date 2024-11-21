DROP VIEW IF EXISTS home_v;
CREATE VIEW home_v AS
  SELECT
		matiere_f, cours_t.duree_f AS en_tout, scd_t.duree_f AS fait, 
		cours_t.duree_f - scd_t.duree_f AS reste_à_faire 
	FROM
	  cours_t, scd_t, stagiaire_t
	WHERE
    prenom_f="Riri" AND
		stagiaire_id=stagiaire_t.id AND
		cours_id=cours_t.id;
.headers on
SELECT * FROM home_v;