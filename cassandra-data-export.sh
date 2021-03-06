#! /bin/bash

CQLSH=`which cqlsh`

if [[ "$CQLSH" == "" ]]; then
    echo "cqlsh does not exits"
    exit 1
fi

CQLSH_CMD="cqlsh -ucassandra -pcassandra"

if [[ "$1" == "" ]]; then
    KEYSPACES=`$CQLSH_CMD -e 'desc keyspaces' | sed -e 's/  */\n/g' | grep ez`
else
    KEYSPACES="$*"
fi

TMP_DIR=`mktemp -d`
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
OLD_DIR=$PWD

for KEYSPACE in $KEYSPACES; do
    TABLES=`$CQLSH_CMD -e "USE $KEYSPACE; DESC TABLES;" | sed -e 's/  */\n/g'`
    echo Creating directory $TMP_DIR/$KEYSPACE
    mkdir -p $TMP_DIR/$KEYSPACE
    for TABLE in $TABLES; do
        COMMAND="USE $KEYSPACE; COPY $TABLE TO '$TMP_DIR/$KEYSPACE/$TABLE.csv' WITH NULL='null'"
        $CQLSH_CMD -e "$COMMAND"
    done
done

pushd $TMP_DIR
tar -cvf $OLD_DIR/cassandra-data-export-$TIMESTAMP.tar.gz .
popd

rm -r $TMP_DIR


