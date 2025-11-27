CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

flutter clean

flutter build apk

if [ $? -eq 0 ]; then
    echo "${CYAN}Quá trình build APK thành công!${NC}"
else
    echo "${RED}Quá trình build APK có lỗi. Vui lòng kiểm tra và sửa lỗi.${NC}"
    ./notify.sh 1 'ANDROID'
    exit 1
fi