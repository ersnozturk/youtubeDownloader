#!/bin/bash

# 🎯 Yardım komutu
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
  echo ""
  echo "YouTube Video Downloader"
  echo ""
  echo "Kullanım:"
  echo "  ./yt-downloader.sh <video_url> [kalite] [baslangic_zamani] [bitis_zamani]"
  echo ""
  echo "Parametreler:"
  echo "  <video_url>          Gerekli. İndirilecek YouTube video bağlantısı."
  echo "  [kalite]             Opsiyonel. Çözünürlük (örn: 720, 1080). Varsayılan: 720p"
  echo "  [baslangic_zamani]  Opsiyonel. Kesilecek videonun başlangıç zamanı (HH:MM:SS)"
  echo "  [bitis_zamani]      Opsiyonel. Kesilecek videonun bitiş zamanı (HH:MM:SS)"
  echo ""
  echo "Örnekler:"
  echo "  ./yt-downloader.sh https://youtu.be/dQw4w9WgXcQ"
  echo "  ./yt-downloader.sh https://youtu.be/dQw4w9WgXcQ 1080 00:01:00 00:02:00"
  echo ""
  exit 0
fi

# 🎯 Parametreler
URL="$1"
QUALITY="${2:-720}"
START_TIME="$3"
END_TIME="$4"
OUTPUT_DIR="downloads"

# 🚨 URL zorunlu
if [[ -z "$URL" ]]; then
  echo "⚠️  Kullanım: $0 <video_url> [kalite] [baslangic] [bitis]"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "🔍 Video bilgisi alınıyor..."
VIDEO_TITLE=$(yt-dlp --get-title "$URL" 2>/dev/null)

if [[ -z "$VIDEO_TITLE" ]]; then
  echo "❌ Video başlığı alınamadı. Geçersiz bağlantı olabilir."
  exit 2
fi

SAFE_TITLE=$(echo "$VIDEO_TITLE" | tr ' ' '_' | tr -cd '[:alnum:]_-')
FINAL_QUALITY=""
OUTPUT_FILE=""
FINAL_OUTPUT_FILE=""

echo "🎯 Video: $VIDEO_TITLE"
echo "🎯 Kalite: ${QUALITY}p"

FORMAT_LIST=$(yt-dlp -F "$URL" 2>/dev/null)

VIDEO_CODE=$(echo "$FORMAT_LIST" | awk -v q="${QUALITY}" '$0 ~ q"p" && /video only/ {print $1; exit}')
AUDIO_CODE=$(echo "$FORMAT_LIST" | grep 'audio only' | awk '{print $1}' | head -n 1)

if [[ -n "$VIDEO_CODE" && -n "$AUDIO_CODE" ]]; then
  FINAL_QUALITY="${QUALITY}p"
else
  FINAL_QUALITY="best"
  echo "⚠️  ${QUALITY}p bulunamadı, en yüksek kalite indirilecek."
fi

# Orijinal video dosyası (önce buraya indirilir)
ORIGINAL_FILE="${OUTPUT_DIR}/${SAFE_TITLE}_${FINAL_QUALITY}_FULL.mp4"

# Sonuç dosyası (kesilecekse buraya)
if [[ -n "$START_TIME" && -n "$END_TIME" ]]; then
  FINAL_OUTPUT_FILE="${OUTPUT_DIR}/${SAFE_TITLE}_${FINAL_QUALITY}_${START_TIME//:/-}_to_${END_TIME//:/-}.mp4"
else
  FINAL_OUTPUT_FILE="${OUTPUT_DIR}/${SAFE_TITLE}_${FINAL_QUALITY}.mp4"
fi

echo "💾 Geçici indirme: $ORIGINAL_FILE"

echo "⬇️  Video indiriliyor..."
if [[ "$FINAL_QUALITY" == "best" ]]; then
  yt-dlp -f "bv*+ba/b" --merge-output-format mp4 -o "$ORIGINAL_FILE" "$URL"
else
  yt-dlp -f "${VIDEO_CODE}+${AUDIO_CODE}" --merge-output-format mp4 -o "$ORIGINAL_FILE" "$URL"
fi

if [[ $? -ne 0 || ! -f "$ORIGINAL_FILE" ]]; then
  echo "❌ İndirme başarısız."
  exit 3
fi

# 🔪 Kesme işlemi varsa uygula
if [[ -n "$START_TIME" && -n "$END_TIME" ]]; then
  echo "✂️  Video kesiliyor: $START_TIME → $END_TIME"
  ffmpeg -hide_banner -loglevel error -ss "$START_TIME" -to "$END_TIME" -i "$ORIGINAL_FILE" -c copy "$FINAL_OUTPUT_FILE"
  if [[ $? -eq 0 ]]; then
    echo "✅ Kesme tamamlandı: $FINAL_OUTPUT_FILE"
    rm -f "$ORIGINAL_FILE"
  else
    echo "❌ Kesme işlemi başarısız."
    exit 4
  fi
else
  mv "$ORIGINAL_FILE" "$FINAL_OUTPUT_FILE"
  echo "🎯 Video kesilmeyecek. Kesmek için başlangıç ve bitiş zamanlarını belirtin."
  echo "✅ Video indirildi: $FINAL_OUTPUT_FILE"
fi