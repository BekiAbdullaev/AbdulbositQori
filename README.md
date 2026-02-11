# Abdulbosit Qori

Islomiy iOS ilovasi — namoz vaqtlari, qibla yo'nalishi, Qur'on o'rganish, namoz qoidalari, tasbeh va bildirishnomalar tizimi.

## 📱 Asosiy Imkoniyatlar

- **Namoz Vaqtlari** — joriy joylashuvga asoslangan kunlik namoz vaqtlari, countdown timer bilan
- **Qibla Kompasi** — qurilma sensorlari yordamida qibla yo'nalishini ko'rsatish
- **Qur'on O'rganish** — audio darslar bilan Qur'on o'rganish
- **Namoz Qoidalari** — erkaklar va ayollar uchun batafsil namoz o'qish tartibi
- **Tasbeh** — raqamli tasbeh hisoblagich
- **Bildirishnomalar** — har bir namoz vaqti uchun sozlangan ogohlantirish (azon / vibratsiya / ovozsiz)

## 🛠️ Texnologiyalar

| Texnologiya | Maqsad |
|---|---|
| **Swift** | Asosiy dasturlash tili |
| **UIKit** | UI framework |
| **CoreLocation** | Joylashuv va qibla uchun |
| **UserNotifications** | Namoz vaqti bildirishnomalari |
| **BackgroundTasks** | Fon vazifalarini boshqarish |
| **CoreData** | Mahalliy ma'lumotlarni saqlash |
| **Firebase** | Bulutli xizmatlar |
| **AVFoundation** | Audio ijro etish |

## 📦 SPM Dependencies (MyLibrary)

- **Moya** — Tarmoq so'rovlari
- **MBProgressHUD** — Yuklash ko'rsatkichi
- **R.swift** — Resurslarni tip-safe ishlatish
- **SnapKit** — Programmatik Auto Layout
- **IQKeyboardManager** — Klaviatura boshqaruvi
- **Kingfisher** — Rasm yuklash va keshlash
- **Lottie** — Animatsiyalar

## 🏗️ Arxitektura

MVC + Coordinator pattern:

```
Abdulbosit Qori/
├── Main/                    # AppDelegate, Coordinator, CheckUpdate
├── Scenes/
│   ├── Main/                # Bosh ekran
│   ├── PrayerTime/          # Namoz vaqtlari + Notification Manager
│   ├── Qibla/               # Qibla kompasi
│   ├── QuranStudy/          # Qur'on o'rganish
│   ├── QuranBribes/         # Qur'on sahifalari
│   ├── PrayerRules/         # Namoz qoidalari
│   └── Rosary/              # Tasbeh
├── Shared/
│   ├── Common/              # Constants, PrayerTimeHelper
│   ├── View/                # Umumiy UI komponentlari
│   └── Model/               # MainBean, DataManager
└── MyLibrary/               # SPM paket (dependencies)
```

## ⚙️ O'rnatish

1. Loyihani clone qiling:
   ```bash
   git clone https://github.com/BekiAbdullaev/AbdulbositQori.git
   ```
2. Xcode'da `Abdulbosit Qori.xcodeproj` faylini oching
3. SPM dependencies avtomatik yuklanadi
4. Simulatorda yoki qurilmada ishga tushiring

## 📋 Talablar

- iOS 13.0+
- Xcode 14.0+
- Swift 5.7+

## 👨‍💻 Muallif

Bekzod Abdullaev — [@BekiAbdullaev](https://github.com/BekiAbdullaev)