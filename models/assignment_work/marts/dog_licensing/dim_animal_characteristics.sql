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
        breed_name      
    FROM {{ ref('stg_nyc_dog_licensing') }}
    WHERE breed_name IS NOT NULL
),


joined AS (
    SELECT
        COALESCE(ac.breed_name, dl.breed_name) AS breed_name,
        ac.size_category,
        ac.temperament
    FROM animal_characteristics AS ac
    FULL OUTER JOIN dog_licensing AS dl
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
        temperament
    FROM joined
)

SELECT * FROM final