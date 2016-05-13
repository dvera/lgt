#!/usr/bin/env bash

archive=${HOME}/.ghtdb
tmpfile="/tmp/${USER}_latest_ght"

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

rm -f new.gt

for i in $languages; do

  echo $i
  curl -sG https://api.github.com/search/repositories --data-urlencode "sort=stars" --data-urlencode "order=desc" --data-urlencode "q=language:${i}" | jq ".items[0,1,2,3,4,5,6,7,8,9,10] | {name, language, html_url, description}" | sed 's/.*": "//g' | grep -v '{' | grep -v '}' | sed 's/",$//g' | paste - - - - >> $tmpfile
  sleep 5
done

grep -vFf $archive $tmpfile

grep -vFf $archive $tmpfile | cut -f 3 >> $archive





