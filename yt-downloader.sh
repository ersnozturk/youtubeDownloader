#!/bin/bash

URL="$1"
QUALITY="${2:-720}"
OUTPUT_DIR="downloads"

if [[ -z "$URL" ]]; then
  echo "⚠️  Kullanım: $0 <video_url> [kalite örn: 720]"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "🔍 Video bilgisi alınıyor..."
VIDEO_TITLE=$(yt-dlp --get-title "$URL" 2>/dev/null)
SAFE_TITLE=$(echo "$VIDEO_TITLE" | tr ' ' '_' | tr -cd '[:alnum:]_-')

# Geçici olarak FINAL_QUALITY belirleyelim (720p, 1080p vs.)
FINAL_QUALITY=""

echo "🎯 Video: $VIDEO_TITLE"
echo "🎯 İstenen kalite: ${QUALITY}p"

# Format listesini al
FORMAT_LIST=$(yt-dlp -F "$URL" 2>/dev/null)

# Kullanıcının istediği kaliteye uygun video formatını bul (video only olabilir)
VIDEO_CODE=$(echo "$FORMAT_LIST" | awk -v q="${QUALITY}" '$0 ~ q"p" && $0 ~ /video only/ {print $1; exit}')

# En iyi ses formatını bul (ilk bulunan audio only)
AUDIO_CODE=$(echo "$FORMAT_LIST" | grep 'audio only' | awk '{print $1}' | head -n 1)

if [[ -n "$VIDEO_CODE" && -n "$AUDIO_CODE" ]]; then
  FINAL_QUALITY="${QUALITY}p"
  echo "✅ ${QUALITY}p video bulundu: $VIDEO_CODE"
  echo "✅ Ses formatı bulundu: $AUDIO_CODE"
else
  echo "⚠️  ${QUALITY}p bulunamadı, en yüksek kalite seçiliyor..."
  FINAL_QUALITY="best"
fi

# Dosya adı: <video_adı>_<kalite>.mp4
OUTPUT_FILE="${OUTPUT_DIR}/${SAFE_TITLE}_${FINAL_QUALITY}.mp4"
echo "💾 Kaydedilecek dosya: $OUTPUT_FILE"

# İndirme ve birleştirme
if [[ "$FINAL_QUALITY" == "best" ]]; then
  yt-dlp -f "bv*+ba/b" --merge-output-format mp4 -o "$OUTPUT_FILE" "$URL"
else
  yt-dlp -f "${VIDEO_CODE}+${AUDIO_CODE}" --merge-output-format mp4 -o "$OUTPUT_FILE" "$URL"
fi

# Sonuç
if [[ $? -eq 0 && -f "$OUTPUT_FILE" ]]; then
  echo "✅ İndirme tamamlandı: $OUTPUT_FILE"
else
  echo "❌ İndirme başarısız."
  exit 2
fi
