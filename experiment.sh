#!/bin/bash

USAGE="USAGE: ./experiment.sh {DBpedia | IMDb |KTUP_DBpedia | Satori}  {ml1m } [exp_description]"
if [ ${#} != 2 ] && [ ${#} != 3 ]
then
  echo $USAGE;
  exit 1
fi

KG="${1}"
DATASET="$2"
DESC="${3}"
if [ $DESC != "" ]
then
  DESC="_"${3}
fi

case ${KG} in
  Satori)
    kg="satori";;
  KTUP_DBpedia)
    kg="ktup_debpdia";;
  DBpedia)
    kg="dbpedia";;
  IMDb)
    kg="imdb";;
   *)
    echo $USAGE;
    exit 1
esac
case $DATASET in
  ml1m)
    ;;
   *)
    echo $USAGE;
    exit 1
esac


Target="${KG}_on_${DATASET}${DESC}"
for ratio in `seq 0.25 0.25 0.75`
do
  if [ -e ./datasets/$DATASET/i2kg_map.tsv ] #TODO: Seperating KG and IG
  then
    rm ./datasets/$DATASET/i2kg_map.tsv;
    ln -s ./i2kg_map_${ratio}.tsv ./datasets/$DATASET/i2kg_map.tsv;
  else
    ln -s ./i2kg_map_${ratio}.tsv ./datasets/$DATASET/i2kg_map.tsv;
  fi
  mkdir -p ./log/$Target
  python3 run_knowledgable_recommendation.py -model_type jtransup -dataset $DATASET -data_path ./datasets/ -log_path ./log/$Target -rec_test_files valid.dat:test.dat  -nohas_visualization -topn 10 -experiment_name $ratio"_missing"
done
# python3 run_item_recommendation.py -model_type transup -dataset $DATASET -data_path ./datasets/ -log_path ./log/$Target  -rec_test_files valid.dat:test.dat -nohas_visualization -topn 10
