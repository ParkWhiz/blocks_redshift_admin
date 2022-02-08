view: vac {
  derived_table: {
    sql: select * from svv_vacuum_progress
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: table_name {
    type: string
    sql: ${TABLE}.table_name ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: time_remaining_estimate {
    type: string
    sql: ${TABLE}.time_remaining_estimate ;;
  }

  set: detail {
    fields: [table_name, status, time_remaining_estimate]
  }
}
