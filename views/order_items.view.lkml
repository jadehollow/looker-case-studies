view: order_items {
  view_label: "Order Items"
  sql_table_name: looker-private-demo.ecomm.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    value_format: "00000"
  }

  dimension_group: created {
    type: time
    timeframes: [time, hour, date, week, month, year, hour_of_day, day_of_week, month_num, raw, week_of_year, month_name]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [raw, date, week, month]
    sql: CAST(${TABLE}.delivered_at AS TIMESTAMP) ;;
  }

  dimension: inventory_item_id {
    type: number
    hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
    value_format: "00000"
  }

  dimension: order_id_no_actions {
    type: number
    hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  measure: order_count {
    view_label: "Orders"
    type: count_distinct
    drill_fields: [detail*]
    sql: ${order_id} ;;
  }

  measure: first_purchase_count {
    type: count_distinct
    sql: ${order_id} ;;
    filters: {
      field: order_facts.is_first_purchase
      value: "Yes"
    }
    drill_fields: [user_id, users.name, users.email, order_id, created_date, users.traffic_source]
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [raw, time, date, week, month]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
    value_format_name: usd
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    drill_fields: [detail*]
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
    drill_fields: [detail*]
  }

  dimension: gross_margin {
    type: number
    value_format_name: usd
    sql: ${sale_price} - ${inventory_items.cost};;
  }

  measure: total_gross_margin {
    type: sum
    value_format_name: usd
    sql: ${gross_margin} ;;
    drill_fields: [user_id, average_sale_price, total_gross_margin]
  }

  dimension_group: shipped {
    type: time
    timeframes: [raw, date, week, month]
    sql: CAST(${TABLE}.shipped_at AS TIMESTAMP) ;;
  }

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: status {
    sql: ${TABLE}.status ;;
  }

  dimension: days_since_sold {
    hidden: yes
    sql: TIMESTAMP_DIFF(${created_raw},CURRENT_TIMESTAMP(), DAY) ;;
  }

  dimension: months_since_signup {
    view_label: "Orders"
    type: number
    sql: CAST(FLOOR(TIMESTAMP_DIFF(${created_raw}, ${users.created_raw}, DAY)/30) AS INT64) ;;
  }

  dimension: days_until_next_order {
    type: number
    view_label: "Repeat Purchase Facts"
    sql: TIMESTAMP_DIFF(${created_raw},${repeat_purchase_facts.next_order_raw}, DAY) ;;
  }

  dimension: repeat_orders_within_60d {
    type: yesno
    view_label: "Repeat Purchase Facts"
    sql: ${days_until_next_order} <= 60 ;;
  }

  measure: count_with_repeat_purchase_within_60d {
    type: count_distinct
    sql: ${id} ;;
    view_label: "Repeat Purchase Facts"

    filters: {
      field: repeat_orders_within_60d
      value: "Yes"
    }
  }

  measure: 60_day_repeat_purchase_rate {
    view_label: "Repeat Purchase Facts"
    type: number
    value_format_name: percent_1
    sql: 1.0 * ${count_with_repeat_purchase_within_60d} / (CASE WHEN ${count} = 0 THEN NULL ELSE ${count} END) ;;
    drill_fields: [products.brand, order_count, count_with_repeat_purchase_within_60d]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [order_id, status, created_date, sale_price, products.brand, products.item_name, users.portrait, users.name, users.email]
  }
  set: return_detail {
    fields: [id, order_id, status, created_date, returned_date, sale_price, products.brand, products.item_name, users.portrait, users.name, users.email]
  }
}
