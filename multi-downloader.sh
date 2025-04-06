#!/bin/bash

INPUT_FILE="videos.json"
LOG_FILE="downloaded.log"
OUTPUT_DIR="downloads"

mkdir -p "$OUTPUT_DIR"
> "$LOG_FILE"

echo "📥 JSON'dan video listesi okunuyor..."
echo "----------------------------------------"

COUNT=$(jq length "$INPUT_FILE")

for ((i=0; i<COUNT; i++)); do
  URL=$(jq -r ".[$i].url" "$INPUT_FILE")
  QUALITY=$(jq -r ".[$i].quality" "$INPUT_FILE")
  START=$(jq -r ".[$i].start" "$INPUT_FILE")
  END=$(jq -r ".[$i].end" "$INPUT_FILE")

  # URL kontrolü
  if [[ -z "$URL" || ! "$URL" =~ ^https?:// ]]; then
    echo "❌ Geçersiz URL: $URL"
    continue
  fi

  [[ -z "$QUALITY" ]] && QUALITY="720"

  echo ""
  echo "🔗 Video URL: $URL"
  echo "🎯 Kalite: $QUALITY"

  if [[ -n "$START" && -n "$END" ]]; then
    echo "✂️  Kesilecek zaman: $START → $END"
    ./yt-downloader.sh "$URL" "$QUALITY" "$START" "$END"
  else
    echo "📼 Video tamamı indirilecek."
    ./yt-downloader.sh "$URL" "$QUALITY"
  fi

  LAST_FILE=$(ls -t "$OUTPUT_DIR"/*.mp4 2>/dev/null | head -n 1)
  if [[ -f "$LAST_FILE" ]]; then
    echo "$LAST_FILE" >> "$LOG_FILE"
  else
    echo "⚠️  İndirme başarısız veya dosya bulunamadı."
  fi
done

echo ""
echo "✅ Tüm işlemler tamamlandı."
echo "🧾 Log dosyası: $LOG_FILE"
