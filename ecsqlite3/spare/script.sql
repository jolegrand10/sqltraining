/*
* create_sparedb.sql -- 2015-11-09 -- V0.0
* this script should be executed only once, the first time
* contains db + table creations and utility functions
*
*/
--DROP DATABASE IF EXISTS sparedb;
--CREATE DATABASE sparedb CHARACTER SET utf8 COLLATE utf8_general_ci;
--USE sparedb;

/*
* create table group -  administrator, coord, yop, tech, world
*/
CREATE TABLE group_t (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 name_f VARCHAR(50) UNIQUE NOT NULL
)
;
/*
* create table user 
*/
CREATE TABLE user_t (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 email_f VARCHAR(50) UNIQUE NOT NULL,
 password_f VARCHAR(50) NOT NULL,
 group_f INT NOT NULL,
 firstname_f VARCHAR (50),
 lastname_f VARCHAR(50),
 company_f VARCHAR (50), 	
 telephone_f VARCHAR (20),
 FOREIGN KEY (group_f) REFERENCES group_t(id)
)
;
/*
* create table spare parts sp
*/
CREATE TABLE sp_t (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 code_f VARCHAR(50) UNIQUE NOT NULL,
 name_f VARCHAR(100) NOT NULL
)
;
/*
* create table hubs hub_t
*/
CREATE TABLE hub_t (
 id INTEGER PRIMARY KEY AUTOINCREMENT,
 name_f VARCHAR(50) UNIQUE NOT NULL
)
;
/*
* create table thresholds
*/
CREATE TABLE threshold_t (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	sp_f INT NOT NULL,
	hub_f INT NOT NULL,
	low_f INT,
	high_f INT,
	FOREIGN KEY (sp_f) REFERENCES sp_t(id),
	FOREIGN KEY (hub_f) REFERENCES hub_t(id)
)
;
/*
* create table stock
*/
CREATE TABLE stock_t (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	sp_f INT NOT NULL,
	hub_f INT NOT NULL,
	qty_f INT,
	FOREIGN KEY (sp_f) REFERENCES sp_t(id),
	FOREIGN KEY (hub_f) REFERENCES hub_t(id)
)
;
/*
* Availability table
*/
CREATE TABLE availability_t (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name_f VARCHAR(30),
	text_f TEXT
)
;
/*
* Populate groups
*/
INSERT INTO group_t (id, name_f)
VALUES (1, 'administrator');

INSERT INTO group_t (id, name_f)
VALUES (NULL, 'spm');

INSERT INTO group_t (id, name_f)
VALUES (NULL,'world');

/*
* populate users
*/
INSERT INTO user_t (id, email_f, password_f, group_f, firstname_f, lastname_f, company_f, telephone_f)
VALUES (NULL, 'admin', '5f4dcc3b5aa765d61d8327deb882cf99', 1, 'A.', 'Dmin', 'Soc', '0612684006');
INSERT INTO user_t (id, email_f, password_f, group_f, firstname_f, lastname_f, company_f, telephone_f)
VALUES (NULL, 'ursula.tilisatrice@cie.com', '5f4dcc3b5aa765d61d8327deb882cf99', 2, 'Ursula', 'Tilisatrice', 'Cie', '0612345678');
/*
* populate hubs
*/
INSERT INTO hub_t (id, name_f)
VALUES
(NULL, 'Central'),
(NULL, 'Adonis'),
(NULL, 'Brahma'),
(NULL, 'Snape')
;
/*
* populate sp
*/
INSERT INTO sp_t(id, code_f, name_f)
VALUES
(NULL,'267656DB', 'UBLOUSMX'),
(NULL,'52711AA', 'MIRAG5U 2x12-2100kg')
;
/*
* populate thresholds
*/
INSERT INTO threshold_t(id, sp_f, hub_f, low_f, high_f)
VALUES
(NULL,1, 1, 38, 39),
(NULL,2, 1, 26, 30)
;
/*
* populate stock
*/
INSERT INTO stock_t(id, sp_f, hub_f, qty_f)
VALUES
(NULL,1, 1, 15),
(NULL,2, 1, 29),
(NULL,1, 2, 10),
(NULL,2, 2, 12),
(NULL,1, 3, 8),
(NULL,2, 3, 7),
(NULL,1, 4, 20),
(NULL,2, 4, 11)
;
/*
* populate availability table
*/
INSERT INTO availability_t(id, name_f,text_f)
VALUES
(NULL, 'Disponible', '<p>Cette pi&egrave;ce est disponible sous 24h.</p>'),
(NULL, 'Gestion intelligente', '<p>Il est n&eacute;cessaire d''obtenir l''accord &eacute;crit (email) soit du  manager, soit du responsable , soit de l''Incident Manager,
avant de planifier toute intervention de remplacement de cette pi&egrave;ce.
<br/>
Lors d''une gestion intelligente : Evitez le gaspillage de spare et le changement syst&eacute;matique de cartes (hors consigne sp&eacute;cifique)
<br/>
Cas non exhaustifs :
<br/>
<ul>
<li> Une carte suspect&eacute;e de panne doit &ecirc;tre chang&eacute;e apr&egrave;s avoir v&eacute;rifi&eacute; toutes les autres possibilit&eacute;s.
</li><li> Une demande de changement de carte pour la 3&egrave;me fois (ou plus) doit remettre en cause le diagnostic.
</li><li>Eviter de remplacer d''un coup toutes les cartes. La probabilit&eacute; d''une panne simultan&eacute;e  est faible.
</li></ul>
</p>'),
(NULL, 'AT seulement', '<p>Cette pi&egrave;ce ne peut &ecirc;tre engag&eacute;e qu''en cas d''arr&ecirc;t total (AT)</p>'),
(NULL, 'Indisponible', '<p>Cette pi&egrave;ce est actuellement &eacute;puis&eacute;e.</p>')
;
/*
* build agent view
*/
CREATE VIEW stock_v AS
	SELECT
		sp_t.id as sp_f,
		sp_t.code_f, 
		sp_t.name_f, 
		availability_t.name_f as availability_f
	FROM 
		stock_t, 
		threshold_t, 
		sp_t, 
		hub_t,
		availability_t
	WHERE
		sp_t.id=stock_t.sp_f AND
		sp_t.id=threshold_t.sp_f AND
		threshold_t.hub_f=hub_t.id AND
		hub_t.name_f='Central' AND
		stock_t.hub_f=hub_t.id AND
	(
		(stock_t.qty_f=0 AND availability_t.id=4) OR
		(stock_t.qty_f>0 AND stock_t.qty_f<=threshold_t.low_f AND availability_t.id=3) OR
		(stock_t.qty_f>0 AND stock_t.qty_f>threshold_t.low_f AND
			stock_t.qty_f <=threshold_t.high_f AND availability_t.id=2) OR
		(stock_t.qty_f>threshold_t.high_f AND availability_t.id=1)
	)
	;
/*
* build spm view
*/
CREATE VIEW spm_v AS
	SELECT
		sp_t.id,
		sp_t.code_f, 
		sp_t.name_f, 
		availability_t.name_f as availability_f,
		stock_t.qty_f,
		threshold_t.low_f,
		threshold_t.high_f
	FROM 
		stock_t, 
		threshold_t, 
		sp_t, 
		hub_t,
		availability_t
	WHERE
		sp_t.id=stock_t.sp_f AND
		sp_t.id=threshold_t.sp_f AND
		threshold_t.hub_f=hub_t.id AND
		hub_t.name_f='Central' AND
		stock_t.hub_f=hub_t.id AND
	(
		(stock_t.qty_f=0 AND availability_t.id=4) OR
		(stock_t.qty_f>0 AND stock_t.qty_f<=threshold_t.low_f AND availability_t.id=3) OR
		(stock_t.qty_f>0 AND stock_t.qty_f>threshold_t.low_f AND
			stock_t.qty_f <=threshold_t.high_f AND availability_t.id=2) OR
		(stock_t.qty_f>threshold_t.high_f AND availability_t.id=1)
	)
	;

CREATE VIEW spmhub_v AS
SELECT
	sp_t.id as sp_f,
	hub_t.name_f,
	stock_t.qty_f,
	threshold_t.low_f,
	threshold_t.high_f
FROM
	sp_t, hub_t, stock_t, threshold_t
WHERE
	stock_t.sp_f=sp_t.id AND
	stock_t.hub_f=hub_t.id AND
	threshold_t.sp_f=sp_t.id AND
	threshold_t.hub_f=hub_t.id
ORDER BY 
	hub_t.id ASC;
