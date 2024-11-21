/*CREATE DATABASE ec_db;*/

DROP TABLE IF EXISTS stagiaire_t;
DROP TABLE IF EXISTS cours_t;
DROP TABLE IF EXISTS scd_t;


CREATE TABLE stagiaire_t(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	prenom_f VARCHAR(100),
	nom_f VARCHAR(100));
	
CREATE TABLE cours_t(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	matiere_f VARCHAR(100),
	duree_f SMALLINT);

	
	
/*
* Peupler la table des stagiaires
*/
INSERT INTO stagiaire_t (prenom_f, nom_f) VALUES
	("Riri", "Duck"),
	("Fifi", "Duck"),
	("Loulou", "Duck")
;
/*
* Peupler la table des cours
*/
INSERT INTO cours_t(matiere_f, duree_f) VALUES
	("Android", 90),
	("Java", 38),
	("BdD", 28),
	("GUI", 12),
	("REST", 21),
	("SCRUM", 6),
	("Emploi", 30),
	("Xamarin", 14),
	("Projet", 64)
;

CREATE TABLE scd_t(
	stagiaire_id INTEGER NOT NULL,
	cours_id INTEGER NOT NULL, 
	duree_f SMALLINT,
	PRIMARY KEY(stagiaire_id, cours_id),
	FOREIGN KEY (stagiaire_id) REFERENCES stagiaire_t(id),
	FOREIGN KEY (cours_id) REFERENCES  cours_t(id)
);




SELECT COUNT(*) FROM scd_t;

/*
* On décide d'inscrire tous les stagiaires à tous les cours
*/
INSERT INTO scd_t(stagiaire_id, cours_id, duree_f)
	SELECT
		stagiaire_t.id,
		cours_t.id, 
		0
	FROM 
		stagiaire_t, 
		cours_t 
;

SELECT COUNT(*) FROM scd_t;

/*
* Le reponsable pédagogique  souhaite rectifier
* et nous communique
* la liste des inscriptions 
* sous la forme (prénom, matière)
*/
DROP TABLE IF EXISTS inscription_t;
CREATE TABLE inscription_t(
	prenom_f TEXT,
	matiere_f TEXT
);
INSERT INTO inscription_t(prenom_f, matiere_f) VALUES
	("Riri", "Android"),
	("Riri", "Java"),
	("Fifi", "Java"),
	("Loulou", "Android")
;

/*
* vider la table scd_t
* 
* SQLite3 ne connait pas la commande
* TRUNCATE scd_t;
*/
DELETE FROM scd_t;
SELECT COUNT(*) FROM scd_t;

/*
* charger les inscriptions
*/
INSERT INTO scd_t(stagiaire_id, cours_id, duree_f)
	SELECT s.id, c.id, 0
	FROM 
		stagiaire_t AS s, 
		cours_t AS c, 
		inscription_t AS i
	WHERE 
		s.prenom_f=i.prenom_f AND
		c.matiere_f=i.matiere_f
;
SELECT COUNT(*) FROM scd_t;



/*
* Remplacer Xamarin par Cordoba
*/
UPDATE cours_t
SET matiere_f = "Cordoba"
WHERE matiere_f = "Xamarin";

/*
* Indiquer que le cours java a progressé d'une journée de 7h
*
*/
UPDATE scd_t
SET duree_f = duree_f+7
WHERE cours_id=(SELECT id FROM cours_t WHERE matiere_f="Java");





