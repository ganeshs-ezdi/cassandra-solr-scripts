#! /bin/bash

SOLR_HOST=$1

if [[ "$SOLR_HOST" == "" ]]; then
    echo "Please give Solr host and port e.g. localhost:8983"
    exit 0
fi

curl -v "http://$SOLR_HOST/solr/admin/collections?action=CREATE&name=User_Master&numShards=1&replicationFactor=1&maxShardsPerNode=1&collection.configName=UserMaster"
curl -v "http://$SOLR_HOST/solr/admin/collections?action=CREATE&name=ADT_Master&numShards=1&replicationFactor=1&maxShardsPerNode=1&collection.configName=AdtSearch"
curl -v "http://$SOLR_HOST/solr/admin/collections?action=CREATE&name=CC_Physician&numShards=1&replicationFactor=1&maxShardsPerNode=1&collection.configName=CCPhysician"
curl -v "http://$SOLR_HOST/solr/admin/collections?action=CREATE&name=Document_Master&numShards=1&replicationFactor=1&maxShardsPerNode=1&collection.configName=DocumentMaster"
curl -v "http://$SOLR_HOST/solr/admin/collections?action=CREATE&name=Macros_Suggester&numShards=1&replicationFactor=1&maxShardsPerNode=1&collection.configName=MacrosSuggester"
curl -v "http://$SOLR_HOST/solr/admin/collections?action=CREATE&name=Mt_Document_Master&numShards=1&replicationFactor=1&maxShardsPerNode=1&collection.configName=MtDocumentMaster"
curl -v "http://$SOLR_HOST/solr/admin/collections?action=CREATE&name=Ref_Documents&numShards=1&replicationFactor=1&maxShardsPerNode=1&collection.configName=RefDocumentSearchh"
curl -v "http://$SOLR_HOST/solr/admin/collections?action=CREATE&name=CNT_Document_Master&numShards=1&replicationFactor=1&maxShardsPerNode=1&collection.configName=CNTDocumentMaster"
curl -v "http://$SOLR_HOST/solr/admin/collections?action=CREATE&name=NP_New_Document_Master&numShards=1&replicationFactor=1&maxShardsPerNode=1&collection.configName=NewNPDocumentMaster"
curl -v "http://$SOLR_HOST/solr/admin/collections?action=CREATE&name=Spell_Check&numShards=1&replicationFactor=1&maxShardsPerNode=1&collection.configName=SpellCheck"
