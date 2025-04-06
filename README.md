# 📥 YouTube Video Downloader Scripts

Bu repo, `yt-dlp` ve `ffmpeg` kullanarak YouTube videolarını indirmenizi sağlar.  
İki ayrı script mevcuttur:

- `yt-downloader.sh`: Tek video indirimi için.
- `multi-downloader.sh`: JSON dosyasından çoklu video indirimi için.

---

## 🛠 Gereksinimler

- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- ffmpeg
- jq (multi-downloader için)

### Kurulum (Ubuntu / Debian):

```bash
sudo apt install ffmpeg jq
pip install yt-dlp
```

---

## 🧪 1. yt-downloader.sh

Belirli bir videoyu indirmek ve gerekirse başlangıç / bitiş zamanlarıyla kesmek için.

### ✅ Kullanım:

```bash
./yt-downloader.sh "URL" "Kalite" "00:00:10" "00:00:30"
```

- `URL`: Video bağlantısı
- `Kalite`: `best`, `720p`, `audio` gibi yt-dlp format kodları
- `Start Time`: (Opsiyonel) Kesmek için başlangıç zamanı
- `End Time`: (Opsiyonel) Kesmek için bitiş zamanı

### 🧾 Örnek:

```bash
./yt-downloader.sh "https://youtu.be/abc123" "best" "00:01:00" "00:02:30"
```

---

## 📄 2. multi-downloader.sh

Bir JSON dosyasından birden fazla video indirir.

### ✅ JSON Formatı:

```json
[
  {
    "url": "https://youtu.be/abc123",
    "quality": "best",
    "start": "00:00:10",
    "end": "00:00:30"
  },
  {
    "url": "https://youtu.be/def456",
    "quality": "audio"
  }
]
```

- `start` ve `end` alanları opsiyoneldir.

### ✅ Kullanım:

```bash
./multi-downloader.sh videos.json
```

---

## 📂 Çıktılar

- İndirilen videolar script ile aynı dizine kaydedilir.
- Eğer kesme işlemi varsa, çıktı dosya adı sonuna `_trimmed` eklenir.

---

## 🧼 Temizlik

Geçici dosyalar işlem sonrası otomatik silinir.

---

Her iki script de deneysel amaçlıdır. Daha fazla özelleştirme yapılabilir.
