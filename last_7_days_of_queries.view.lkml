view: last_7_days_of_queries {
  derived_table: {
    sql: SELECT

        trim(database) as db, count(query) AS n_qry,

        max(substring (qrytext,1,80)) AS qrytext,

        min(run_minutes) AS "min",

        max(run_minutes) AS "max",

        avg(run_minutes) AS "avg",

        sum(run_minutes) AS total,

        max(query) AS max_query_id,

        max(starttime)::DATE AS last_run,

        sum(alerts) AS alerts,

        aborted

      FROM

        (SELECT

           userid,

            label,

            stl_query.query,

          trim(database) AS database,

          trim(querytxt) AS qrytext,

          md5(trim(querytxt)) AS qry_md5,

          starttime,

          endtime,

          (datediff(seconds, starttime,endtime)::numeric(12,2))/60 AS run_minutes,

          alrt.num_events AS alerts,

          aborted

        FROM

            stl_query

          LEFT OUTER JOIN

            (SELECT

               query,

               1 as num_events

            FROM

                stl_alert_event_log

            GROUP BY

              query

            ) AS alrt

          on alrt.query = stl_query.query

        WHERE userid <> 1 and starttime >=  dateadd(day, -7, current_date)

        )

      GROUP BY

        database,

        label,

        qry_md5,

        aborted

      ORDER BY total desc limit 50
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: db {
    type: string
    sql: ${TABLE}.db ;;
  }

  dimension: n_qry {
    type: number
    sql: ${TABLE}.n_qry ;;
  }

  dimension: qrytext {
    type: string
    sql: ${TABLE}.qrytext ;;
  }

  dimension: min {
    type: number
    sql: ${TABLE}.min ;;
  }

  dimension: max {
    type: number
    sql: ${TABLE}.max ;;
  }

  dimension: avg {
    type: number
    sql: ${TABLE}.avg ;;
  }

  dimension: total {
    type: number
    sql: ${TABLE}.total ;;
  }

  dimension: max_query_id {
    type: number
    sql: ${TABLE}.max_query_id ;;
  }

  dimension: last_run {
    type: date
    sql: ${TABLE}.last_run ;;
  }

  dimension: alerts {
    type: number
    sql: ${TABLE}.alerts ;;
  }

  dimension: aborted {
    type: number
    sql: ${TABLE}.aborted ;;
  }

  set: detail {
    fields: [
      db,
      n_qry,
      qrytext,
      min,
      max,
      avg,
      total,
      max_query_id,
      last_run,
      alerts,
      aborted
    ]
  }
}
