view: cpu_within_tag {
  derived_table: {
    sql: SELECT
      query_group as query_tag,
      AVG(avg_cpu) AS avg_cpu,
      COUNT(*) as total_queries,
      SUM(task_duration_seconds/60.0)/COUNT(*) AS duration_min,
      SUM(task_duration_seconds/60.0) as total_daily_duration_min,
      SUM(task_duration_seconds/60.0)/1140.0 as percent_of_day,
      SUM(total_daily_cpu) as total_day_CPU
FROM pw_monitoring.redshift_query_metrics
WHERE starttime > sysdate - 1
AND query_group != 'default'
      GROUP BY 1
      ORDER BY 7 desc
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: query_tag {
    type: string
    sql: ${TABLE}.query_tag ;;
  }

  dimension: avg_cpu {
    type: number
    sql: ${TABLE}.avg_cpu ;;
  }

  dimension: total_queries {
    type: number
    sql: ${TABLE}.total_queries ;;
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

  set: detail {
    fields: [
      query_tag,
      avg_cpu,
      total_queries,
      duration_min,
      total_daily_duration_min,
      percent_of_day,
      total_day_cpu
    ]
  }
}
