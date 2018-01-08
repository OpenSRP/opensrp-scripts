﻿-- Create facility_encounter_report table to hold the different  encounters

CREATE TABLE facility_encounter_report (
  encounter_id varchar(50) NOT NULL UNIQUE,
  encounter_date varchar(40) DEFAULT NULL,
  zeir_id varchar(20) DEFAULT NULL,
  gender varchar(10) DEFAULT NULL,
  dob date DEFAULT NULL,
  mother_id varchar(26) DEFAULT NULL,
  child_hiv_expo varchar(20) DEFAULT NULL,
  fac_id integer DEFAULT NULL,
  fac_name varchar(100) DEFAULT NULL,
  district_id integer DEFAULT NULL,
  district_name varchar(100) DEFAULT NULL,
  province_id integer DEFAULT NULL,
  province_name varchar(100) DEFAULT NULL,
  provider_id integer DEFAULT NULL,
  provider_name varchar(100) DEFAULT NULL,
  child_weighed smallint DEFAULT NULL,
  child_weight varchar(45) DEFAULT NULL,
  z_score varchar(100) DEFAULT NULL,
  BCG1 smallint DEFAULT NULL,
  OPV0 smallint DEFAULT NULL,
  OPV1 smallint DEFAULT NULL,
  PCV1 smallint DEFAULT NULL,
  Penta1 smallint DEFAULT NULL,
  Rota1 smallint DEFAULT NULL,
  OPV2 smallint DEFAULT NULL,
  PCV2 smallint DEFAULT NULL,
  Penta2 smallint DEFAULT NULL,
  Rota2 smallint DEFAULT NULL,
  OPV3 smallint DEFAULT NULL,
  PCV3 smallint DEFAULT NULL,
  Penta3 smallint DEFAULT NULL,
  Measles1 smallint DEFAULT NULL,
  MR1 smallint DEFAULT NULL,
  OPV4 smallint DEFAULT NULL,
  Measles2 smallint DEFAULT NULL,
  MR2 smallint DEFAULT NULL,
  BCG2 smallint DEFAULT NULL,
  vitamin_a smallint DEFAULT NULL,
  mebendezol smallint DEFAULT NULL,
  PRIMARY KEY (encounter_id)
)