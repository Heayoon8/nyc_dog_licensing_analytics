WITH location_types AS (
  SELECT 'UNKNOWN' AS location_type
),

final AS (
  SELECT
    {{ dbt_utils.generate_surrogate_key(['location_type']) }} AS location_type_key,
    location_type
  FROM location_types
)

SELECT *
FROM final