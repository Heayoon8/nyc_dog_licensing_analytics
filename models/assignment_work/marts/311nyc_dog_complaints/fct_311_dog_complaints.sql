-- Fact table for 311 dog-related complaints
-- Grain: one row per 311 complaint

WITH source AS (
  SELECT *
  FROM {{ ref('stg_nyc_311_dot') }}
),

final AS (
  SELECT
    request_id AS unique_key,

    {{ dbt_utils.generate_surrogate_key(['incident_zip', 'borough']) }} AS zipcode_key,
    {{ dbt_utils.generate_surrogate_key(['complaint_type', 'descriptor']) }} AS complaint_type_key,
    {{ dbt_utils.generate_surrogate_key(['agency']) }} AS agency_key,
    {{ dbt_utils.generate_surrogate_key(['created_date']) }} AS created_date_key,

    latitude,
    longitude

  FROM source
)

SELECT *
FROM final