SQL_DATA = "insert into data (metric, timestamp, value) values (%s, %s, %s)"
SQL_STAGES = "insert into stages (stage_id, time_start, time_start_epoch, time_end, time_end_epoch, duration_total_minutes, depth_heel, depth_vertical, depth_lateral, depth_max, shots_count) values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
SQL_SHOTS = "insert into shots (timestamp, timestamp_epoch, depth_shot, type, stage_id) values (%s, %s, %s, %s, %s)"
