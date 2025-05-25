-- 1. Kik ellen hangzottak el vádak vagy gyanúsítások?
SELECT 
    gm.name AS 'Gyanúsított',
    COUNT(*) AS 'Vádak száma',
    AVG(i.credibility_score) AS 'Átlagos hitelesség'
FROM interrogations i
JOIN group_members gm ON gm.name LIKE CONCAT('%', SUBSTRING_INDEX(SUBSTRING_INDEX(i.statement, ' ', 2), ' ', -1), '%')
WHERE i.statement_type IN ('accusation', 'suspicion')
GROUP BY gm.name
ORDER BY COUNT(*) DESC, AVG(i.credibility_score) DESC;

-- 2. Ki a leggyanakvóbb a hozzáférések és pénzügyi helyzet alapján?
SELECT 
    name,
    has_access_to_secrets,
    financial_status,
    personality_trait,
    CASE 
        WHEN has_access_to_secrets = TRUE AND financial_status = 'poor' THEN 'MAGAS KOCKÁZAT'
        WHEN has_access_to_secrets = TRUE AND personality_trait IN ('manipulatív', 'titokzatos', 'számító') THEN 'KÖZEPES KOCKÁZAT'
        ELSE 'ALACSONY KOCKÁZAT'
    END AS kockázati_szint
FROM group_members
ORDER BY 
    CASE 
        WHEN has_access_to_secrets = TRUE AND financial_status = 'poor' THEN 1
        WHEN has_access_to_secrets = TRUE AND personality_trait IN ('manipulatív', 'titokzatos', 'számító') THEN 2
        ELSE 3
    END;

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
