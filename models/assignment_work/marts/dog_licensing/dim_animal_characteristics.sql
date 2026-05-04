WITH animal_characteristics AS (
    SELECT DISTINCT
        breed_name,
        size_category,
        temperament
    FROM {{ source('raw_dog', 'Dim_Animal_CHaracteristics') }}
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