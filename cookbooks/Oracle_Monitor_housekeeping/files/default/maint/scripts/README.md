The dev and production systems use different scripts because the directory structures are different.
Hopefully we will amend the database setup scripts to incorporate these differences and then the same commands can be used on both systems.

Three generic scripts in use by the development database on ASMDB03

check_sess_procs_database.sh
============================


Parameter

    central

    accounts

    endpoint

This script will check the session procerss counts.

TSdatabasecheck.sh
==================


Parameter

    central

    accounts

    endpoint

This script will alert the e-mail recipients if any of the selected database tablespaces have breached the ,limits hard coded in the script.

check_alert_database.sh
=======================


Parameter

    central

    accounts

    endpoint
This script will alert the e-mail recipients if the oracle logs contains any significant errors created in the last 10 minutes.




