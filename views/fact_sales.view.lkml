view: fact_sales{
  sql_table_name: `ad16-np-bank-looker-ver-8eb9.looker_test.sales` ;;

  dimension: bottle_volume_ml {
    type: number
    description: "Volume of each liquor bottle ordered in milliliters."
    sql: ${TABLE}.bottle_volume_ml ;;
  }

  measure: total_volume_sold_liters {
    group_label: "Metrics"
    type: sum
    sql: ${bottles_sold} *  ${bottle_volume_ml} / 1000 ;;
    value_format: "#,##0 \" L\""
    #value_format_name: liter
  }

  measure: profit {
    group_label: "Metrics"
    type: sum
    sql: ${bottles_sold} *(${state_bottle_retail} - ${state_bottle_cost}) ;;
    value_format_name: usd_0
  }

  measure: profit_margin {
    group_label: "Metrics"
    type: number
    sql: (sum(${state_bottle_retail}) - sum(${state_bottle_cost})) / NULLIF(sum(${state_bottle_retail}),0) ;;
    #value_format: "0.00"
    value_format_name: percent_2
  }


  dimension: bottles_sold {
    type: number
    description: "The number of bottles of liquor ordered by the store"
    sql: ${TABLE}.bottles_sold ;;
  }

  measure: total_bottles_sold {
    group_label: "Metrics"
    type: sum
    sql: ${bottles_sold} ;;
    ##value_format_name: usd
  }

  dimension_group: date {
    type: time
    description: "Date of order"
    #timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }
  dimension: invoice_and_item_number {
    primary_key: yes
    type: string
    description: "Concatenated invoice and line number associated with the liquor order. This provides a unique identifier for the individual liquor products included in the store order."
    sql: ${TABLE}.invoice_and_item_number ;;
  }

  dimension: product_number {
    type: string
    description: "Item number for the individual liquor product ordered."
    sql: ${TABLE}.item_number ;;
  }

  measure: total_sales {
    group_label: "Metrics"
    type: sum
    sql: ${sale_dollars} ;;
    value_format_name: usd
    value_format: "$#,##0"
  }

  measure: average_sales {
    group_label: "Metrics"
    type: average
    sql: ${sale_dollars} ;;
    value_format_name: usd
    value_format: "$#,##0"
  }

  measure: average_price_per_bottle {
    group_label: "Metrics"
    type: number
    sql: (${total_sales}) / (${total_bottles_sold}) ;;
    value_format_name: usd
    value_format: "$0.00"
  }

  measure: percent_of_total_sales {
    group_label: "Metrics"
    type: percent_of_total
    sql: ${total_sales} ;;
    # value_format_name: percent_0
  }

  measure: average_transation_value{
    group_label: "Metrics"
    type: average
    sql: ${sale_dollars} ;;
    value_format_name: usd
  }

  measure: count_of_orders {
    group_label: "Metrics"
    type: count_distinct
    sql: ${invoice_and_item_number} ;;
  }

  dimension: sale_dollars {
    type: number
    description: "Total cost of liquor order (number of bottles multiplied by the state bottle retail)"
    sql: ${TABLE}.sale_dollars ;;
  }


  dimension: state_bottle_cost {
    type: number
    description: "The amount that Alcoholic Beverages Division paid for each bottle of liquor ordered"
    sql: ${TABLE}.state_bottle_cost ;;
  }
  dimension: state_bottle_retail {
    type: number
    description: "The amount the store paid for each bottle of liquor ordered"
    sql: ${TABLE}.state_bottle_retail ;;
  }

  dimension: customer_number {
    type: string
    description: "Unique number assigned to the store who ordered the liquor."
    sql: ${TABLE}.store_number ;;
  }
  dimension: vendor_name {
    type: string
    description: "The vendor name of the company for the brand of liquor ordered"
    sql: ${TABLE}.vendor_name ;;
  }
  dimension: vendor_number {
    type: string
    description: "The vendor number of the company for the brand of liquor ordered"
    sql: ${TABLE}.vendor_number ;;
  }
  dimension: volume_sold_gallons {
    type: number
    description: "Total volume of liquor ordered in gallons. (i.e. (Bottle Volume (ml) x Bottles Sold)/3785.411784)\""
    sql: ${TABLE}.volume_sold_gallons ;;
  }
  dimension: volume_sold_liters {
    type: number
    description: "Total volume of liquor ordered in liters. (i.e. (Bottle Volume (ml) x Bottles Sold)/1,000)\""
    sql: ${TABLE}.volume_sold_liters ;;
  }

  measure: count {
    type: count
    drill_fields: [vendor_name]
  }
}
