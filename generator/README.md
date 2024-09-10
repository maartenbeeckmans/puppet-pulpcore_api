# Generator

A generator is used for generating the following resources:

- get_pulp_href function
- get_pulp_href spec tests
- provider
- provider spec tests
- type
- type spec tests

The generator uses a few files to work:

- `api.json`: api docs that can be downloaded from the pulpcore server. The best way is to run the ![Pulp in one container](https://pulpproject.org/pulp-in-one-container/) and downloading the api with the following command: `curl localhost:8080/pulp/api/v3/docs/api.json -o api.json`
- `config.yaml`: the config.yaml file specifies the resources that will + generated with additional information needed by the generator script
    - *schema*: schema
    - *name*: name of the puppet type, provider and get_pulp_href function that will be generated
    - *namevar*: parameter that will act as namevar in puppet
    - *client_binding*: client binding
    - *client_binding_api*: client binding api
    - *client_binding_model*: client binding model
- `generator.rb`: main script that's used for generating the resources.
- `*.rb.erb`-files: embedded ruby template files that will be used for generating the types/providers/functins/spec tests

> When upgrading the resources and api doc, make sure to also update the versions of the client bindings specified in `data/common.yaml`

## Changes

### 2024-09-10

Update api.json to 3.49.19, this version works with the following plugins:
 - **core**: 3.49.19
 - **container**: 2.20.3
 - **deb**: 3.2.1
 - **rpm**: 3.26.1
 - **file**: 3.49.19
These plugins are the latest found in the pulpcore RPM repository from The Foreman.

### 2021-08-25

The current version of the api.json works with the following plugins:

 - **core**: 3.14.3
 - **rpm**: 3.14.0
 - **file**: 1.8.1
 - **deb**: 2.14.1
 - **container**: 2.7.1
