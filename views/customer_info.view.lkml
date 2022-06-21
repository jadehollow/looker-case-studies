view: customer_info {

  ## dimensions ##

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: customer_lifetime_orders {
    type: tier
    tiers: [1,2,5,9,10]
    style: integer
    sql: ${lifetime_orders} ;;
  }

  dimension: customer_lifetime_revenue {
    type: tier
    tiers: [5,20,50,100,500,1000]
    style: integer
    value_format_name: usd
    sql: ${lifetime_orders} ;;
  }

  dimension: is_active {
    type: yesno
    sql: ${days_since_latest_order} <= 90 ;;
  }

  dimension: is_repeat_customer {
    type: yesno
    sql: ${lifetime_orders} > 1 ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  ## dimension groups ##

  dimension_group: first_order {
    description: "Corresponds to the date on which first order was placed"
    type: time
    timeframes: [date,month,year,raw]
    sql: ${TABLE}.first_order ;;
  }

  dimension_group: last_order {
    description: "Corresponds to the date on which latest order was placed"
    type: time
    timeframes: [date,month,year,raw]
    sql: ${TABLE}.last_order ;;
  }

  dimension_group: since_latest_order {
    type: duration
    intervals: [day]
    sql_start: ${last_order_raw} ;;
    sql_end: current_timestamp() ;;
  }

  ## measures ##

  measure: average_lifetime_orders {
    description: "The average number of orders that a customer places over the course of
    their lifetime as a customer"
    type: average
    sql: ${lifetime_orders} ;;
  }

  measure: average_lifetime_revenue {
    description: "The average amount of revenue that a customer brings in over the course of
    their lifetime as a customer"
    type: average
    value_format_name: usd
    sql: ${lifetime_revenue} ;;
  }

  measure: total_lifetime_orders {
    description: "The total number of orders placed over the course of customers' lifetimes"
    type: sum
    sql: ${lifetime_orders} ;;
  }

  measure: total_lifetime_revenue {
    description: "The total amount of revenue brought in over the course of customers' lifetimes"
    type: sum
    value_format_name: usd
    sql: ${lifetime_revenue} ;;
  }

  ## derived tables ##

  derived_table: {
    sql: select user_id,
      count(distinct order_id) as lifetime_orders,
       SUM(CASE WHEN (order_items."STATUS" = 'Complete') THEN (order_items."SALE_PRICE")  ELSE NULL END) AS lifetime_revenue,
       min(created_at) as first_order,
       max(created_at) as last_order
    from order_items
    group by 1 ;;
  }

}
