view: dim_customer {
  derived_table: {
    sql: WITH raw AS (
              SELECT
                  dim_customer.store_number   AS customer_number,
                  dim_customer.address        AS customer_address,
                  dim_customer.city           AS customer_city,
                  dim_customer.county         AS customer_category,
                  dim_customer.county_number  AS customer_category_number,
                  --dim_customer.store_name     AS customer_name,
                  REGEXP_EXTRACT(store_name, r'[^/]*') AS customer_name,
                  --SUBSTRING(store_name, [1, INSTR(store_name, '/') - 1]) AS dim_customer_customer_name,
                  cast(REGEXP_REPLACE(dim_customer.zip_code, '-', '')  as numeric)  AS customer_zip_code,
                  row_number() over (partition by dim_customer.store_number order by dim_customer.date desc) ranks
              FROM `ad16-np-bank-looker-ver-8eb9.looker_test.sales`  AS dim_customer
              )
                SELECT
                  customer_number,
                  customer_address,
                  customer_city,
                  customer_category,
                  customer_category_number,
                  customer_name,
                  customer_zip_code
                FROM raw
                WHERE ranks = 1
       ;;
  }

  dimension: customer_number {
    type: string
    primary_key: yes
    description: "Unique number assigned to the store who ordered the liquor. Last value that for that store."
    sql: ${TABLE}.customer_number ;;
  }

  dimension: customer_address {
    type: string
    description: "Address where store is located."
    sql: ${TABLE}.customer_address ;;
  }

  dimension: customer_city {
    type: string
    description: "City where store is located."
    sql: ${TABLE}.customer_city ;;
  }
  dimension: customer_category {
    type: string
    description: "Store category"
    sql: ${TABLE}.customer_category ;;
  }
  dimension: customer_category_number {
    type: string
    description: "Store category number."
    sql: ${TABLE}.customer_category_number ;;
  }

  dimension: customer_name {
    type: string
    description: "Name of store who ordered the liquor."
    sql: ${TABLE}.customer_name ;;
  }

  dimension: customer_zip_code {
    type: zipcode
    map_layer_name: "us_zipcode_tabulation_areas"
    description: "Zip code where the store who ordered the liquor is located"
    sql: ${TABLE}.customer_zip_code ;;
  }

}
