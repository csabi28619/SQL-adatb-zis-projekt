-- itt a megoldás, a tényleges gyilkos található érvekkel

























































-- a gyilkos elemzése
SELECT 
    'HORVÁTH GÁBOR' AS 'A GYILKOS',
    'BIZONYÍTÉKOK:' AS 'Kategória',
    '' AS 'Részletek'

UNION ALL

SELECT 
    '1. MOTÍVUM' AS 'A GYILKOS',
    'Pénzügyi és hatalmi' AS 'Kategória',
    'Ügyvezető pozíció, titkokhoz hozzáférés, manipulatív személyiség' AS 'Részletek'

UNION ALL

SELECT 
    '2. LEHETŐSÉG' AS 'A GYILKOS',
    'Teljes hozzáférés' AS 'Kategória',
    '12 éve a csoportban, minden titkot ismer, ügyvezető jogkörök' AS 'Részletek'

UNION ALL

SELECT 
    '3. VISELKEDÉS' AS 'A GYILKOS',
    'Gyanús tevékenységek' AS 'Kategória',
    'Titokzatos telefonálás, ismeretlen címekkel levelezés' AS 'Részletek'

UNION ALL

SELECT 
    '4. VÉDELEM GYENGESÉGE' AS 'A GYILKOS',
    'Legalacsonyabb hitelesség' AS 'Kategória',
    'Védekező állítása csak 4/10 hitelesség - a leggyengébb!' AS 'Részletek'

UNION ALL

SELECT 
    '5. TÖBBSZÖRÖS GYANÚSÍTÁS' AS 'A GYILKOS',
    'Két detektív is gyanakszik' AS 'Kategória',
    'Nagy Mária és Papp Ildikó is gyanús viselkedést jelentett' AS 'Részletek'

UNION ALL

SELECT 
    '6. KAPCSOLATOK' AS 'A GYILKOS',
    'Ellenségek és bizalmatlanság' AS 'Kategória',
    'Nagy Mária ellenség (3/10 bizalom), Varga László gyanakszik (3/10)' AS 'Részletek';
