set lines 10000
set long 10000
set pagesize 1000

-- a
/*
SELECT XMLQuery('
<result>{
  for $m in ora:view("companyXML")//Mitarbeiter,
      $s in ora:view("salgradesXML")//Salgrade
  let $g := xs:decimal($m/Payment/Gehalt)
  where $g >= xs:decimal($s/Min) and $g <= xs:decimal($s/Max)
  order by $g
  return
    <Angestellter>
      <Name>{ $m/Name/text() }</Name>
      <Gehalt>{ $g }</Gehalt>
      <Stufe>{ $s/Stufe/text() }</Stufe>
    </Angestellter>
}</result>
' RETURNING CONTENT) AS Angestellte_mit_Stufe
FROM dual;
*/

SELECT XMLSerialize(
  CONTENT XMLQuery('
    <result>{
      for $m in ora:view("companyXML")//Mitarbeiter,
          $s in ora:view("salgradesXML")//Salgrade
      let $g := xs:decimal($m/Payment/Gehalt)
      where $g >= xs:decimal($s/Min) and $g <= xs:decimal($s/Max)
      order by $g
      return
        <Angestellter>
          <Name>{ $m/Name/text() }</Name>
          <Gehalt>{ $g }</Gehalt>
          <Stufe>{ $s/Stufe/text() }</Stufe>
        </Angestellter>
    }</result>
  ' RETURNING CONTENT)
  AS CLOB INDENT SIZE = 2
) AS Angestellte_mit_Stufe
FROM dual;

-- b
SELECT XMLQuery('
<result>{
  for $m in ora:view("companyXML")//Mitarbeiter,
      $s in ora:view("salgradesXML")//Salgrade
  let $g := xs:decimal($m/Payment/Gehalt)
  where $m/Name="SMITH"
    and $g >= xs:decimal($s/Min)
    and $g <= xs:decimal($s/Max)
  return $s/Max
}</result>
' RETURNING CONTENT) AS Obergrenze_Smith
FROM dual;

-- c
VAR aname VARCHAR2(20)
EXEC :aname := 'SMITH'

SELECT XMLQuery('
<result>{
  for $m in ora:view("companyXML")//Mitarbeiter,
      $s in ora:view("salgradesXML")//Salgrade
  let $g := xs:decimal($m/Payment/Gehalt)
  where $m/Name=$aname
    and $g >= xs:decimal($s/Min)
    and $g <= xs:decimal($s/Max)
  return $s/Max
}</result>
' PASSING :aname AS "aname" RETURNING CONTENT) AS Obergrenze_Angestellter
FROM dual;

-- d
/*
SELECT XMLQuery('
<result>{
  for $s in ora:view("salgradesXML")//Salgrade
  let $grade := $s/Stufe
  return
    <Gehaltsstufe stufe="{ $grade }">{
      for $m in ora:view("companyXML")//Mitarbeiter
      let $g := xs:decimal($m/Payment/Gehalt)
      where $g >= xs:decimal($s/Min) and $g <= xs:decimal($s/Max)
      return
        <Angestellter>
          <Name>{ $m/Name/text() }</Name>
          <Gehalt>{ $g }</Gehalt>
        </Angestellter>
    }</Gehaltsstufe>
}</result>
' RETURNING CONTENT) AS Gehaltsstufen_und_Angestellte
FROM dual;
*/

SELECT XMLSerialize(
  CONTENT XMLQuery('
    <result>{
      for $s in ora:view("salgradesXML")//Salgrade
      let $grade := $s/Stufe
      return
        <Gehaltsstufe stufe="{ $grade }">{
          for $m in ora:view("companyXML")//Mitarbeiter
          let $g := xs:decimal($m/Payment/Gehalt)
          where $g >= xs:decimal($s/Min) and $g <= xs:decimal($s/Max)
          return
            <Angestellter>
              <Name>{ $m/Name/text() }</Name>
              <Gehalt>{ $g }</Gehalt>
            </Angestellter>
        }</Gehaltsstufe>
    }</result>
  ' RETURNING CONTENT)
  AS CLOB INDENT SIZE = 2
) AS Gehaltsstufen_und_Angestellte
FROM dual;
