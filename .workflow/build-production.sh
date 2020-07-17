#! /bin/bash
github_org_name=sswconsulting
github_repo_name=SSW.People
azdo_org_name=https://ssw.visualstudio.com
azdo_project_name=ssw.people
azdo_pipeline_name=Production
azdo_pipeline_name_cn='Production China'

# exit when any command fails
set -e

# ensure devops extension is available
az extension add -n azure-devops

# get latest release branch from other repo
echo Querying GitHub...
branch_list=$(curl -s -X GET https://api.github.com/repos/${github_org_name}/${github_repo_name}/branches) 
branch_name=$(jq -r  '[.[].name | select(startswith("release/"))] | sort_by(.[8:]|tonumber) | reverse | .[0]' <<< "${branch_list}") 
echo Latest release branch: ${branch_name}

echo triggering AzDO build
az pipelines build queue --org $azdo_org_name --project $azdo_project_name --definition-name $azdo_pipeline_name --branch $branch_name
az pipelines build queue --org $azdo_org_name --project $azdo_project_name --definition-name $azdo_pipeline_name_cn --branch $branch_name

echo done
