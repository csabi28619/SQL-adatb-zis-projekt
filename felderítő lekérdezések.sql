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

-- 2. Ki a leggyanúsabb a hozzáféréseik és pénzügyi helyzetük alapján?
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
SELECT 
    i1.member_id,
    gm1.name AS 'Állító',
    i1.statement AS 'Eredeti állítás',
    i2.member_id AS 'Ellentmondó ID',
    gm2.name AS 'Ellentmondó',
    i2.statement AS 'Ellentmondó állítás'
FROM interrogations i1
JOIN interrogations i2 ON i1.id != i2.id
JOIN group_members gm1 ON i1.member_id = gm1.id
JOIN group_members gm2 ON i2.member_id = gm2.id
WHERE i1.statement_type = 'alibi' 
AND i2.statement_type = 'observation'
AND (i2.statement LIKE CONCAT('%', gm1.name, '%') OR i1.statement LIKE CONCAT('%', gm2.name, '%'));

-- 4. Leggyanakvóbb személyek a kapcsolatok alapján
SELECT 
    gm.name,
    COUNT(mr.target_member_id) AS 'Hányan gyanakodnak rá',
    AVG(mr.trust_level) AS 'Átlagos bizalmi szint'
FROM group_members gm
LEFT JOIN member_relationships mr ON gm.id = mr.target_member_id AND mr.relationship_type = 'suspicious'
GROUP BY gm.id, gm.name
HAVING COUNT(mr.target_member_id) > 0
ORDER BY COUNT(mr.target_member_id) DESC, AVG(mr.trust_level) ASC;

-- 5. Védekező állítások vs. rájuk vonatkozó vádak
SELECT 
    gm.name,
    SUM(CASE WHEN i.statement_type = 'defense' THEN 1 ELSE 0 END) AS 'Védekező állítások',
    SUM(CASE WHEN i.statement_type IN ('accusation', 'suspicion') 
             AND i.statement
