WITH locations AS (
  SELECT DISTINCT
    borough,
    zipcode
FROM {{ ref('stg_311nyc_dog_complaints') }}
WHERE borough IS NOT NULL
AND zipcode IS NOT NULL
),
final AS (
SELECT
{{ dbt_utils.generate_surrogate_key(['borough', 'zipcode']) }} AS location_id,
    ST_GEOGPOINT(borough, zipcode) AS location
FROM locations
)
SELECT *
FROM final