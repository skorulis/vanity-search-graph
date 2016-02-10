#!/bin/bash

ruby updateGraph.rb

DATESTRING=`date`

git commit -a -m "Update $DATESTRING"

git push origin gh-pages
