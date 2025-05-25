-- tagok
INSERT INTO group_members (name, age, height, hair_color, eye_color, occupation, years_in_group, hometown, has_access_to_secrets, financial_status, personality_trait) VALUES
('Kovács János', 35, 180, 'barna', 'kék', 'könyvelő', 5, 'Budapest', TRUE, 'middle', 'introvertált'),
('Nagy Mária', 28, 165, 'szőke', 'zöld', 'marketing szakértő', 3, 'Debrecen', TRUE, 'wealthy', 'ambiciózus'),
('Szabó Péter', 42, 175, 'fekete', 'barna', 'IT vezető', 8, 'Szeged', TRUE, 'wealthy', 'titokzatos'),
('Tóth Anna', 31, 170, 'vörös', 'kék', 'HR igazgató', 6, 'Pécs', TRUE, 'middle', 'barátságos'),
('Varga László', 39, 185, 'ősz', 'szürke', 'biztonsági főnök', 10, 'Győr', TRUE, 'middle', 'gyanakvó'),
('Kiss Éva', 26, 160, 'barna', 'barna', 'asszisztens', 2, 'Miskolc', FALSE, 'poor', 'naiv'),
('Horváth Gábor', 45, 178, 'kopasz', 'kék', 'ügyvezető', 12, 'Budapest', TRUE, 'wealthy', 'manipulatív'),
('Molnár Zsuzsanna', 33, 168, 'szőke', 'zöld', 'pénzügyi igazgató', 7, 'Kecskemét', TRUE, 'wealthy', 'számító'),
('Farkas Tamás', 29, 182, 'barna', 'barna', 'fejlesztő', 4, 'Nyíregyháza', FALSE, 'middle', 'csendes'),
('Balogh Katalin', 37, 172, 'fekete', 'szürke', 'jogi tanácsadó', 9, 'Szombathely', TRUE, 'middle', 'precíz'),
('Németh Róbert', 41, 177, 'barna', 'kék', 'értékesítési vezető', 6, 'Eger', TRUE, 'wealthy', 'karizmatikus'),
('Papp Ildikó', 30, 163, 'vörös', 'zöld', 'kommunikációs vezető', 5, 'Sopron', FALSE, 'middle', 'kreatív');

-- detektívek
INSERT INTO detectives (name, years_experience, birth_year, specialization, success_rate, agency) VALUES
('Sherlock Holmes', 25, 1970, 'logikai következtetés', 95.50, 'Baker Street Detectives'),
('Hercule Poirot', 30, 1965, 'pszichológiai profil', 92.30, 'Orient Express Investigation'),
('Miss Marple', 20, 1975, 'emberi természet', 88.70, 'Village Mysteries Ltd'),
('Columbo', 35, 1960, 'részletek megfigyelése', 91.20, 'LAPD Consulting');

-- kikérdezések/állítások
INSERT INTO interrogations (detective_id, member_id, statement, statement_type, credibility_score, interrogation_date) VALUES
-- Sherlock Holmes kikérdezései
(1, 1, 'Pénteken este 8-kor még az irodában voltam, a könyvelést fejeztem be. Szabó Péter is ott volt.', 'alibi', 8, '2024-01-15'),
(1, 2, 'Gyanús, hogy Horváth Gábor mostanában sokat telefonál, és mindig elhallgat, amikor közeledek.', 'suspicion', 7, '2024-01-15'),
(1, 3, 'Nem tudom, ki lehet az áruló, de biztosan nem én vagyok. A rendszerekhez való hozzáférésem miatt könnyű rám gyanakodni.', 'defense', 6, '2024-01-15'),
(1, 4, 'Molnár Zsuzsanna az utóbbi időben nagyon ideges, és furcsán viselkedik a pénzügyi megbeszéléseken.', 'observation', 8, '2024-01-15'),

-- Hercule Poirot kikérdezései
(2, 5, 'Mint biztonsági főnök, mindenkit figyelek. Varga László gyanúsan gyakran marad túlórázni egyedül.', 'accusation', 9, '2024-01-16'),
(2, 6, 'Nem értek ezekhez a bonyolult ügyekhez, csak az asszisztensi munkámat végzem.', 'defense', 9, '2024-01-16'),
(2, 7, 'A cég érdekében mindig mindent megteszek. Ha valaki árul, az nem én vagyok.', 'defense', 4, '2024-01-16'),
(2, 8, 'Láttam, hogy Kiss Éva fénymásol valamit éjjel, amikor azt hitte, senki sincs az irodában.', 'accusation', 7, '2024-01-16'),

-- Miss Marple kikérdezései
(3, 9, 'Farkas Tamás nagyon csendes típus, de mostanában még zárkózottabb lett.', 'observation', 6, '2024-01-17'),
(3, 10, 'Jogi szempontból minden dokumentumot ellenőrzök. Németh Róbert szerződései között találtam furcsaságokat.', 'suspicion', 8, '2024-01-17'),
(3, 11, 'Az értékesítési adatok alapján minden rendben van a részemről.', 'defense', 7, '2024-01-17'),
(3, 12, 'A kommunikációs csatornákat figyelve Horváth Gábor sokat levelezik ismeretlen címekkel.', 'suspicion', 8, '2024-01-17'),

-- Columbo kikérdezései
(4, 1, 'Szabó Péter valóban ott volt velem pénteken, de korábban távozott, mint mondta.', 'observation', 9, '2024-01-18'),
(4, 3, 'Igen, korábban mentem el, de csak azért, mert családi programom volt.', 'defense', 5, '2024-01-18'),
(4, 7, 'A múlt héten láttam Molnár Zsuzsannát egy ismeretlen férfival beszélgetni a parkolóban.', 'suspicion', 6, '2024-01-18'),
(4, 8, 'Az a férfi egy régi üzleti partner volt, semmi gyanús nem volt a találkozóban.', 'defense', 5, '2024-01-18');

-- tagok közötti kapcsolatok
INSERT INTO member_relationships (member_id, target_member_id, relationship_type, trust_level) VALUES
(1, 3, 'friend', 8),
(2, 7, 'enemy', 3),
(3, 7, 'neutral', 5),
(4, 8, 'suspicious', 4),
(5, 7, 'suspicious', 3),
(6, 8, 'friend', 7),
(7, 8, 'friend', 6),
(9, 3, 'friend', 8),
(10, 11, 'suspicious', 4),
(11, 7, 'neutral', 5);
