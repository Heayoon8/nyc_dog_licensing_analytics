WITH incident_addresses AS (
  SELECT DISTINCT
    incident_address,
    CAST(NULL AS STRING) AS street_name,
    CAST(NULL AS STRING) AS address_type,
    CAST(NULL AS STRING) AS city,
    CAST(NULL AS STRING) AS community_board,
    CAST(NULL AS STRING) AS council_district
  FROM {{ ref('stg_nyc_311_dot') }}
  WHERE incident_address IS NOT NULL
),

final AS (
  SELECT
    {{ dbt_utils.generate_surrogate_key([
      'incident_address',
      'street_name',
      'address_type',
      'city',
      'community_board',
      'council_district'
    ]) }} AS incident_address_key,
    incident_address,
    street_name,
    address_type,
    city,
    community_board,
    council_district
  FROM incident_addresses
)

SELECT *
FROM final