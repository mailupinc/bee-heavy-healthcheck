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
    printf '%b' "${Red}"
    echo
    echo "Run script from the project dir ${PRJ_DIR} "
    echo "    example:"
    echo "             $ cd ${PRJ_DIR}"
    echo "             $ ./scripts/${SCRIPT_NAME}"
    echo
    printf '%b' "${NC}"
    exit
fi

printf '%b' "${Yellow}"
echo
echo " Run unit and integrations tests"
echo " ==============================="
printf '%b' "${NC}"
echo "   - ✨ uses local poetry virtual env"
echo
printf '%b' "${Light_Gray}"
echo " Example run:"
echo "     $ scripts/${SCRIPT_NAME}                # Run also integration tests (using db)"
echo "     $ scripts/${SCRIPT_NAME} -k my_test     # Filter tests. only when my_test is part of the full path"
echo "     $ scripts/${SCRIPT_NAME} -l -vv         # Prints all variables when test fails, verbose output for assertions"
echo "     $ scripts/${SCRIPT_NAME} --lf           # Rerun only the tests that failed at the last run (or all if none failed)"
echo "     $ scripts/${SCRIPT_NAME} --trace        # debug on every test"

echo
printf '%b' "${NC}"

export git_sha=$(git rev-parse --short --verify HEAD 2>/dev/null)
export git_tag="test_${git_sha}_$(TZ=UTC date +v%y.%m.%d.%H%M%Z)"

# --disable-warnings
poetry run pytest -ra -v tests -s --pdbcls=IPython.terminal.debugger:TerminalPdb "$@"
