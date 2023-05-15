view: cpu_utilization_by_query_tags {
  derived_table: {
    sql: SELECT
       label as query_tag,
       Substring(stq.querytxt, 1, 100) AS querytext,
       AVG(query_cpu_usage_percent) AS avg_cpu,
       su.usename as user,
       AVG(Datediff(s, starttime, endtime))/60 AS duration_min,
       (AVG(Datediff(s, starttime, endtime))/60)*count(*) as total_daily_duration_min,
       ((AVG(Datediff(s, starttime, endtime))/60)*count(*))/1140.0 as percent_of_day,
       AVG(query_cpu_usage_percent)*(((AVG(Datediff(s, starttime, endtime))/60)*count(*))/1140.0) as total_day_CPU,
       count(*)
FROM   stl_query stq
       JOIN svl_query_metrics svq
         ON stq.query = svq.query
       JOIN pg_user su
        ON  stq.userid = su.usesysid
WHERE  query_cpu_usage_percent IS NOT NULL
       and starttime > sysdate - 1
       and querytext not ilike '%padb_fetch_sample%'
       and querytext not like '%Vacuum%'
       and label not ilike '%default%'
       GROUP BY 1,2,4
       ORDER BY  8 desc
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
      query_tag,
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
