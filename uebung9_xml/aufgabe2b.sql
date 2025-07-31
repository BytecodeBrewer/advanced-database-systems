SELECT 
    x.mitarbeiter_id,
    x.name,
    x.beruf,
    x.manager,
    x.einstelldatum,
    x.gehalt,
    x.kommission
FROM COMPANYXML c,
     XMLTABLE(
       '/Mitarbeiterliste/Mitarbeiter'
       PASSING c.MITARBEITERLISTE
       COLUMNS
         mitarbeiter_id   NUMBER       PATH '@id',
         name             VARCHAR2(30) PATH 'Name',
         beruf            VARCHAR2(30) PATH 'Beruf',
         manager          NUMBER       PATH 'Manager',
         einstelldatum    VARCHAR2(30) PATH 'Einstelldatum',
         gehalt           NUMBER       PATH 'Payment/Gehalt',
         kommission       NUMBER       PATH 'Payment/Kommission'
     ) x;
