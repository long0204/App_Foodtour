
DEPLOYGATE_USER_TOKEN="deploygate_xgrp_nS08p4HeGTEkc40QcDKAoThmKiUWIb_0ErkSw"
DEPLOYGATE_PROJECT_OWNER="testerdinos"
DEPLOYGATE_PROJECT_NAME="ting_x"


YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

APK_FILE_PATH="build/app/outputs/flutter-apk/app-release.apk"
IPA_FILE_PATH="Payload.ipa"

if [ "$1" = "ANDROID" ]; then
  FILE=$APK_FILE_PATH
elif [ "$1" = "IOS" ]; then
  FILE=$IPA_FILE_PATH
else
  echo "${RED}Quá trình pick file $1 có lỗi. Vui lòng kiểm tra và sửa lỗi.${NC}"
  exit 1
fi

echo "${YELLOW}Uploading...${NC}"

curl -F "file=@${FILE}" \
     -F "token=${DEPLOYGATE_USER_TOKEN}" \
     -F "owner_name=${DEPLOYGATE_PROJECT_OWNER}" \
     -F "app=${DEPLOYGATE_PROJECT_NAME}" \
     -F "message=${2}" \
     https://deploygate.com/api/users/${DEPLOYGATE_PROJECT_OWNER}/apps


if [ $? -eq 0 ]; then
    echo "\n${RED}$1 ${CYAN}Uploaded${NC}"
else
    echo "${RED}Quá trình deploy $1 có lỗi. Vui lòng kiểm tra và sửa lỗi.${NC}"
    ./notify.sh 2 $1
    exit 1
fi