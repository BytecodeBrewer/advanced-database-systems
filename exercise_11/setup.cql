-- 1. Keyspace anlegen
CREATE KEYSPACE IF NOT EXISTS UEBUNG11
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};
USE UEBUNG11;

-- 2. Tabelle mit STATIC titel-Spalte anlegen
DROP TABLE IF EXISTS ARTIKEL;
CREATE TABLE IF NOT EXISTS ARTIKEL (
  id int,
  datum timestamp,
  titel text STATIC,
  art text,
  text text,
  version text,
  autor text,
  status text,
  schlagworte set<text>,
  PRIMARY KEY (id, datum)
);

-- 3. Datensätze einfügen
INSERT INTO ARTIKEL (id, datum, titel, art, text, version)
VALUES (1, '2021-12-10 10:34:00+0000', 'Workshop on Scientific Writing', 'Seite', 'Grundlagen ...', 'Vorschau');

INSERT INTO ARTIKEL (id, datum, titel, art, text, version)
VALUES (1, '2021-12-10 11:03:00+0000', 'Workshop on Scientific Writing', 'Seite', 'Grundlagen ...', 'Arbeitskopie');

INSERT INTO ARTIKEL (id, datum, titel, art, text, version)
VALUES (2, '2021-12-10 10:29:00+0000', 'wsw_programm.pdf', 'Datei', null, null);

-- 4. Weitere Spalten ergänzen und Datensatz für ID 3 einfügen
INSERT INTO ARTIKEL (id, datum, titel, art, autor, status, text)
VALUES (3, '2021-09-15 13:07:00+0000', 'Stundenplan WS2021', 'Nachricht', 'Meinhold', 'public', 'Anderungen ...');

-- 5. Datenänderung für Autor/Status
UPDATE ARTIKEL SET autor='riechert', status='privat'
WHERE id=1 AND datum='2021-12-10 10:34:00+0000';

UPDATE ARTIKEL SET autor='Admin', status='public'
WHERE id=1 AND datum='2021-12-10 11:03:00+0000';

-- 6. Collections (Schlagworte) hinzufügen
UPDATE ARTIKEL SET schlagworte = {'Workshop', 'Schreiben', 'Riechert'}
WHERE id=1 AND datum='2021-12-10 11:03:00+0000';

UPDATE ARTIKEL SET schlagworte = schlagworte - {'Riechert'}
WHERE id=1 AND datum='2021-12-10 11:03:00+0000';

-- 7. Abfragen

-- a. Verschiedene Artikel-IDs
SELECT DISTINCT id FROM ARTIKEL;

-- b. Anzahl Versionen von Artikel 1
SELECT COUNT(*) FROM ARTIKEL WHERE id=1;

-- c. Alle verschiedenen Titel
SELECT DISTINCT titel FROM ARTIKEL;
-- Es funktionier leider nicht, trotz einer STATIC Spalte.

-- d. Alle Versionen des Artikels 1
SELECT * FROM ARTIKEL WHERE id=1;

-- e. Alle Artikel von Autor RIECHERT
SELECT * FROM ARTIKEL WHERE autor='riechert' ALLOW FILTERING;

-- f. Artikel mit ID 2 oder 3
SELECT * FROM ARTIKEL WHERE id IN (2,3);
