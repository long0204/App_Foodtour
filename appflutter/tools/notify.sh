TELEGRAM_BOT_TOKEN="6265560407:AAHcP3cOCoVJQcDVFrrP3e0tHi3hmi-S7ME"
TELEGRAM_CHAT_ID="-1002395266062" #new= -1002395266062 #mobileGR = -4066221928
THREAD_ID="340"
USER_USERNAME="dungnhi_02" #changg27 dungnhi_02
TESTER_ID="6360806888"  #253513711 6360806888
DEV_ID="1253513711"

INFO_TAG="\e[36m[INFO]\e[0m \e[36m" 
WARNING_TAG="\e[1;33m[WARNING]\e[0m \e[1;33m" 
ERROR_TAG="\e[0;31m[ERROR]\e[0m \e[0;31m"  
RESET="\e[0m"  

APK_LINK="https://deploygate.com/organizations/testerdinos/platforms/android/apps/com.dinos.tingx"
IPA_LINK="https://webclip.deploygate.com/apps"
# IPA_LINK="https://deploygate.com/organizations/testerdinos/platforms/ios/apps/com.dinos.tingx"

if [ "$1" = "ANDROID" ]; then
    LINK=$APK_LINK
elif [ "$1" = "IOS" ]; then
    LINK=$IPA_LINK
fi

BUILD_ERROR="❌ Build $2 lỗi rồi!!! 
<a href=\"tg://user?id=$DEV_ID\">Đại ca</a> build lại đi."

DEPLOY_ERROR="❌ Deploy $2 lỗi rồi!!! 
<a href=\"tg://user?id=$DEV_ID\">Đại ca</a> deploy lại đi."

RELEASE_NOTE="🚀 *New $1 Release Available* 🚀
Triệu hồi [@$USER_USERNAME](tg://user?id=$TESTER_ID) vào tét app.

**Download Link:** [$1]($LINK)

*Release Notes:*
$2"


if [ "$1" -eq 1 ]; then
     PARSE_MODE="HTML"
     MESSAGE=$BUILD_ERROR
elif [ "$1" -eq 2 ]; then
     PARSE_MODE="HTML"
     MESSAGE=$DEPLOY_ERROR
else
      PARSE_MODE="Markdown"
      MESSAGE=$RELEASE_NOTE
fi

echo "$INFO_TAG Send Nude...$RESET"

response=$(curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
     -d "chat_id=$TELEGRAM_CHAT_ID" \
     -d "text=$MESSAGE" \
     -d "message_thread_id=$THREAD_ID"\
     -d "parse_mode=$PARSE_MODE")

# Kiểm tra xem response có chứa "ok":true không
if [[ $response == *"\"ok\":true"* ]]; then
    echo "$INFO_TAG Đã gửi$RESET"
else
    echo "$ERROR_TAG Gửi tin nhắn thất bại.
$response $RESET"
   exit 1
fi
