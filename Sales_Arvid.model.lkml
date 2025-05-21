connection: "triumph"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }

explore: sales{}
explore: fact_sales{

  join: dim_customer {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_customer.customer_number} = ${fact_sales.customer_number} ;;
  }
  join: dim_product {
    type: left_outer
    relationship: many_to_one
    sql_on: ${dim_product.product_number} = ${fact_sales.product_number} ;;
  }

}
explore: dim_customer{}
explore: dim_product{}
