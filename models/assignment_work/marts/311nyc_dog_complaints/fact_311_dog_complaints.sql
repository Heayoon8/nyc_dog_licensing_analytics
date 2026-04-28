-- Fact table for 311 dog complaints
-- Grain: one row per complaint

WITH source AS (
  SELECT *
  FROM {{ ref('stg_311nyc_dog_complaints') }}
),

final AS (
  SELECT
    request_id AS unique_key,

    -- Incident Address Key (simplified)
    {{ dbt_utils.generate_surrogate_key([
      'incident_address'
    ]) }} AS incident_address_key,

    -- Location Key
    {{ dbt_utils.generate_surrogate_key([
      'latitude',
      'longitude'
    ]) }} AS location_id,

    -- Complaint Type Key
    {{ dbt_utils.generate_surrogate_key([
      'complaint_type',
      'descriptor',
      'status'
    ]) }} AS complaint_type_key,

    -- Agency Key
    {{ dbt_utils.generate_surrogate_key([
      'agency_name'
    ]) }} AS agency_key,

    -- Zipcode Key
    {{ dbt_utils.generate_surrogate_key([
      'incident_zip',
      'borough'
    ]) }} AS zipcode_key,

    -- Date Key
    {{ dbt_utils.generate_surrogate_key([
      'created_date'
    ]) }} AS created_date_key,

    -- Location Type (dummy)
    {{ dbt_utils.generate_surrogate_key([
      "'UNKNOWN'"
    ]) }} AS location_type_key,

    latitude,
    longitude

  FROM source
)

SELECT *
FROM final