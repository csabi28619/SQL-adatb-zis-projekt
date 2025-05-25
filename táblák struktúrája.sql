--adatbázis létrehozása
CREATE DATABASE detectiveGame DEFAULT CHARACTER SET utf8 COLLATE utf8_hungarian_ci;

-- Csoport tagjai
CREATE TABLE group_members (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    age INT,
    height INT, -- cm-ben
    hair_color VARCHAR(50),
    eye_color VARCHAR(50),
    occupation VARCHAR(100),
    years_in_group INT,
    hometown VARCHAR(100),
    has_access_to_secrets BOOLEAN DEFAULT FALSE,
    financial_status ENUM('poor', 'middle', 'wealthy'),
    personality_trait VARCHAR(100)
);

-- Detektívek
CREATE TABLE detectives (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    years_experience INT,
    birth_year INT,
    specialization VARCHAR(100),
    success_rate DECIMAL(5,2),
    agency VARCHAR(100)
);

-- Kikérdezések/Állítások
CREATE TABLE interrogations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    detective_id INT,
    member_id INT,
    statement TEXT NOT NULL,
    statement_type ENUM('accusation', 'alibi', 'observation', 'defense', 'suspicion'),
    credibility_score INT CHECK (credibility_score BETWEEN 1 AND 10),
    interrogation_date DATE,
    FOREIGN KEY (detective_id) REFERENCES detectives(id),
    FOREIGN KEY (member_id) REFERENCES group_members(id)
);

-- Tagok közötti kapcsolatok/állítások
CREATE TABLE member_relationships (
    id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    target_member_id INT,
    relationship_type ENUM('friend', 'enemy', 'neutral', 'suspicious'),
    trust_level INT CHECK (trust_level BETWEEN 1 AND 10),
    FOREIGN KEY (member_id) REFERENCES group_members(id),
    FOREIGN KEY (target_member_id) REFERENCES group_members(id)
);
