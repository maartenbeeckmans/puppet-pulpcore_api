#!/bin/bash

exposed_paths=$(pulp deb distribution list --limit 10000 | jq '.[].base_path' | xargs)

for exposed_path in $exposed_paths; do
  http_status_code=$(curl -o /dev/null -s -w "%{http_code}\n" "http://`hostname`/pulp/content/${exposed_path}/" | xargs)
  if [[ $http_status_code -ne 200 ]]; then
    echo $exposed_path
    echo "http://`hostname`/pulp/content/${exposed_path}/"
    echo "http status code: $http_status_code"
    repository_href=$(pulp deb distribution list --base-path $exposed_path --limit 1 | jq '.[0].repository' | xargs)
    repository_name=$(pulp deb repository show --href $repository_href | jq '.name' | xargs)
    pulp deb publication create --repository $repository_name --structured true
  fi
done
