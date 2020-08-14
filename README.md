# Salt Playground


## Commands
```
Exec into the test container:
docker exec -it saltplayground /bin/bash

Run highstate (to be run inside the test container):
salt-call state.highstate

List pillar values (to be run inside the test container):
salt-call pillar.items

List grain values (to be run inside the test container):
salt-call grains.items

Start test container:
make run

Stop test container:
make stop
```
