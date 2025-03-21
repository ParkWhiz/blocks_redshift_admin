view: per_user_cpu {
  derived_table: {
    sql: SELECT
      querytext,
      AVG(avg_cpu) AS avg_cpu,
      usename AS "user",
      SUM(task_duration_seconds/60.0)/COUNT(*) AS duration_min,
      SUM(task_duration_seconds/60.0) as total_daily_duration_min,
      SUM(task_duration_seconds/60.0)/1140.0 as percent_of_day,
      SUM(total_daily_cpu) as total_day_CPU,
      COUNT(*)
FROM pw_monitoring.redshift_query_metrics
WHERE  COALESCE(avg_cpu,0) != 0
       and starttime > sysdate - 1
       GROUP BY 1,3,4,5
       ORDER BY  7 desc LIMIT 100
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: querytext {
    type: string
    sql: ${TABLE}.querytext ;;
  }

  dimension: avg_cpu {
    type: number
    sql: ${TABLE}.avg_cpu ;;
  }

  dimension: user {
    type: string
    sql: ${TABLE}."user" ;;
  }

  dimension: duration_min {
    type: number
    sql: ${TABLE}.duration_min ;;
  }

  dimension: total_daily_duration_min {
    type: number
    sql: ${TABLE}.total_daily_duration_min ;;
  }

  dimension: percent_of_day {
    type: number
    sql: ${TABLE}.percent_of_day ;;
  }

  dimension: total_day_cpu {
    type: number
    sql: ${TABLE}.total_day_cpu ;;
  }

  dimension: count_ {
    type: number
    sql: ${TABLE}.count ;;
  }

  set: detail {
    fields: [
      querytext,
      avg_cpu,
      user,
      duration_min,
      total_daily_duration_min,
      percent_of_day,
      total_day_cpu,
      count_
    ]
  }
}
