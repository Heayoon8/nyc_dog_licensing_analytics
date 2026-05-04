WITH animal_characteristics AS (
    SELECT DISTINCT
        breed_name,
        size_category,
        temperament
    FROM {{ ref('stg_animal_characteristics') }}  
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

SELECT * FROM final