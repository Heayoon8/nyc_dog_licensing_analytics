WITH source AS (
    SELECT *
    FROM {{ source('raw_dog', 'Dim_Animal_CHaracteristics') }}
),

cleaned AS (
    SELECT
        UPPER(TRIM(CAST(breed_name AS STRING))) AS breed_name,
        CAST(size_category AS STRING) AS size_category,
        CAST(temperament AS STRING) AS temperament
    FROM source
    WHERE breed_name IS NOT NULL
)

SELECT * FROM cleaned