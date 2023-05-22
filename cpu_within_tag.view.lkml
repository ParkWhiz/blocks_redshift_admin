view: cpu_within_tag {
  derived_table: {
    sql: SELECT
      ltrim(rtrim(label)) as query_tag,
      AVG(query_cpu_usage_percent) AS avg_cpu,
      count(*) as total_queries,
      SUM(Datediff(s, starttime, endtime))/count(*)/60.0 AS duration_min,
      (SUM(Datediff(s, starttime, endtime))/count(*)/60.0)*count(distinct(xid)) as total_daily_duration_min,
      ((SUM(Datediff(s, starttime, endtime))/count(*)/60.0)*count(distinct(xid))/1140.0) as percent_of_day,
      AVG(query_cpu_usage_percent)*((SUM(Datediff(s, starttime, endtime))/count(*)/60.0)*count(*)/1140.0) as total_day_CPU
FROM   stl_query stq
      JOIN svl_query_metrics svq
        ON stq.query = svq.query
      JOIN pg_user su
        ON  stq.userid = su.usesysid
WHERE  query_cpu_usage_percent IS NOT NULL
      and starttime > sysdate - 1
      and querytxt not ilike '%padb_fetch_sample%'
      and querytxt not like '%Vacuum%'
      and label not ilike '%default%'
      and dimension = 'query'
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
