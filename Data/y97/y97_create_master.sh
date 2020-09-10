#!/bin/sh
stata-se -b do y97_import_all.do
stata-se -b do y97_create_master.do
stata-se -b do y97_create_trim.do
# cd ..
# /usr/local/stata11/stata-se -b do data_append.do