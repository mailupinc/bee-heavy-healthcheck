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

printf "${Yellow}"
echo
echo " Run all pre-commit tasks"
echo " ==============================="
printf "${NC}"
echo

poetry run pre-commit run --all-files
