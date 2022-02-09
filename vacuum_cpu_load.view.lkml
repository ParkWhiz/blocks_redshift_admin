view: vacuum_cpu_load {
  derived_table: {
    sql: SELECT stq.userid,stq.query,Trim(stq.label) AS label, stq.xid,stq.pid,svq.service_class,query_cpu_usage_percent         AS "cpu_%",starttime,endtime,Datediff(s, starttime, endtime) AS duration_s,Substring(stq.querytxt, 1, 100) AS querytext FROM   stl_query stq JOIN svl_query_metrics svq ON stq.query = svq.query WHERE  query_cpu_usage_percent IS NOT NULL AND starttime > sysdate - 1 AND querytext LIKE '%Vacuum%' ORDER  BY duration_s DESC limit 50
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: userid {
    type: number
    sql: ${TABLE}.userid ;;
  }

  dimension: query {
    type: number
    sql: ${TABLE}.query ;;
  }

  dimension: label {
    type: string
    sql: ${TABLE}.label ;;
  }

  dimension: xid {
    type: number
    sql: ${TABLE}.xid ;;
  }

  dimension: pid {
    type: number
    sql: ${TABLE}.pid ;;
  }

  dimension: service_class {
    type: number
    sql: ${TABLE}.service_class ;;
  }

  dimension: cpu_ {
    type: number
    sql: ${TABLE}."cpu_%" ;;
  }

  dimension_group: starttime {
    type: time
    sql: ${TABLE}.starttime ;;
  }

  dimension_group: endtime {
    type: time
    sql: ${TABLE}.endtime ;;
  }

  dimension: duration_s {
    type: number
    sql: ${TABLE}.duration_s ;;
  }

  dimension: querytext {
    type: string
    sql: ${TABLE}.querytext ;;
  }

  set: detail {
    fields: [
      userid,
      query,
      label,
      xid,
      pid,
      service_class,
      cpu_,
      starttime_time,
      endtime_time,
      duration_s,
      querytext
    ]
  }
}
