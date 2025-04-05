# YouTube Video Downloader (yt-dlp + FFmpeg)

Bu komut satırı aracı, YouTube videolarını **en yüksek kalitede** ve **video başlığıyla birlikte** `.mp4` formatında indirmenizi sağlar.

- Varsayılan olarak `720p` kalitesinde indirme yapar.
- Eğer `720p` bulunamazsa, mevcut olan en yüksek kaliteyi indirir.
- FFmpeg kullanılarak video ve ses parçaları birleştirilir.
- Çıktı dosyasının ismi: `<video_başlığı>_<kalite>.mp4` şeklindedir.

---

## 📦 Gereksinimler

- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- [FFmpeg](https://ffmpeg.org/)

Kurulum (Ubuntu/Debian):

```bash
sudo apt install ffmpeg
pip install -U yt-dlp
