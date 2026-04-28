WITH incident_addresses AS (
  SELECT DISTINCT
    incident_address,
    street_name,
    address_type,
    city,
    community_board,
    council_district
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