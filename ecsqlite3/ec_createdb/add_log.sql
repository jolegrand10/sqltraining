/*
* Ajout d'un dispositif de logging
*/
DROP TABLE IF EXISTS log_t;

CREATE TABLE log_t (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	email_f VARCHAR(255) NOT NULL,
	operation_f VARCHAR(100) NOT NULL,
	datetime_f DATETIME
);

DROP TRIGGER IF EXISTS nouveau_stagiaire;
CREATE TRIGGER nouveau_stagiaire 
AFTER INSERT ON stagiaire_t 
BEGIN
  INSERT INTO log_t(email_f, operation_f, datetime_f) VALUES
	  (NEW.email_f, 'inséré le', datetime('now'))
	;
END;

DROP TRIGGER IF EXISTS stagiaire_parti;
CREATE TRIGGER stagiaire_parti 
AFTER DELETE ON stagiaire_t 
BEGIN
  INSERT INTO log_t(email_f, operation_f, datetime_f) VALUES
	  (OLD.email_f, 'parti le', datetime('now'))
	;
END;

DROP TRIGGER IF EXISTS stagiaire_modifie;
CREATE TRIGGER stagiaire_modifie
AFTER UPDATE ON stagiaire_t
BEGIN
		INSERT INTO log_t(email_f, operation_f, datetime_f)	VALUES
			(OLD.email_f, 'modifié le', datetime('now'));
END;

DROP TRIGGER IF EXISTS email_modifie;
CREATE TRIGGER email_modifie
AFTER UPDATE ON stagiaire_t
WHEN OLD.email_f<>NEW.email_f
BEGIN
		INSERT INTO log_t(email_f, operation_f, datetime_f)	VALUES
			(NEW.email_f, 'nouvel email', datetime('now'));
END;


/*
1|daisy.duck@disney.com|inséré le|2019-03-21 15:29:22
2|daisy.duck@disney.com|modifié le|2019-03-21 15:30:09
3|donald.duck@disney.com|nouvel email|2019-03-21 15:31:10
4|daisy.duck@disney.com|modifié le|2019-03-21 15:31:10
5|donald.duck@disney.com|parti le|2019-03-21 15:32:06
*/