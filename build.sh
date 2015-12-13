#!/usr/bin/env bash

# Sciprt for cronjob, will open an issue on cdnjs/cdnjs if build failed.

StartTimestamp="`date +%s`"

pth="$(dirname $(readlink -f $0))"
. "$pth/config.sh"

apiUrl='https://api.github.com/repos/cdnjs/cdnjs/issues'

IssueTitle="[Build failed] Got error while building meta data/artifact"
IssueAssignee="PeterDaveHello"
IssueLabels='["Bug - High Priority"]'
IssueContent="`sed ':a;N;$!ba;s/\n/\\\n/g' $pth/issueTemplate`"

Issue="{ \"title\": \"$IssueTitle\", \"body\": \"$IssueContent\", \"assignee\": \"$IssueAssignee\", \"labels\": $IssueLabels }"

nice -n 15 "$pth/update-website.sh" || curl --silent -H "Authorization: token $githubToken" -d "$Issue" "$apiUrl" > /dev/null

EndTimestamp="`date +%s`"

echo -e "\nTotal time spent for this build is _$(($EndTimestamp - $StartTimestamp))_ second(s)\n"
