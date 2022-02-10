view: locked_tables {
  derived_table: {
    sql: select a.txn_owner, a.txn_db, a.xid, a.pid, a.txn_start, a.lock_mode, a.relation as table_id,nvl(trim(c."name"),d.relname) as tablename, a.granted,b.pid as blocking_pid ,datediff(s,a.txn_start,getdate())/86400||' days '||datediff(s,a.txn_start,getdate())%86400/3600||' hrs '||datediff(s,a.txn_start,getdate())%3600/60||' mins '||datediff(s,a.txn_start,getdate())%60||' secs' as txn_duration
      from svv_transactions a
      left join (select pid,relation,granted from pg_locks group by 1,2,3) b
      on a.relation=b.relation and a.granted='f' and b.granted='t'
      left join (select * from stv_tbl_perm where slice=0) c
      on a.relation=c.id
      left join pg_class d on a.relation=d.oid
      where  a.relation is not null
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: txn_owner {
    type: string
    sql: ${TABLE}.txn_owner ;;
  }

  dimension: txn_db {
    type: string
    sql: ${TABLE}.txn_db ;;
  }

  dimension: xid {
    type: number
    sql: ${TABLE}.xid ;;
  }

  dimension: pid {
    type: number
    sql: ${TABLE}.pid ;;
  }

  dimension_group: txn_start {
    type: time
    sql: ${TABLE}.txn_start ;;
  }

  dimension: lock_mode {
    type: string
    sql: ${TABLE}.lock_mode ;;
  }

  dimension: table_id {
    type: number
    sql: ${TABLE}.table_id ;;
  }

  dimension: tablename {
    type: string
    sql: ${TABLE}.tablename ;;
  }

  dimension: granted {
    type: string
    sql: ${TABLE}.granted ;;
  }

  dimension: blocking_pid {
    type: number
    sql: ${TABLE}.blocking_pid ;;
  }

  dimension: txn_duration {
    type: string
    sql: ${TABLE}.txn_duration ;;
  }

  set: detail {
    fields: [
      txn_owner,
      txn_db,
      xid,
      pid,
      txn_start_time,
      lock_mode,
      table_id,
      tablename,
      granted,
      blocking_pid,
      txn_duration
    ]
  }
}
