WITH agencies AS (
  SELECT DISTINCT
    agency_name
  FROM {{ ref('stg_311nyc_dog_complaints') }}
  WHERE agency_name IS NOT NULL
),

final AS (
  SELECT
    {{ dbt_utils.generate_surrogate_key(['agency_name']) }} AS agency_key,
    agency_name
  FROM agencies
)

SELECT *
FROM final