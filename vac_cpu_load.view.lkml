view: vac_cpu_load {
  derived_table: {
    sql: WITH vacuum_cpu_load AS (SELECT stq.userid,stq.query,Trim(stq.label) AS label, stq.xid,stq.pid,svq.service_class,query_cpu_usage_percent         AS "cpu_%",starttime,endtime,Datediff(s, starttime, endtime) AS duration_s,Substring(stq.querytxt, 1, 100) AS querytext FROM   stl_query stq JOIN svl_query_metrics svq ON stq.query = svq.query WHERE  query_cpu_usage_percent IS NOT NULL AND starttime > sysdate - 1 AND querytext LIKE '%Vacuum%' ORDER  BY duration_s DESC limit 50
      )
SELECT
    vacuum_cpu_load.pid  AS "vacuum_cpu_load.pid",
    vacuum_cpu_load.xid  AS "vacuum_cpu_load.xid",
        (TO_CHAR(DATE_TRUNC('second', vacuum_cpu_load.starttime ), 'YYYY-MM-DD HH24:MI:SS')) AS "vacuum_cpu_load.starttime_time",
        (TO_CHAR(DATE_TRUNC('second', vacuum_cpu_load.endtime ), 'YYYY-MM-DD HH24:MI:SS')) AS "vacuum_cpu_load.endtime_time",
    vacuum_cpu_load.duration_s  AS "vacuum_cpu_load.duration_s",
    vacuum_cpu_load."cpu_%"  AS "vacuum_cpu_load.cpu_",
    vacuum_cpu_load.querytext  AS "vacuum_cpu_load.querytext",
    vacuum_cpu_load.label  AS "vacuum_cpu_load.label",
    vacuum_cpu_load.query  AS "vacuum_cpu_load.query",
    vacuum_cpu_load.service_class  AS "vacuum_cpu_load.service_class",
    vacuum_cpu_load.userid  AS "vacuum_cpu_load.userid"
FROM vacuum_cpu_load
WHERE (vacuum_cpu_load.starttime::date > current_date -1)
GROUP BY
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11
ORDER BY
    5 DESC
LIMIT 500
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: vacuum_cpu_load_pid {
    type: number
    sql: ${TABLE}."vacuum_cpu_load.pid" ;;
  }

  dimension: vacuum_cpu_load_xid {
    type: number
    sql: ${TABLE}."vacuum_cpu_load.xid" ;;
  }

  dimension: vacuum_cpu_load_starttime_time {
    type: string
    sql: ${TABLE}."vacuum_cpu_load.starttime_time" ;;
  }

  dimension: vacuum_cpu_load_endtime_time {
    type: string
    sql: ${TABLE}."vacuum_cpu_load.endtime_time" ;;
  }

  dimension: vacuum_cpu_load_duration_s {
    type: number
    sql: ${TABLE}."vacuum_cpu_load.duration_s" ;;
  }

  dimension: vacuum_cpu_load_cpu_ {
    type: number
    sql: ${TABLE}."vacuum_cpu_load.cpu_" ;;
  }

  dimension: vacuum_cpu_load_querytext {
    type: string
    sql: ${TABLE}."vacuum_cpu_load.querytext" ;;
  }

  dimension: vacuum_cpu_load_label {
    type: string
    sql: ${TABLE}."vacuum_cpu_load.label" ;;
  }

  dimension: vacuum_cpu_load_query {
    type: number
    sql: ${TABLE}."vacuum_cpu_load.query" ;;
  }

  dimension: vacuum_cpu_load_service_class {
    type: number
    sql: ${TABLE}."vacuum_cpu_load.service_class" ;;
  }

  dimension: vacuum_cpu_load_userid {
    type: number
    sql: ${TABLE}."vacuum_cpu_load.userid" ;;
  }

  set: detail {
    fields: [
      vacuum_cpu_load_pid,
      vacuum_cpu_load_xid,
      vacuum_cpu_load_starttime_time,
      vacuum_cpu_load_endtime_time,
      vacuum_cpu_load_duration_s,
      vacuum_cpu_load_cpu_,
      vacuum_cpu_load_querytext,
      vacuum_cpu_load_label,
      vacuum_cpu_load_query,
      vacuum_cpu_load_service_class,
      vacuum_cpu_load_userid
    ]
  }
}
