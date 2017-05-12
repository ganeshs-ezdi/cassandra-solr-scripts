#! /bin/bash

JAVA=`java -version 2>&1 | grep 'java version "1.8'`

if [[ "$JAVA" == "" ]]; then
    sudo add-apt-repository ppa:webupd8team/java
    sudo apt-get update
    sudo apt-get -y install oracle-java8-installer
else
    echo "Java8 already installed"
fi

CASSANDRA=`which cassandra`

if [[ "$CASSANDRA" == "" ]]; then
    echo -e '# Cassandra 2.2.x version

    deb http://www.apache.org/dist/cassandra/debian 22x main
    deb-src http://www.apache.org/dist/cassandra/debian 22x main' | sudo tee /etc/apt/sources.list.d/cassandra-22x.list

    curl https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -

    sudo apt-get update

    sudo apt-get -y install cassandra
else
    echo "Cassandra already installed"
fi


