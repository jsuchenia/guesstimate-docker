#!/bin/bash
ls -laR /home/guesstimate/postgresql
chmod 700 /home/guesstimate/postgresql/data
/usr/lib/postgresql/13/bin/pg_ctl initdb --pgdata=/home/guesstimate/postgresql/data
cat /home/guesstimate/postgresql/init_sql.txt | /usr/lib/postgresql/13/bin/postgres --single --config-file=/home/guesstimate/postgresql/postgresql.conf postgres
coproc /usr/lib/postgresql/13/bin/postgres --config-file=/home/guesstimate/postgresql/postgresql.conf -k /home/guesstimate/postgresql
(cd guesstimate-server;bundle exec rails db:setup;bundle exec rspec)
kill $COPROC_PID