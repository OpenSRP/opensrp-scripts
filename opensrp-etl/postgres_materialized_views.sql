﻿-- creating views to hold data extracted from json jsons from couchDB

-- creating view for all OpenSRP events
DROP MATERIALIZED VIEW IF EXISTS event;
CREATE MATERIALIZED VIEW event AS
  SELECT
    json->>'_id' as event_id,
    json->>'serverVersion' as server_version,
    json->>'formSubmissionId' as form_submission_id,
    json->>'baseEntityId' as base_entity_id,
    json->>'eventDate' as event_date,
    json->>'eventType' as event_type,
    json->>'providerId' as provider_id,
    json->>'locationId' as location_id,
    json->>'dateCreated' as date_created,
    json->'identifiers'->>'OPENMRS_UUID' as uuid,
    json->'identifiers'->>'MVAC_UUID' as mvac_uuid
  FROM opensrp_mvac.core.event where json @> '{"type":"Event"}';
-- indexing event view
CREATE INDEX i_event_server_version ON event (server_version);
CREATE INDEX i_event_base_entity_id ON event (base_entity_id);
CREATE INDEX i_event_event_type ON event (event_type);
CREATE INDEX i_event_location_id ON event (location_id);
CREATE INDEX i_event_provider_id ON event (provider_id);
CREATE UNIQUE INDEX ui_event_id ON event (event_id);

-- creating view for only birth_event events
DROP MATERIALIZED VIEW IF EXISTS birth_event;
CREATE MATERIALIZED VIEW birth_event AS
SELECT
  json->>'_id' as birth_event_id,
  json->>'baseEntityId' as base_entity_id,
  json->>'eventDate' as event_date,
  json->>'providerId' as provider_id,
  json->>'locationId' as location_id,
  json->>'dateCreated' as date_created
FROM opensrp_mvac.core.event where json @> '{"type":"Event", "eventType":"Birth Registration"}';
-- indexing birth_event events
CREATE INDEX i_birth_event_id ON birth_event (birth_event_id);
CREATE INDEX i_base_entity_id ON birth_event (base_entity_id);
CREATE INDEX i_location_id ON birth_event (location_id);
CREATE INDEX i_provider_id ON birth_event (provider_id);
CREATE UNIQUE INDEX ui_birth_event_id ON birth_event (birth_event_id);

-- creating view for birth_event_obs
DROP MATERIALIZED VIEW IF EXISTS birth_event_obs;
CREATE MATERIALIZED VIEW birth_event_obs AS
SELECT
  json->>'_id' as birth_event_obs_id,
  json->> 'baseEntityId' as base_entity_id,
  elements ->> 'formSubmissionField' as form_submission_field,
  elements -> 'values'->>0 as value
FROM opensrp_mvac.core.event
  CROSS JOIN jsonb_array_elements(json->'obs') elements WHERE json @> '{"type":"Event", "eventType":"Birth Registration"}';
-- indexing birth_event_obs
CREATE INDEX i_birth_event_obs_birth_event_obs_id ON birth_event_obs (birth_event_obs_id);
CREATE INDEX i_birth_event_obs_base_entity_id ON birth_event_obs (base_entity_id);
CREATE INDEX i_birth_event_obs_form_submission_field ON birth_event_obs (form_submission_field);
CREATE INDEX i_value ON birth_event_obs (value);
CREATE UNIQUE INDEX ui_birth_event_obs_id ON birth_event_obs (birth_event_obs_id,form_submission_field);

-- creating view for only vaccination events
DROP MATERIALIZED VIEW IF EXISTS vaccination;
CREATE MATERIALIZED VIEW vaccination AS
SELECT
  json->>'_id' as vaccination_id,
  json->>'baseEntityId' as base_entity_id,
  json->>'eventDate' as event_date,
  json->>'providerId' as provider_id,
  json->>'locationId' as location_id,
  json->>'dateCreated' as date_created
FROM opensrp_mvac.core.event where json @> '{"eventType":"Vaccination"}' OR json @> '{"eventType":"Out of Area Service - Vaccination"}';
-- indexing vaccination events
CREATE INDEX i_vaccination_vaccination_id ON vaccination (vaccination_id);
CREATE INDEX i_vaccination_base_entity_id ON vaccination (base_entity_id);
CREATE INDEX i_vaccination_provider_id ON vaccination (provider_id);
CREATE INDEX i_vaccination_location_id ON vaccination (location_id);
CREATE UNIQUE INDEX ui_vaccination_id ON vaccination (vaccination_id);

-- creating view for vaccination events obs
DROP MATERIALIZED VIEW IF EXISTS vaccination_obs;
CREATE MATERIALIZED VIEW vaccination_obs AS
SELECT
  json->>'_id' as vaccination_obs_id,
  elements ->> 'formSubmissionField' as form_submission_field,
  (elements.value -> 'values'::text) ->> 0 AS value
FROM opensrp_mvac.core.event
  CROSS JOIN jsonb_array_elements(json->'obs') elements WHERE json @> '{"eventType":"Vaccination"}' OR json @> '{"eventType":"Out of Area Service - Vaccination"}';
-- indexing vaccination events obs
CREATE INDEX i_vaccination_obs_id ON vaccination_obs (vaccination_obs_id);
CREATE INDEX i_vaccination_obs_form_submission_field ON vaccination_obs (form_submission_field);
CREATE INDEX i_vaccination_obs_value ON vaccination_obs (value);
CREATE UNIQUE INDEX ui_vaccination_obs_id ON vaccination_obs (vaccination_obs_id,form_submission_field);

-- creating view for only weight events
DROP MATERIALIZED VIEW IF EXISTS growth_monitoring;
CREATE MATERIALIZED VIEW growth_monitoring AS
SELECT
  json->>'_id' as growth_monitoring_id,
  json->>'baseEntityId' as base_entity_id,
  json->>'eventDate' as event_date,
  json->>'providerId' as provider_id,
  json->>'locationId' as location_id,
  json->>'dateCreated' as date_created
FROM opensrp_mvac.core.event where json @> '{"eventType":"Growth Monitoring"}' OR json @> '{"eventType":"Out of Area Service - Growth Monitoring"}';
-- indexing weight events
CREATE INDEX i_growth_monitoring_id ON growth_monitoring (growth_monitoring_id);
CREATE INDEX i_growth_monitoring_base_entity_id ON growth_monitoring (base_entity_id);
CREATE INDEX i_growth_monitoring_provider_id ON growth_monitoring (provider_id);
CREATE INDEX i_growth_monitoring_location_id ON growth_monitoring (location_id);
CREATE UNIQUE INDEX ui_growth_monitoring_id ON growth_monitoring (growth_monitoring_id);

-- creating view for growth monitoring obs
DROP MATERIALIZED VIEW IF EXISTS growth_monitoring_obs;
CREATE MATERIALIZED VIEW growth_monitoring_obs AS
SELECT
  json->>'_id' as growth_monitoring_obs_id,
  elements ->> 'formSubmissionField' as form_submission_field,
  (elements.value -> 'values'::text) ->> 0 AS value
FROM opensrp_mvac.core.event
  CROSS JOIN jsonb_array_elements(json->'obs') elements WHERE json @> '{"eventType":"Growth Monitoring"}' OR json @> '{"eventType":"Out of Area Service - Growth Monitoring"}';
-- indexing vaccination events obs
CREATE INDEX i_growth_monitoring_obs_id ON growth_monitoring_obs (growth_monitoring_obs_id);
CREATE INDEX i_growth_monitoring_obs_form_submission_field ON growth_monitoring_obs (form_submission_field);
CREATE INDEX i_growth_monitoring_obs_value ON growth_monitoring_obs (value);
CREATE UNIQUE INDEX ui_growth_monitoring_obs_id ON growth_monitoring_obs (growth_monitoring_obs_id,form_submission_field);

-- creating view for recurring service events
DROP MATERIALIZED VIEW IF EXISTS recurring_service;
CREATE MATERIALIZED VIEW recurring_service AS
SELECT
  json->>'_id' as service_id,
  json->>'baseEntityId' as base_entity_id,
  json->>'eventDate' as event_date,
  json->>'providerId' as provider_id,
  json->>'locationId' as location_id,
  json->>'dateCreated' as date_created
FROM opensrp_mvac.core.event where json @> '{"type":"Event", "eventType":"Recurring Service"}';
-- indexing
CREATE INDEX i_service_id ON recurring_service (service_id);
CREATE INDEX i_recurring_service_base_entity_id ON recurring_service (base_entity_id);
CREATE INDEX i_recurring_service_provider_id ON recurring_service (provider_id);
CREATE INDEX i_recurring_service_location_id ON recurring_service (location_id);
CREATE UNIQUE INDEX ui_recurring_service_id ON recurring_service (service_id);

-- creating view for recurring service events obs
DROP MATERIALIZED VIEW IF EXISTS recurring_service_obs;
CREATE MATERIALIZED VIEW recurring_service_obs AS
SELECT
  json->>'_id' as recurring_service_obs_id,
  elements ->> 'formSubmissionField' as form_submission_field,
  (elements.value -> 'values'::text) ->> 0 AS value
FROM opensrp_mvac.core.event
  CROSS JOIN jsonb_array_elements(json->'obs') elements WHERE json @> '{"type":"Event", "eventType":"Recurring Service"}';
-- indexing recurring service events obs
CREATE INDEX i_recurring_service_obs_id ON recurring_service_obs (recurring_service_obs_id);
CREATE INDEX i_recurring_service_obs_form_submission_field ON recurring_service_obs (form_submission_field);
CREATE INDEX i_recurring_service_obs_value ON recurring_service_obs (value);
CREATE UNIQUE INDEX ui_recurring_service_obs_id ON recurring_service_obs (recurring_service_obs_id,form_submission_field);

-- creating view for client
DROP MATERIALIZED VIEW IF EXISTS client;
CREATE MATERIALIZED VIEW client AS
SELECT
  json->>'_id' as client_id,
  json->>'serverVersion' as server_version,
  json->>'baseEntityId' as base_entity_id,
  json->>'dateCreated' as date_created,
  json->'identifiers'->>'ZEIR_ID' as zeir_id,
  json->'identifiers'->>'MVAC_UNDER_5_ID' as MVAC_UNDER_5_ID,
  json->'identifiers'->>'EPI ID' as epi_id,
  json->'identifiers'->>'Program Client ID' as program_client_id,
  json->'identifiers'->>'M_ZEIR_ID' as m_zeir_id,
  json->>'firstName' as first_name,
  json->>'middleName' as middle_name,
  json->>'lastName' as last_name,
  json->>'gender' as gender,
  json->>'birthdate' as birth_date,
  json->>'deathdate' as death_date,
  json->'addresses'->0->'addressFields'->>'address3' as health_facility,
  json->'addresses'->0->'addressFields'->>'address2' as residential_address,
  json->'attributes'->>'Home_Facility' as home_facility,
  json->'attributes'->>'registration_App' as registration_app,
  json->'relationships'->'mother'->>0 as mother
FROM opensrp_mvac.core.client where json @> '{"type":"Client"}';
-- indexing client
CREATE INDEX i_server_version ON client (server_version);
CREATE INDEX i_client_id ON client (base_entity_id);
CREATE INDEX i_death_date ON client (death_date);
CREATE INDEX i_mother_id ON client (mother);
CREATE UNIQUE INDEX ui_client_id ON client (client_id);

-- creating view for only Death events
DROP MATERIALIZED VIEW IF EXISTS death_event;
CREATE MATERIALIZED VIEW death_event AS
SELECT
  json->>'_id' as death_event_id,
  json->>'baseEntityId' as base_entity_id,
  json->>'eventDate' as event_date,
  json->>'providerId' as provider_id,
  json->>'locationId' as location_id,
  json->>'dateCreated' as date_created
FROM opensrp_mvac.core.event where json @> '{"type":"Event", "eventType":"Death"}';
-- indexing Death events
CREATE INDEX i_death_event_id ON death_event (death_event_id);
CREATE INDEX i_death_event_base_entity_id ON death_event (base_entity_id);
CREATE INDEX i_death_event_location_id ON death_event (location_id);
CREATE INDEX i_death_event_provider_id ON death_event (provider_id);
CREATE UNIQUE INDEX ui_death_event_id ON death_event (death_event_id);

-- creating view for Death_event_obs
DROP MATERIALIZED VIEW IF EXISTS death_event_obs;
CREATE MATERIALIZED VIEW death_event_obs AS
SELECT
  json->>'_id' as death_event_obs_id,
  json->> 'baseEntityId' as base_entity_id,
  elements ->> 'formSubmissionField' as form_submission_field,
  elements -> 'values'->>0 as value
FROM opensrp_mvac.core.event
  CROSS JOIN jsonb_array_elements(json->'obs') elements WHERE json @> '{"type":"Event", "eventType":"Death"}';
-- indexing death_event_obs
CREATE INDEX i_death_event_obs_id ON death_event_obs (death_event_obs_id);
CREATE INDEX i_death_event_obs_base_entity ON death_event_obs (base_entity_id);
CREATE INDEX i_death_event_obs_form_submission_field ON death_event_obs (form_submission_field);
CREATE INDEX i_death_event_value ON death_event_obs (value);
CREATE UNIQUE INDEX ui_death_event_obs_id ON death_event_obs (death_event_obs_id,form_submission_field);

-- creating view for only AEFI events
DROP MATERIALIZED VIEW IF EXISTS AEFI_event;
CREATE MATERIALIZED VIEW AEFI_event AS
SELECT
  json->>'_id' as AEFI_event_id,
  json->>'baseEntityId' as base_entity_id,
  json->>'eventDate' as event_date,
  json->>'providerId' as provider_id,
  json->>'locationId' as location_id,
  json->>'dateCreated' as date_created
FROM opensrp_mvac.core.event where json @> '{"type":"Event", "eventType":"AEFI"}';
-- indexing AEFI events
CREATE INDEX i_AEFI_event_id ON AEFI_event (AEFI_event_id);
CREATE INDEX i_AEFI_base_entity_id ON AEFI_event (base_entity_id);
CREATE INDEX i_AEFI_location_id ON AEFI_event (location_id);
CREATE INDEX i_AEFI_provider_id ON AEFI_event (provider_id);
CREATE UNIQUE INDEX ui_AEFI_event_id ON AEFI_event (AEFI_event_id);

-- creating view for AEFI_event_obs
DROP MATERIALIZED VIEW IF EXISTS AEFI_event_obs;
CREATE MATERIALIZED VIEW AEFI_event_obs AS
SELECT
  json->>'_id' as AEFI_event_obs_id,
  json->> 'baseEntityId' as base_entity_id,
  elements ->> 'formSubmissionField' as form_submission_field,
  elements -> 'values'->>0 as value
FROM opensrp_mvac.core.event
  CROSS JOIN jsonb_array_elements(json->'obs') elements WHERE json @> '{"type":"Event", "eventType":"AEFI"}';
-- indexing AEFI_event_obs
CREATE INDEX i_AEFI_event_obs_id ON AEFI_event_obs (AEFI_event_obs_id);
CREATE INDEX i_AEFI_event_obs_base_entity_id ON AEFI_event_obs (base_entity_id);
CREATE INDEX i_AEFI_event_obs_form_submission_field ON AEFI_event_obs (form_submission_field);
CREATE INDEX i_AEFI_value ON AEFI_event_obs (value);
CREATE UNIQUE INDEX ui_AEFI_event_obs_id ON AEFI_event_obs (AEFI_event_obs_id,form_submission_field);

