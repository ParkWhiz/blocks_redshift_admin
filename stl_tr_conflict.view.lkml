view: stl_tr_conflict {
  derived_table: {
    sql: select * from stl_tr_conflict order by xact_start_ts desc
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: xact_id {
    type: number
    sql: ${TABLE}.xact_id ;;
  }

  dimension: process_id {
    type: number
    sql: ${TABLE}.process_id ;;
  }

  dimension_group: xact_start_ts {
    type: time
    sql: ${TABLE}.xact_start_ts ;;
  }

  dimension_group: abort_time {
    type: time
    sql: ${TABLE}.abort_time ;;
  }

  dimension: table_id {
    type: number
    sql: ${TABLE}.table_id ;;
  }

  set: detail {
    fields: [xact_id, process_id, xact_start_ts_time, abort_time_time, table_id]
  }
}
