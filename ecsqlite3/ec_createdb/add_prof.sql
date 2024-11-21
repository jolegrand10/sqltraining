DROP TABLE IF EXISTS prof_t;;
DROP TABLE IF EXISTS cadre_t;


CREATE TABLE prof_t(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	prenom_f VARCHAR(100),
	nom_f VARCHAR(100));

CREATE TABLE cadre_t(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	prenom_f VARCHAR(100),
	nom_f VARCHAR(100));
	
	
/*
* Peupler la table des profs
*/
INSERT INTO prof_t(prenom_f, nom_f) VALUES
	("Minnie", "Mouse"),
	("Geo", "Trouvetout"),
	("Daisy", "Duck")
;
/*
* Peupler la table des cadres
*/
INSERT INTO cadre_t(prenom_f, nom_f) VALUES
	("Daisy", "Duck"),
	("Mickey", "Mouse")

;
