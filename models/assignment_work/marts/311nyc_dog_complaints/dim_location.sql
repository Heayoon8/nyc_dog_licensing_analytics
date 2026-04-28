WITH locations AS (
  SELECT DISTINCT
    latitude,
    longitude
  FROM {{ ref('stg_nyc_311_dot') }}
  WHERE latitude IS NOT NULL
    AND longitude IS NOT NULL
),

final AS (
  SELECT
    {{ dbt_utils.generate_surrogate_key(['latitude', 'longitude']) }} AS location_id,
    ST_GEOGPOINT(longitude, latitude) AS location
  FROM locations
)

SELECT *
FROM final