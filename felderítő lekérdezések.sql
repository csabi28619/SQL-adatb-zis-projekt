-- 1. Milyen vádak vagy gyanúsítások hangzottak el?
SELECT DISTINCT 
    gm.name AS 'Kikérdezett neve',
    d.name AS 'Detektív neve',
    i.statement AS 'Állítás',
    i.statement_type AS 'Állítás típusa',
    i.credibility_score AS 'Hitelesség (1-10)',
    i.interrogation_date AS 'Kikérdezés dátuma'
FROM interrogations i
JOIN group_members gm ON i.member_id = gm.id
JOIN detectives d ON i.detective_id = d.id
WHERE i.statement_type IN ('accusation', 'suspicion')
ORDER BY gm.name, i.interrogation_date;

-- 2. Ki a leggyanúsabb a titkokhoz való hozzáféréseik és pénzügyi helyzetük alapján?
SELECT 
    name AS 'Név',
    occupation AS 'Beosztás',
    has_access_to_secrets AS 'Titkokhoz hozzáférés',
    financial_status AS 'Pénzügyi helyzet',
    years_in_group AS 'Évek a csoportban',
    personality_trait AS 'Személyiségjegy',
    CASE 
        WHEN has_access_to_secrets = TRUE AND financial_status = 'poor' THEN 'NAGYON GYANÚS'
        WHEN has_access_to_secrets = TRUE AND financial_status = 'middle' THEN 'GYANÚS'
        WHEN has_access_to_secrets = TRUE AND financial_status = 'wealthy' THEN 'KÖZEPESEN GYANÚS'
        ELSE 'KEVÉSBÉ GYANÚS'
    END AS 'Gyanú szint'
FROM group_members
ORDER BY 
    has_access_to_secrets DESC,
    FIELD(financial_status, 'poor', 'middle', 'wealthy');

-- 3. Ellentmondások keresése az alibikben
WITH alibi_statements AS (
    SELECT 
        i.member_id,
        gm.name,
        i.statement,
        i.credibility_score,
        i.detective_id,
        d.name as detective_name
    FROM interrogations i
    JOIN group_members gm ON i.member_id = gm.id
    JOIN detectives d ON i.detective_id = d.id
    WHERE i.statement_type = 'alibi'
),
contradictions AS (
    SELECT 
        i1.member_id,
        gm.name,
        i1.statement as original_statement,
        i2.statement as contradicting_statement,
        i1.credibility_score as original_credibility,
        i2.credibility_score as contradicting_credibility,
        d1.name as detective1,
        d2.name as detective2
    FROM interrogations i1
    JOIN interrogations i2 ON i1.member_id != i2.member_id
    JOIN group_members gm ON i1.member_id = gm.id
    JOIN detectives d1 ON i1.detective_id = d1.id
    JOIN detectives d2 ON i2.detective_id = d2.id
    WHERE i1.statement_type IN ('alibi', 'defense') 
    AND i2.statement_type IN ('observation', 'accusation')
    AND (
        (i1.member_id = 1 AND i2.member_id = 3) OR  -- Kovács vs Szabó
        (i1.member_id = 3 AND i2.member_id = 1)     -- Szabó vs Kovács
    )
)
SELECT * FROM contradictions
UNION ALL
SELECT 
    'ALIBI ELEMZÉS' as member_id,
    '==================' as name,
    'Kovács János állítása: Szabó Péter is ott volt pénteken' as original_statement,
    'Kovács János megfigyelése: Szabó korábban távozott, mint mondta' as contradicting_statement,
    8 as original_credibility,
    9 as contradicting_credibility,
    'Sherlock Holmes' as detective1,
    'Columbo' as detective2;

-- 4. Leggyanakvóbb személyek a kapcsolatok alapján
SELECT 
    gm.name AS 'Név',
    COUNT(mr.target_member_id) AS 'Hányan gyanakszanak rá',
    AVG(mr.trust_level) AS 'Átlagos bizalmi szint',
    GROUP_CONCAT(
        CONCAT(gm2.name, ' (', mr.relationship_type, ', bizalom: ', mr.trust_level, ')')
        SEPARATOR '; '
    ) AS 'Kapcsolatok részletei'
FROM group_members gm
LEFT JOIN member_relationships mr ON gm.id = mr.target_member_id
LEFT JOIN group_members gm2 ON mr.member_id = gm2.id
WHERE mr.relationship_type IN ('enemy', 'suspicious') OR mr.trust_level <= 5
GROUP BY gm.id, gm.name
HAVING COUNT(mr.target_member_id) > 0
ORDER BY COUNT(mr.target_member_id) DESC, AVG(mr.trust_level) ASC;


-- 5. Védekező állítások vs. rájuk vonatkozó vádak

-- a védekező állítások
WITH defense_statements AS (
    SELECT 
        gm.name AS person_name,
        i.statement AS defense_statement,
        i.credibility_score AS defense_credibility,
        d.name AS detective_name
    FROM interrogations i
    JOIN group_members gm ON i.member_id = gm.id
    JOIN detectives d ON i.detective_id = d.id
    WHERE i.statement_type = 'defense'
),

-- a vádakat és gyanúsításokat név szerint
accusations_by_name AS (
    SELECT 
        'Horváth Gábor' AS accused_person,
        gm.name AS accuser,
        i.statement AS accusation,
        i.credibility_score AS accusation_credibility,
        i.statement_type
    FROM interrogations i
    JOIN group_members gm ON i.member_id = gm.id
    WHERE (i.statement LIKE '%Horváth Gábor%' OR i.statement LIKE '%Horváth%') 
    AND i.statement_type IN ('accusation', 'suspicion')
    
    UNION ALL
    
    SELECT 
        'Szabó Péter' AS accused_person,
        gm.name AS accuser,
        i.statement AS accusation,
        i.credibility_score AS accusation_credibility,
        i.statement_type
    FROM interrogations i
    JOIN group_members gm ON i.member_id = gm.id
    WHERE (i.statement LIKE '%Szabó Péter%' OR i.statement LIKE '%Szabó%') 
    AND i.statement_type IN ('accusation', 'suspicion', 'observation')
    
    UNION ALL
    
    SELECT 
        'Molnár Zsuzsanna' AS accused_person,
        gm.name AS accuser,
        i.statement AS accusation,
        i.credibility_score AS accusation_credibility,
        i.statement_type
    FROM interrogations i
    JOIN group_members gm ON i.member_id = gm.id
    WHERE (i.statement LIKE '%Molnár Zsuzsanna%' OR i.statement LIKE '%Molnár%') 
    AND i.statement_type IN ('accusation', 'suspicion', 'observation')
    
    UNION ALL
    
    SELECT 
        'Kiss Éva' AS accused_person,
        gm.name AS accuser,
        i.statement AS accusation,
        i.credibility_score AS accusation_credibility,
        i.statement_type
    FROM interrogations i
    JOIN group_members gm ON i.member_id = gm.id
    WHERE (i.statement LIKE '%Kiss Éva%' OR i.statement LIKE '%Kiss%') 
    AND i.statement_type IN ('accusation', 'suspicion')
    
    UNION ALL
    
    SELECT 
        'Varga László' AS accused_person,
        gm.name AS accuser,
        i.statement AS accusation,
        i.credibility_score AS accusation_credibility,
        i.statement_type
    FROM interrogations i
    JOIN group_members gm ON i.member_id = gm.id
    WHERE (i.statement LIKE '%Varga László%' OR i.statement LIKE '%Varga%') 
    AND i.statement_type IN ('accusation', 'suspicion')
    
    UNION ALL
    
    SELECT 
        'Németh Róbert' AS accused_person,
        gm.name AS accuser,
        i.statement AS accusation,
        i.credibility_score AS accusation_credibility,
        i.statement_type
    FROM interrogations i
    JOIN group_members gm ON i.member_id = gm.id
    WHERE (i.statement LIKE '%Németh Róbert%' OR i.statement LIKE '%Németh%') 
    AND i.statement_type IN ('accusation', 'suspicion')
),

accusations_summary AS (
    SELECT 
        accused_person,
        COUNT(*) AS accusation_count,
        AVG(accusation_credibility) AS avg_accusation_credibility,
        GROUP_CONCAT(
            CONCAT(accuser, ' (', statement_type, ', hitelesség: ', accusation_credibility, '): ', 
                   LEFT(accusation, 80), '...')
            SEPARATOR ' | '
        ) AS all_accusations
    FROM accusations_by_name
    GROUP BY accused_person
)

SELECT 
    ds.person_name AS 'Személy neve',
    ds.defense_statement AS 'Védekező állítás',
    ds.defense_credibility AS 'Védelem hitelessége (1-10)',
    ds.detective_name AS 'Védelem előtt (detektív)',
    COALESCE(acs.accusation_count, 0) AS 'Vádak száma',
    ROUND(acs.avg_accusation_credibility, 1) AS 'Vádak átlag hitelessége',
    acs.all_accusations AS 'Vádak részletei',
    CASE 
        WHEN ds.defense_credibility IS NOT NULL AND acs.avg_accusation_credibility IS NOT NULL THEN
            CASE 
                WHEN ds.defense_credibility > acs.avg_accusation_credibility THEN 'Védelem erősebb'
                WHEN ds.defense_credibility < acs.avg_accusation_credibility THEN 'Vádak erősebbek'
                ELSE 'Kiegyenlített'
            END
        WHEN ds.defense_credibility IS NOT NULL AND acs.avg_accusation_credibility IS NULL THEN 'Csak védelem van'
        ELSE 'Nincs védelem'
    END AS 'Helyzet értékelése'
FROM defense_statements ds
LEFT JOIN accusations_summary acs ON ds.person_name = acs.accused_person

UNION

SELECT 
    acs.accused_person AS 'Személy neve',
    'NINCS VÉDELEM!' AS 'Védekező állítás',
    NULL AS 'Védelem hitelessége (1-10)',
    NULL AS 'Védelem előtt (detektív)',
    acs.accusation_count AS 'Vádak száma',
    ROUND(acs.avg_accusation_credibility, 1) AS 'Vádak átlag hitelessége',
    acs.all_accusations AS 'Vádak részletei',
    'Csak vádak vannak - GYANÚS!' AS 'Helyzet értékelése'
FROM accusations_summary acs
LEFT JOIN defense_statements ds ON acs.accused_person = ds.person_name
WHERE ds.person_name IS NULL

ORDER BY 'Vádak száma' DESC, 'Védelem hitelessége (1-10)' ASC;

-- 6. Védekező állítások vs. rájuk vonatkozó vádak egyszerűbben
-- Egyszerűbb megközelítés, ha csak a konkrét eseteket vizsgáljuk
SELECT 
    'Szabó Péter' AS 'Személy',
    'Igen, korábban mentem el, de csak azért, mert családi programom volt.' AS 'Védekező állítás',
    5 AS 'Védelem hitelessége',
    'Szabó Péter valóban ott volt velem pénteken, de korábban távozott, mint mondta.' AS 'Ellentmondó megfigyelés',
    9 AS 'Megfigyelés hitelessége',
    'GYANÚS - nagy hitelesség különbség!' AS 'Értékelés'

UNION ALL

SELECT 
    'Molnár Zsuzsanna' AS 'Személy',
    'Az a férfi egy régi üzleti partner volt, semmi gyanús nem volt a találkozóban.' AS 'Védekező állítás',
    5 AS 'Védelem hitelessége',
    'A múlt héten láttam Molnár Zsuzsannát egy ismeretlen férfival beszélgetni a parkolóban.' AS 'Ellentmondó megfigyelés',
    6 AS 'Megfigyelés hitelessége',
    'Enyhén gyanús - kis hitelesség különbség' AS 'Értékelés'

UNION ALL

SELECT 
    'Horváth Gábor' AS 'Személy',
    'A cég érdekében mindig mindent megteszek. Ha valaki árul, az nem én vagyok.' AS 'Védekező állítás',
    4 AS 'Védelem hitelessége',
    'Gyanús telefonálás + levelezés ismeretlenekkel (2 gyanúsítás)' AS 'Ellentmondó megfigyelés',
    7.5 AS 'Megfigyelés hitelessége',
    'NAGYON GYANÚS - alacsony védelem, magas vádak!' AS 'Értékelés'

UNION ALL

SELECT 
    'Kiss Éva' AS 'Személy',
    'Nem értek ezekhez a bonyolult ügyekhez, csak az asszisztensi munkámat végzem.' AS 'Védekező állítás',
    9 AS 'Védelem hitelessége',
    'Láttam, hogy Kiss Éva fénymásol valamit éjjel' AS 'Ellentmondó megfigyelés',
    7 AS 'Megfigyelés hitelessége',
    'Védelem erősebb - kevésbé gyanús' AS 'Értékelés'

UNION ALL

SELECT 
    'Szabó Péter (IT)' AS 'Személy',
    'Nem tudom, ki lehet az áruló, de biztosan nem én vagyok.' AS 'Védekező állítás',
    6 AS 'Védelem hitelessége',
    'Varga László gyanúsan gyakran marad túlórázni egyedül.' AS 'Ellentmondó megfigyelés',
    9 AS 'Megfigyelés hitelessége',
    'Gyenge védelem - gyanús' AS 'Értékelés';

