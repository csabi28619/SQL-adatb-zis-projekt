Table group_members {
  id int [pk, increment]
  name varchar(100) [not null]
  age int
  height int
  hair_color varchar(50)
  eye_color varchar(50)
  occupation varchar(100)
  years_in_group int
  hometown varchar(100)
  has_access_to_secrets boolean
  financial_status varchar(20)
  personality_trait varchar(100)
}

Table detectives {
  id int [pk, increment]
  name varchar(100) [not null]
  years_experience int
  birth_year int
  specialization varchar(100)
  success_rate decimal(5,2)
  agency varchar(100)
}

Table interrogations {
  id int [pk, increment]
  detective_id int [ref: > detectives.id]
  member_id int [ref: > group_members.id]
  statement text [not null]
  statement_type varchar(20)
  credibility_score int
  interrogation_date date
}

Table member_relationships {
  id int [pk, increment]
  member_id int [ref: > group_members.id]
  target_member_id int [ref: > group_members.id]
  relationship_type varchar(20)
  trust_level int
}