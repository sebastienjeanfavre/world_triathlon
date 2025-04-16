-- CREATE OR REPLACE DATABASE WORLD_TRIATHLON_BACKUP CLONE WORLD_TRIATHLON;
create or replace schema world_triathlon.staging ;
create or replace table world_triathlon.staging.athletes AS 
select * from world_triathlon_backup.staging.athletes;
create or replace table world_triathlon.staging.events AS 
select * from world_triathlon_backup.staging.events;
create or replace table world_triathlon.staging.programs AS 
select * from world_triathlon_backup.staging.programs;
create or replace table world_triathlon.staging.programs_results AS 
select * from world_triathlon_backup.staging.programs_results;
create or replace table world_triathlon.staging.athletes_categories AS 
select * from world_triathlon_backup.staging.athletes_categories;
create or replace table world_triathlon.staging.event_categories AS 
select * from world_triathlon_backup.staging.event_categories;
create or replace table world_triathlon.staging.event_specifications AS 
select * from world_triathlon_backup.staging.event_specifications;

create schema world_triathlon.test;
create table world_triathlon.test.api_sample_athletes AS
select * from world_triathlon.test.api_sample_athletes;
create table world_triathlon.test.api_sample_events AS
select * from world_triathlon.test.api_sample_events;
create table world_triathlon.test.api_sample_programs AS
select * from world_triathlon.test.api_sample_programs;
create table world_triathlon.test.api_sample_programs_results AS
select * from world_triathlon.test.api_sample_programs_results;