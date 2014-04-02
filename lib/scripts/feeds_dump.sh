#!/bin/bash

#------------------------------------------------------
# File: /home/caleb/workspace/buzz/lib/scripts/feeds_dump.sh
# Author: Caleb Everett
# Description: Dumps feeds from heroku postgresql database
#------------------------------------------------------

feed_sql="SELECT feed_url from podcasts"
output_file=$(date +%d-%m-%y)_feeds_dump

echo "Dumping feeds from heroku"
echo "$feed_sql" | heroku pg:psql \
  | head -n -2                    \
  | tail -n +3                    \
> $output_file

feed_count=$(cat $output_file | wc -l)
echo "$feed_count feeds written to $output_file"


