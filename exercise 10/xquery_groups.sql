set lines 10000
set long 10000
set pagesize 1000

SELECT XMLSerialize(
  CONTENT XMLQuery('
    <result>{
      for $a in ora:view("companyXML")//Mitarbeiterliste
      let $anz := count($a/Mitarbeiter)
      return
        <Abteilung>
          <AbtNr>{ $a/@abteilung }</AbtNr>
          <AnzAngest>{ $anz }</AnzAngest>
        </Abteilung>
    }</result>
  ' RETURNING CONTENT)
  AS CLOB INDENT SIZE = 2
) AS Angestellte_pro_Abteilung
FROM dual;

SELECT XMLSerialize(
  CONTENT XMLQuery('
    <result>{
      let $alle :=
        for $a in ora:view("companyXML")//Mitarbeiterliste
        let $anz := count($a/Mitarbeiter)
        return
          <Abteilung>
            <AbtNr>{ $a/@abteilung }</AbtNr>
            <AnzAngest>{ $anz }</AnzAngest>
          </Abteilung>
      return
        for $b in $alle
        where $b/AnzAngest = max($alle/AnzAngest)
        return $b
    }</result>
  ' RETURNING CONTENT)
  AS CLOB INDENT SIZE = 2
) AS Abteilung_mit_meisten_Angestellten
FROM dual;
