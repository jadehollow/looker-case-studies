view: customer_patterns {

  ##dimensions ##

  dimension: user_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.USER_ID ;;
  }

  dimension: days_between_orders {
    type: number
    sql: ${TABLE}.DAYS_BETWEEN_ORDERS ;;
  }

  dimension: has_subsequent_order {
    type: yesno
    sql: ${TABLE}.HAS_SUBSEQUENT_ORDER = 1 ;;
  }

  dimension: is_60_day_repeat_purchase {
    type: yesno
    sql: ${TABLE}.IS_60_DAY_REPEAT_PURCHASE = 1 ;;
  }

  dimension: is_first_purchase {
    type: yesno
    sql: ${order_sequence} = 1 ;;
  }

  dimension: order_sequence {
    type: number
    sql: ${TABLE}.ORDER_SEQUENCE ;;
  }

  ## measures ##

  measure: average_days_between_orders {
    type: average
    sql: ${days_between_orders} ;;
  }

}
