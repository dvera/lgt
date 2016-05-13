#!/usr/bin/env bash

archive=${HOME}/.lgtdb
tmpfile="/tmp/.${USER}.lgt"

languages="
makefile
c
cpp
coffeescript
css
go
haskell
html
javascript
perl
python
r
ruby
rust
shell
"

rm -f $archive

touch $archive

for i in $languages; do

  echo $i
  curl -sG https://api.github.com/search/repositories --data-urlencode "sort=stars" --data-urlencode "order=desc" --data-urlencode "q=language:${i}" | jq ".items[0,1,2,3,4,5,6,7,8,9,10] | {description,html_url,language,name}" | sed 's/.*": "//g' | grep -v '{' | grep -v '}' | sed 's/",$//g' | paste - - - - >> $tmpfile
  sleep 6
done

grep -vFf <(cut -f 3 $archive) $tmpfile | tee -a $archive | awk '{print $0,""}' OFS='\t' | tr '\t' '\n'

rm $tmpfile




