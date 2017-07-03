#! /bin/bash

SOLR_PATH=/opt/solr
SOLR_COULD_SCRIPT_PATH=$SOLR_PATH/server/scripts/cloud-scripts
ZKHOST=$1
CONFDIR=/var/solr/data

CONFIGS="CCPhysician DocumentMaster MacrosSuggester MtDocumentMaster RefDocumentSearchh CNTDocumentMaster NewNPDocumentMaster SpellCheck UserMaster AdtSearch"

for CONFNAME in $CONFIGS; do
    echo Downloading configuration $CONFNAME from $ZKHOST to $CONFDIR/$CONFNAME/conf
    $SOLR_COULD_SCRIPT_PATH/zkcli.sh -cmd downconfig -zkhost $ZKHOST -confname $CONFNAME -d $CONFDIR/$CONFNAME/
done
