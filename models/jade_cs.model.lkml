# Define the database connection to be used for this model.
connection: "looker_partner_demo"

# include all the views
include: "/views/**/*.view"

datagroup: ecommerce_etl {
  sql_trigger: SELECT max(created_at) FROM ecomm.events ;;
  max_cache_age: "24 hours"
}

persist_with: ecommerce_etl

explore: users {}

explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: distribution_centers {}

explore: events {
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  view_name: order_items

  join: repeat_purchase_facts {
    relationship: many_to_one
    type: full_outer
    sql_on: ${order_items.order_id} = ${repeat_purchase_facts.order_id} ;;
  }

  join: user_order_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${user_order_facts.user_id} = ${order_items.user_id} ;;
  }

  join: order_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_facts.order_id} = ${order_items.order_id} ;;
  }

  join: customer_patterns {
    type: left_outer
    sql_on: ${order_items.user_id} = ${customer_patterns.user_id} ;;
    relationship: many_to_one
  }

  join: customer_info {
    type: left_outer
    sql_on: ${users.id} = ${customer_info.user_id} ;;
    relationship: one_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: full_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: one_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${order_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}
