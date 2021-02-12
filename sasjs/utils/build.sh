#!/bin/bash

#generate docs
sasjs doc

# now deploy the site wherever you need
rsync -avz sasjsbuild/docs/* someserver.com:/var/www/html/docs
