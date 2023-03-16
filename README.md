# Heavy Healthcheck

## getting started

```bash

asdf local python 3.10.2

# find paht of python
asdf where python 3.10.2

poetry env use $(asdf where python 3.10.2)/bin/python

# check Executable path in this call
# use this path for vscode interpreter path
poetry env info

poetry install

poetry run pre-commit install

```

## project scripts

```bash

# pre commit
./scripts/pre-commit-run.sh

# pytest on local machine
./scripts/tests-run-local-pytest.sh

# coverage on local machine
./scripts/tests-run-local-coverage.sh

# coverage on docker
./scripts/tests-run-docker.sh

```
