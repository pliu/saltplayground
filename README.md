# Salt Playground
Salt Playground is a Docker-based environment built to facilitate experimentation with a tight feedback loop, thus accelerating learning and understanding of Salt.

When the container is started, the Salt config (specified in config/minion), pillars (specified in pillar/), and Salt states (specified in salt/) are mounted into the container (with the pillars and Salt states mounted at the locations specified in the Salt config). As a result, local changes made to these files are instantly reflected in the container, allowing them to be tested immediately.

You can destroy and recreate the container to reset it if during the course of experimentation the container gets into a bad state - a major benefit of having such a local environment.

Examples of things to experiment with:

- configuring Salt
- writing Salt states
- factoring out environment-specific variables into pillars
- Jinja-based control flow
- custom modules to extend Salt functionality

## Components used in setting up this project
```
docker 19.03.6
```

## Repository structure
```
root
|- environments
|  |- ...
|     |- config
|     |  |- ...
|     |- pillar
|     |  |- ...
|     |- salt
|     |  |- _modules?
|     |  |  |- ...
|     |  |- ...
|     |  |- top.sls
|     |- docker-compose.yaml?
|     |- Dockerfile
|     |- README.md
|- Makefile
|- README.md
```
Current environments include:
- [basic](environments/basic/README.md)
- [kubernetes](environments/kubernetes/README.md)

## How it works
The minion file contains the configuration Salt uses. This project runs Salt in masterless mode (i.e., the minion does not connect to a central service that contains the Salt states and pillars, instead using local state and pillar files). The configuration also specifies where Salt searches for Salt states and pillars as well as the environments those states and pillars are associated with (e.g., Salt states found under /srv/salt are associated with the "base" environment while pillars found under /srv/pillar/dev are associated with the "dev" environment). Finally, the minion configuration's  "environment" and "pillarenv" attributes determine which Salt states and pillars to use.

Given the minion's environment and the paths under which to search for Salt states and pillars based on that environment, Salt then uses top.sls files to determine which states to run and which pillars to include. In this project, the states to run and pillars to include are based on a minion's roles, which are also defined in its configuration as a grain - a map for capturing some host properties that we've injected the "roles" key into. Given a match between a minion's role and a section in top.sls (more generally, we can match against any grain, not just roles), Salt runs all of the states and includes all of the pillars under the matching section.

When writing Salt states, they can be thought of as declarative "code" that specifies the desired state of the host (e.g., a file should exist at /a/b/c, owned by x, with y permissions, and containing z). Just as configuration should be separated from code, we separate out variables into pillars, allowing us to re-use the Salt states (e.g., the common steps taken to set up Elasticsearch would be captured in the Salt states, with the variations between different deployments, such as the cluster's name and settings, being captures in the pillar files).

For more advanced control flow, we use Jinja templating. A good guide can be found [here](https://docs.saltstack.com/en/latest/topics/jinja/index.html).

## Commands
```
Exec into the test container:
docker exec -it saltplayground /bin/bash

Apply state (to be run inside the test container):
salt-call state.apply <state name; if not specified, applies all states>

List states (to be run inside the test container):
salt-call state.show_sls '*'

List pillar values (to be run inside the test container):
salt-call pillar.items

List grain values (to be run inside the test container):
salt-call grains.items

Sync modules (to be run inside the test container; required to update modules unless calling state.apply):
salt-call saltutil.sync_modules
```
