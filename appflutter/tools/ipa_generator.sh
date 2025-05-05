#!/bin/bash

CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

cd "$(dirname "$0")/.."

echo "${CYAN}🚀 Building iOS release...${NC}"
flutter build ios --release || {
  echo "${RED}❌ Build thất bại.${NC}"
  exit 1
}

echo "${CYAN}📦 Đóng gói file IPA...${NC}"
rm -rf Payload Payload.ipa
mkdir Payload
cp -R build/ios/iphoneos/Runner.app Payload/

zip -r -y Payload.ipa Payload
rm -rf Payload

if [ -f "Payload.ipa" ]; then
  echo "${CYAN}✅ File IPA đã sẵn sàng: Payload.ipa${NC}"
else
  echo "${RED}❌ Build xong nhưng không tạo được IPA.${NC}"
  ./notify.sh 1 'IOS'
  exit 1
fi
