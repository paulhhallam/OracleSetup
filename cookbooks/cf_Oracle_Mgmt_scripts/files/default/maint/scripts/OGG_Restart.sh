#!/bin/bash
#######################################################################
#       Script to run check for Goldengate Process status.
#
#       Run from oracle crontab every 5 Minutes
#
#######################################################################
#       Change History
#       Date            Author             Ver     Description
#----------------------------------------------------------------------
#       27/03/2016      Ananth Shenoy      1.0     New script.
#
#######################################################################
#
################ SETTING UP VARIABLES #################
#
EMAIL_LIST="oraclealerts@cashflows.com"
host=`hostname`
timeSuffix=`date +%F_%T`
ggacounts=/backup/oracle/OGG/accounts
ggendpoint=/backup/oracle/OGG/endpoint
ggcentral=/backup/oracle/OGG/central

. ~/central.env
cd $ggcentral
ggsci PARAMFILE start_extract

