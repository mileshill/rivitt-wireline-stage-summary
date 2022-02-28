-- Create the database
CREATE DATABASE IF NOT EXISTS wireline;
-- Create the First Table
use wireline;
CREATE TABLE IF NOT EXISTS stages
(
    id                     INT         NOT NULL AUTO_INCREMENT PRIMARY KEY,
    stage_id               varchar(36) not null unique,
    time_start             datetime    not null,
    time_start_epoch       bigint      not null,
    time_end               datetime    not null,
    time_end_epoch         bigint      not null,
    duration_total_minutes int         not null,
    depth_heel             int         not null,
    depth_vertical         int         not null,
    depth_lateral          int         not null,
    depth_max              int         not null,
    shots_count            int
);
CREATE TABLE IF NOT EXISTS shots
(
    id              int         not null auto_increment PRIMARY KEY,
    stage_id        varchar(36) not null,
    timestamp       datetime    not null,
    timestamp_epoch bigint      not null,
    depth_shot      int         not null,
    type            varchar(10) not null,
    FOREIGN KEY (stage_id) references stages (stage_id)
        on delete cascade
);
-- alignment is linked to each stage. It provides the best well heel estimate
CREATE TABLE IF NOT EXISTS alignment
(
    id             int         not null auto_increment PRIMARY KEY,
    stage_id       varchar(36) not null,
    timestamp      datetime    not null,
    depth_measured int         not null,
    FOREIGN KEY (stage_id) references stages (stage_id)
        ON DELETE CASCADE
);
-- data holds the raw data flowing from steaming service
CREATE TABLE IF NOT EXISTS data
(
    id        int         not null auto_increment PRIMARY KEY,
    metric    varchar(36) not null,
    timestamp datetime    not null,
    value     float
);
