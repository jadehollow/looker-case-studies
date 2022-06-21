view: users {
  view_label: "Users"
  sql_table_name: looker-private-demo.ecomm.users ;;

  ## dimensions ##

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    tags: ["user_id"]
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: street_address {
    type: string
    sql: ${TABLE}.street_address ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  ## dimension groups ##

  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month]
    sql: ${TABLE}.created_at ;;
  }

  # dimension_group: since_signup {
  #   type: duration
  #   intervals: [day,month]
  #   sql_start: ${created_raw} ;;
  #   sql_end: CURRENT_TIMESTAMP() ;;
  # }

  ## measures ##

  measure: average_age {
    type: average
    sql: ${age} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, events.count, order_items.count]
  }

  measure: total_age {
    type: sum
    sql: ${age} ;;
  }

}
