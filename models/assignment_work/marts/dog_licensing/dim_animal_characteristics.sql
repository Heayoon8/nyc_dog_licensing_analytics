WITH animal_characteristics AS (
    SELECT DISTINCT
        breed_name,
        size_category,
        temperament
    FROM {{ ref('stg_animal_characteristics') }}
    WHERE breed_name IS NOT NULL
),

dog_licensing AS (
    SELECT DISTINCT
        breed_rc AS breed_name,       
        animal_gender,
        animal_birth_year
    FROM {{ ref('stg_nyc_dog_licensing') }}
    WHERE breed_rc IS NOT NULL
),


joined AS (
    SELECT
        ac.breed_name,
        ac.size_category,
        ac.temperament,
        dl.animal_gender,             
        dl.animal_birth_year         
    FROM animal_characteristics AS ac
    LEFT JOIN dog_licensing AS dl
        ON ac.breed_name = dl.breed_name
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
        temperament,
        animal_gender,
        animal_birth_year
    FROM joined
)

SELECT * FROM final