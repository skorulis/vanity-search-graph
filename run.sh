#!/bin/bash

ruby updateResults.rb

DATESTRING=`date`

git commit -a -m "Update $DATESTRING"

git push origin gh-pages
