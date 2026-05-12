WITH source AS (
    SELECT *
    FROM {{ source('raw_311', 'source_311nyc_service_requests') }}
),

cleaned AS (
    SELECT
        -- Identifiers
        CAST(unique_key AS STRING) AS request_id,

        -- Dates
        CAST(created_date AS TIMESTAMP) AS created_date,
        CAST(closed_date AS TIMESTAMP) AS closed_date,

        -- Agency
        CAST(agency AS STRING) AS agency,
        CAST(agency_name AS STRING) AS agency_name,

        -- Complaint
        CAST(complaint_type AS STRING) AS complaint_type,
        CAST(descriptor AS STRING) AS descriptor,
        CAST(descriptor_2 AS STRING) AS descriptor_2,
        UPPER(TRIM(CAST(status AS STRING))) AS status,

        -- Location type
        CAST(location_type AS STRING) AS location_type,

        -- Address
        CAST(incident_address AS STRING) AS incident_address,
        CAST(address_type AS STRING) AS address_type,
        CAST(street_name AS STRING) AS street_name,
        CAST(city AS STRING) AS city,
        CAST(community_board AS STRING) AS community_board,
        CAST(council_district AS STRING) AS council_district,

        -- Zip code cleaning
        CASE
            WHEN incident_zip IS NULL THEN NULL
            WHEN UPPER(TRIM(CAST(incident_zip AS STRING))) IN ('N/A', 'NA', 'UNKNOWN') THEN NULL
            WHEN LENGTH(TRIM(CAST(incident_zip AS STRING))) = 5 THEN TRIM(CAST(incident_zip AS STRING))
            WHEN REGEXP_CONTAINS(TRIM(CAST(incident_zip AS STRING)), r'^\d{5}-\d{4}$')
                THEN TRIM(CAST(incident_zip AS STRING))
            ELSE NULL
        END AS incident_zip,

        -- Borough standardization
        CASE
            WHEN UPPER(TRIM(CAST(borough AS STRING))) IN ('MANHATTAN', 'NEW YORK COUNTY') THEN 'Manhattan'
            WHEN UPPER(TRIM(CAST(borough AS STRING))) IN ('BRONX', 'THE BRONX') THEN 'Bronx'
            WHEN UPPER(TRIM(CAST(borough AS STRING))) IN ('BROOKLYN', 'KINGS COUNTY') THEN 'Brooklyn'
            WHEN UPPER(TRIM(CAST(borough AS STRING))) IN ('QUEENS', 'QUEEN', 'QUEENS COUNTY') THEN 'Queens'
            WHEN UPPER(TRIM(CAST(borough AS STRING))) IN ('STATEN ISLAND', 'RICHMOND COUNTY') THEN 'Staten Island'
            ELSE 'UNKNOWN or CITYWIDE'
        END AS borough,

        
        CAST(latitude AS NUMERIC) AS latitude,
        CAST(longitude AS NUMERIC) AS longitude,

     
        CURRENT_TIMESTAMP() AS _stg_loaded_at

    FROM source
    WHERE unique_key IS NOT NULL
      AND created_date IS NOT NULL
      AND LOWER(discriptor)) LIKE '%dog%'  

    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY unique_key
        ORDER BY created_date DESC
    ) = 1
)

SELECT * FROM cleaned