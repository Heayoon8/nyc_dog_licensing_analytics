WITH gender_birth_year AS (
    SELECT DISTINCT
        animal_gender,
        CAST(animal_birth_year AS STRING) AS animal_birth_year
    FROM {{ ref('stg_nyc_dog_licensing') }}
    WHERE animal_gender IS NOT NULL
      AND animal_birth_year IS NOT NULL  
),

final AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key([
            'animal_gender',
            'animal_birth_year'
        ]) }} AS gender_birth_year_key,
        animal_gender,
        animal_birth_year
    FROM gender_birth_year
)

SELECT * FROM final