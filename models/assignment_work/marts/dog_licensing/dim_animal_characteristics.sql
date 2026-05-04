WITH animal_characteristics AS (
  SELECT DISTINCT
    breed_name,
    CAST(NULL AS STRING) AS size_category,
    CAST(NULL AS STRING) AS temperament
  FROM {{ ref('stg_nyc_dog_licensing') }}
  WHERE breed_name IS NOT NULL
),

final AS (
  SELECT
    {{ dbt_utils.generate_surrogate_key([
      'breed_name',
      'size_category',
      'temperament'
    ]) }} AS animal_characteristics_key,
    breed_name,
    size_category,
    temperament
  FROM animal_characteristics
)

SELECT *
FROM final