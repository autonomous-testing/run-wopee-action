# Run tests by Wopee bot using docker container

## Example usage of the action in GitHub workflow

```YAML
name: 'Example Wopee run'
description: 'Example workflow to run Wopee bot action'

on:
  workflow_dispatch:
  push:

jobs:
  run-wopee:
    name: Run Wopee
    runs-on: ubuntu-latest

    steps:
        - name: Log in to the Wopee container registry
          uses: docker/login-action@v2
          with:
              registry: ghcr.io/autonomous-testing
              username: ${{ secrets.wopee_registry_username }}
              password: ${{ secrets.wopee_registry_password }}

        - name: Run Wopee using docker
          uses: autonomous-testing/run-wopee-action@v1
          with:
              image: ghcr.io/autonomous-testing/wopee:latest # optional, default value: ghcr.io/autonomous-testing/wopee:latest
              config: wopee_config_for_your_project.yaml # optional, default value: config.yaml
              s3_host: ${{ secrets.wopee_s3_host }}
              s3_access_key: ${{ secrets.wopee_s3_access_key }}
              s3_secret_key: ${{ secrets.wopee_s3_secret_key }}

```
## Customizing

### inputs

Following inputs can be used as `step.with` keys

| Name             | Type    | Default                                  | Description                        |
|------------------|---------|------------------------------------------|------------------------------------|
| `image`          | String  | ghcr.io/autonomous-testing/wopee:latest  | Full path to Wopee image |
| `config`         | String  | config.yaml                              | Path to config file stored in S3 comaptible storage in bucked 'wopee-configs' or path to mounted config file relative to current working directory. |
| `s3_host`        | String  |                                          | Host for accessing files compatible with s3 api |
| `s3_access_key`  | String  |                                          | Access key for accessing files compatible with s3 api |
| `s3_secret_key`  | String  |                                          | Secret key for accessing files compatible with s3 api |

## Example usage of run-wopee.sh script

```Bash
# First login to container registry
# For GitHub container registry (ghcr.io) see https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry
export CR_PAT=YOUR_TOKEN
echo $CR_PAT | docker login ghcr.io -u YOUR_USERNAME --password-stdin

# Optionaly select image and config file
export IMAGE=ghcr.io/autonomous-testing/wopee:latest # optional, default value: ghcr.io/autonomous-testing/wopee:latest
export CONFIG=wopee_config_for_your_project.yaml # optional, default value: config.yaml

# Setup access to file sotrage
export S3_HOST=s3.example.wopee.io
export S3_ACCESS_KEY=username_for_s3
export S3_SECRET_KEY=password_for_s3

# Run Wopee
sh run-wopee.sh

```

## Example usage of direct run in docker (NOT RECOMMENDED)

```Bash
# See the example
cat run-wopee.sh

```

## Example usage of direct run of bot (NEVER DO THAT)

```Bash
# You have been warned
wopee wopee_config_for_your_project.yaml

```