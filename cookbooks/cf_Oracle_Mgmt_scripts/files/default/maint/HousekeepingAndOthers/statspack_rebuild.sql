alter table STATS$SQL_SUMMARY enable row movement;

alter table STATS$SQL_SUMMARY shrink space;

alter table STATS$SQL_SUMMARY disable row movement;

alter index STATS$SQL_SUMMARY_PK rebuild;

alter table STATS$SQL_PLAN_USAGE enable row movement;
alter table STATS$SQL_PLAN_USAGE shrink space;

alter table STATS$SQL_PLAN_USAGE disable row movement;

alter index STATS$SQL_PLAN_USAGE_PK rebuild;

alter table STATS$EVENT_HISTOGRAM enable row movement;

alter table STATS$EVENT_HISTOGRAM shrink space;

alter table STATS$EVENT_HISTOGRAM disable row movement;

alter index STATS$EVENT_HISTOGRAM_PK rebuild;

