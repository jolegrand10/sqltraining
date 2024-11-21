DROP TABLE IF EXISTS bulk_t;
/*
CREATE TABLE bulk_t(
	prenom_f Text,
	nom_f Text,
	titre_f Text,
	type_f Text
);*/

.mode csv
.separator ";"
.import films.csv bulk_t

select count(*) from bulk_t;


select distinct prenom_f from bulk_t order by prenom_f ASC limit 10;

update bulk_t set prenom_f = trim(prenom_f), nom_f=trim(nom_f), titre_f=trim(titre_f), type_f=trim(type_f);

select distinct prenom_f from bulk_t order by prenom_f ASC limit 10;

.headers on
select distinct prenom_f as Prénom, nom_f as Nom from bulk_t order by Nom ASC, Prénom ASC limit 10;
.headers off

DROP TABLE IF EXISTS director_t;
CREATE TABLE director_t	(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	prenom_f Text,
	nom_f Text);

INSERT INTO director_t (prenom_f, nom_f) 
	SELECT DISTINCT prenom_f, nom_f FROM bulk_t;
	
SELECT COUNT(*) FROM director_t;

SELECT * FROM director_t LIMIT 100,20;


DROP TABLE IF EXISTS film_t;
CREATE TABLE film_t(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	titre_f Text,
	type_f Text,
	director_id INTEGER NOT NULL, 
	FOREIGN KEY (director_id) REFERENCES director_t(id)
);

INSERT INTO film_t(titre_f, type_f, director_id)
	SELECT b.titre_f, b.type_f, d.id
	FROM bulk_t AS b, director_t AS d
	WHERE b.nom_f=d.nom_f AND b.prenom_f=d.prenom_f
;

SELECT COUNT(*) FROM film_t;

SELECT * FROM film_t LIMIT 200,24;

SELECT DISTINCT f.titre_f, "de", d.prenom_f, d.nom_f 
FROM film_t AS f, director_t AS d
WHERE f.director_id=d.id
GROUP BY d.id
ORDER BY d.nom_f ASC, d.prenom_f ASC
;

SELECT * 
FROM film_t
WHERE type_f NOT IN ('Film');

SELECT *
FROM film_t
WHERE type_f NOT LIKE 'Film';
