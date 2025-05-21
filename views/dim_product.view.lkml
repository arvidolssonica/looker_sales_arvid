view: dim_product {
  derived_table: {
    sql: WITH raw AS (
              SELECT
                dim_customer.item_number          AS product_number,
                dim_customer.item_description     AS product_description,
                dim_customer.pack                 AS product_pack_size,
                dim_customer.category_name        AS product_category_name,
                row_number() over (partition by dim_customer.item_number order by dim_customer.date desc) ranks
              FROM `ad16-np-bank-looker-ver-8eb9.looker_test.sales`  AS dim_customer
              )
                SELECT
                    product_number,
                    product_description,
                    product_pack_size,
                    product_category_name
                FROM raw
                WHERE ranks = 1
       ;;
  }


  dimension: product_category_name {
    type: string
    description: "Category of the liquor ordered."
    sql: ${TABLE}.product_category_name ;;
  }

  dimension: product_description {
    type: string
    description: "Description of the individual liquor product ordered."
    sql: ${TABLE}.product_description ;;
  }
  dimension: product_number {
    type: string
    primary_key: yes
    description: "Item number for the individual liquor product ordered."
    sql: ${TABLE}.product_number ;;
  }
  dimension: product_pack_size {
    type: number
    description: "The number of bottles in a case for the liquor ordered"
    sql: ${TABLE}.product_pack_size ;;
  }

}
