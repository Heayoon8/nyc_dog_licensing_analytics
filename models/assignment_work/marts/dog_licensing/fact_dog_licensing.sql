WITH source AS (
    SELECT *
    FROM {{ ref('stg_nyc_dog_licensing') }}
),

-- size_category, temperament 
animal_chars AS (
    SELECT
        breed_name,
        size_category,
        temperament
    FROM {{ ref('stg_animal_characteristics') }}
),

final AS (
    SELECT
        -- Primary Key
        {{ dbt_utils.generate_surrogate_key([
            'source.animal_name',
            'source.animal_gender',
            'source.animal_birth_year',
            'source.breed_name',
            'source.zip_code',
            'source.license_issued_date',
            'source.license_expired_date'
        ]) }} AS licensing_id,

        source.animal_name,

        -- FK to dim_animal_characteristics 
        {{ dbt_utils.generate_surrogate_key([
            'source.breed_name',
            'animal_chars.size_category',
            'animal_chars.temperament'
        ]) }} AS animal_characteristics_key,

        -- FK to dim_gender_and_birth_year
        {{ dbt_utils.generate_surrogate_key([
            'source.animal_gender',
            'CAST(source.animal_birth_year AS STRING)'
        ]) }} AS gender_birth_year_key,

        -- FK to dim_zipcode 
        {{ dbt_utils.generate_surrogate_key([
            'source.zip_code'
        ]) }} AS zipcode_key,

        -- FK to dim_date
        {{ dbt_utils.generate_surrogate_key([
            'CAST(source.license_issued_date AS DATE)'
        ]) }} AS license_issued_date_key,

        {{ dbt_utils.generate_surrogate_key([
            'CAST(source.license_expired_date AS DATE)'
        ]) }} AS license_expired_date_key,

        CAST(source.extract_year AS STRING) AS extract_year

    FROM source
    LEFT JOIN animal_chars
        ON source.breed_name = animal_chars.breed_name
)

SELECT * FROM final