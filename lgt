#!/usr/bin/env bash

# TO DO: get list of languages and check if languages are valid
# TO DO: use authtoken to make requests faster

lgtdir=${HOME}/.lgt
archive=$lgtdir/archive
tmpfile=$lgtdir/tmp
lanfile=$lgtdir/languages
tokfile=$lgtdir/token

if [ ! -e $lgtdir ]; then
  mkdir -p $lgtdir
fi

if [ ! -e $lanfile ]; then
  echo -e 'c\ncpp\nshell' > $lanfile
fi

if [ ! -e $lgtdir/token ]; then
  hastoken=false
else
  hastoken=true
fi

if [ ! -e $archive ]; then
  touch $archive
fi



if [ $# -gt 0 ]; then
  if [ $1 = "token" ]; then
    if [ $# -lt 2 ]; then
      echo "Please supply personal authentication token"
    else
      echo $2 > $tokfile
    fi
  else
    languages=$1
  fi
else
  languages=$(cat $lanfile | tr '\n' ' ')
fi

for i in $languages; do
  echo $i
  curl -sG https://api.github.com/search/repositories --data-urlencode "sort=stars" --data-urlencode "order=desc" --data-urlencode "q=language:${i}" | jq ".items[0,1,2,3,4,5,6,7,8,9,10] | {name,language,html_url,description}" | sed 's/.*": "//g' | grep -v '{' | grep -v '}' | sed 's/",$//g' | paste - - - - >> $tmpfile
  sleep 6
done



if [ -e $tmpfile ]; then
  grep -vFf <(cut -f 3 $archive) $tmpfile | tee -a $archive | awk '{print $0,""}' OFS='\t' | tr '\t' '\n'
  rm $tmpfile
fi
