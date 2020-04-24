#!/usr/bin/env bash

sudo gitlab-runner register \
    --non-interactive \
    --url "${ gitlab_runner_coordinator_url }" \
    --registration-token "${ gitlab_runner_registration_token }" \
    --description "${ gitlab_runner_description }" \
    --executor "${ gitlab_runner_executor }"