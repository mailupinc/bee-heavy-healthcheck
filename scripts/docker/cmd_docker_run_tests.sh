#!/bin/bash
set -u # or set -o nounset
SCRIPT_NAME=$(basename $0)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
PRJ_DIR="$(cd "${SCRIPTS_DIR}/.." && pwd)"

Yellow='\033[1;33m'
Red='\033[0;31m'
Light_Cyan='\033[1;36m'
Light_Gray='\033[0;37m'
NC='\033[0m' # No Color
# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37

# =================================
# How to run this script
# =================================
# This script the CMD command in the Docker file, for the [test] target
#
# To run the tests inside docker env use this script:
# $ ./scripts/tests-run-docker.sh
#
#

export bee_env=${bee_env:-test}
export git_sha=${git_sha:-missing}
export git_tag=${git_tag:-missing}
export pytest_flags=${pytest_flags:-}

printf "${Yellow}"
echo "<>--<>  Running tests   <>--<>--<>--<>--<>--<>--<>--<>--<>--<>"

printf "${Yellow}"
echo "<>--<>  print env:"
printf "${Light_Gray}"
echo "    git_sha      : ${git_sha}"
echo "    git_tag      : ${git_tag}"
echo "    pytest_flags : ${pytest_flags}"
printf "${NC}"

printf "${Yellow}"
echo "<>--<>  cleanup old reports"
printf "${NC}"

rm -rf ${PRJ_DIR}/tests_reports/
mkdir -v -p ${PRJ_DIR}/tests_reports/
printf "${Yellow}"

printf "${Yellow}"
echo "<>--<>  run coverage pytest"
printf "${NC}"

${POETRY_HOME}/bin/poetry run python -m coverage run \
    --source bee_heavy_healthcheck -m pytest -ra -v tests ${pytest_flags} \
    --junitxml=tests_reports/junit/junit.xml \
    --html=tests_reports/pytest/report.html

printf "${Yellow}"
echo "<>--<>  generate reports"
printf "${NC}"

${POETRY_HOME}/bin/poetry run python -m coverage report
${POETRY_HOME}/bin/poetry run python -m coverage html
${POETRY_HOME}/bin/poetry run python -m coverage xml -o tests_reports/cov.xml
cp -r htmlcov tests_reports/htmlcov
chmod 777 ${PRJ_DIR}/tests_reports/

printf "${Yellow}"
echo "<>--<>  all done!   <>--<>--<>--<>--<>--<>--<>--<>--<>--<>"
printf "${NC}"
