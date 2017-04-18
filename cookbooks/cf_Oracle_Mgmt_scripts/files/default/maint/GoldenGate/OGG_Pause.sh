#!/bin/bash

EMAIL_LIST="pp"
host=`hostname`
timeSuffix=`date +%F_%T`
ggacounts=/backup/oracle/OGG/accounts
ggendpoint=/backup/oracle/OGG/endpoint
ggcentral=/backup/oracle/OGG/central

. ~/central.env

cd $ggcentral
ggsci PARAMFILE stop_extract

