# YouTube Video Downloader (yt-dlp + FFmpeg)

Bu komut satırı aracı, YouTube videolarını **yüksek kalitede**, **video başlığıyla isimlendirilmiş** şekilde `.mp4` formatında indirmenizi sağlar.  
Ayrıca isterseniz videonun **belirli bir zaman aralığını** keserek sadece o bölümü indirebilirsiniz.

---

## 🧠 Özellikler

- Varsayılan kalite: `720p`
- Belirtilen kalite yoksa en yüksek kalite kullanılır
- Video + ses parçaları FFmpeg ile birleştirilir
- Dosya ismi otomatik olarak video başlığından oluşturulur
- **İsteğe bağlı** olarak başlangıç ve bitiş zamanı belirtilerek video kırpılabilir
- Kesilen veya tam video `.mp4` olarak `downloads/` klasörüne kaydedilir

---

## 📦 Gereksinimler

- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- [FFmpeg](https://ffmpeg.org/)

### ✅ Kurulum (Ubuntu/Debian)

```bash
sudo apt install ffmpeg
pip install -U yt-dlp
