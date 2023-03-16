#!/bin/bash
set -u # or set -o nounset
SCRIPT_NAME=$(basename $0)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PRJ_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

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

if [[ "${PRJ_DIR}" != "$(pwd)" ]]; then
    printf "${Red}"
    echo
    echo "Run script from the project dir ${PRJ_DIR} "
    echo "    example:"
    echo "             $ cd ${PRJ_DIR}"
    echo "             $ ./scripts/${SCRIPT_NAME}"
    echo
    printf "${NC}"
    exit
fi

test_report_dir="./tests_reports"
docker_compose_file="./docker/docker-compose-test.yml"

PARAM1=${1-NOTHING}
if [[ $PARAM1 = "--help" ]]; then
    printf "${Yellow}"
    echo " "
    echo " Run all tests and coverage all (py and db) in containers"
    echo " ========================================================"
    printf "${NC}"
    echo
    echo " It's the same run done with the Burno (Jenkins) Pipeline"
    echo "     -1- Uses docker-compose with [${docker_compose_file}]"
    echo "     -2- Initialize the db with data from [./test_db/local_pg/data-seed/]"
    echo "     -3- Run unit and integration tests"
    echo "     -4- Copy all tests results in dir [${test_report_dir}] "
    echo ""
    printf "${Light_Gray}"
    echo "     Examples:"
    echo "             $ scripts/${SCRIPT_NAME}             # Run tests inside a docker container (it starts also a db)"
    echo "             $ scripts/${SCRIPT_NAME}  --clean    # Destroy all containers"
    echo "             $ scripts/${SCRIPT_NAME}  --top      # Shows all processes in started containers"
    echo "             $ scripts/${SCRIPT_NAME}  --help     # Print help"
    echo ""
    echo ""
    printf "${NC}"
    exit
fi

if [[ $PARAM1 = "--clean" ]]; then
    printf "${Yellow}"
    echo " "
    echo " Destroy all containers  (docker-compose rm --stop --force -v)"
    echo " ============================================================="
    echo " "
    printf "${NC}"
    docker-compose -f "${docker_compose_file}" rm --stop --force -v
    echo
    echo " CLEAN DONE "
    echo
    exit
fi

if [[ $PARAM1 = "--top" ]]; then
    printf "${Yellow}"
    echo " "
    echo " Shows all processes in started containers (docker-compose top)"
    echo " =============================================================="
    echo " "
    printf "${NC}"
    docker-compose -f "${docker_compose_file}" top
fi

export bee_env=test

printf "${Light_Gray}"
echo "running tests bee_env:${bee_env}"
printf "${NC}"

export git_sha=$(git rev-parse --short --verify HEAD 2>/dev/null)
export git_tag="test_${git_sha}_$(TZ=UTC date +v%y.%m.%d.%H%M%Z)"

export build_target=test
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1
export COMPOSE_PROJECT_NAME=heavy-healthcheck
export pytest_flags="$@"
# export BUILDKIT_PROGRESS=plain

printf "${Yellow}"
echo
echo "Run pytest in docker with extra params [ $@ ]"
echo
printf "${NC}"

docker-compose -f "${docker_compose_file}" build
docker-compose -f "${docker_compose_file}" run service-bee-heavy-healthcheck-tests
# docker-compose -f "${docker_compose_file}" run --rm service-bee-heavy-healthcheck-tests
# docker-compose -f "${docker_compose_file}" rm --stop --force

echo ""
echo " DONE "
echo ""
echo " =============================================================="
echo "Details in reports:"
find "${test_report_dir}" -iname index.html -o -iname report.html -o -iname junit.xml
echo " =============================================================="
echo ""
