# ai-dev-foundation 🇹🇷

AI destekli geliştirme süreçleri için **yeniden kullanılabilir altyapı paketi**.

> *Bu altyapı AI'ı daha akıllı yapmaz. Yazılım geliştirmeyi daha güvenli yapar.*

**Sürüm:** v1.0.0 · **Durum:** Kararlı altyapı

---

## Ne İşe Yarar?

`ai-dev-foundation` AI destekli geliştirmeyi **güvenli, izlenebilir ve tekrarlanabilir** kılan opinionated bir altyapı katmanıdır.

Framework değildir. Kütüphane değildir. Herhangi bir projeye uygulayabileceğiniz **kurallar, protokoller ve şemalar** setidir.

## Hangi Problemi Çözer?

| Problem | Nasıl Çözer |
|---|---|
| AI geçmiş kararları unutur | **Dev Memory** geliştirme bağlamını veritabanında saklar |
| AI izinsiz kod yazar | **Decision Gate** her mutasyondan önce insan onayı gerektirir |
| AI sessizce state'i ezmeye çalışır | **State Protocol** revizyon takibi ve çakışma algılama uygular |
| AI çalışan kodu siler | **Code Preservation** invariant — onaysız mevcut kodu silme |
| Kurallar sadece sohbette kalır | **Repo kuralları** oturum sıfırlamalarını, katkıcı değişikliklerini ve AI değişikliklerini aşar |
| AI olmayan dosya yolları uydurur | **Hallucination Guard** kanıt (grep/search) veya etiketli varsayım gerektirir |
| Mutasyonlar takip edilemez | Her değişiklik bağlamıyla loglanır — kim, ne, neden |

---

## Temel Kavramlar

### Decision Gate (Karar Kapısı)

AI kod yazmadan önce — sırasıyla — şunları sunmalıdır:

1. Görev Özeti
2. Kapsam Kararı (frontend / backend / fullstack)
3. Etki Alanı (dosyalar, DB, entegrasyonlar, geri alma planı)
4. Kaynak Doğruluk Kontrolü
5. Test ve Doğrulama
6. Gizli Bilgi ve Güvenlik
7. Güvenli Varsayılanlar
8. Kanıt / Varsayımlar
9. Onay Talebi

Hiçbir adım atlanamaz. AI, insan onayı verene kadar bekler.

### Dev Memory (Geliştirici Hafızası)

Veritabanı destekli sistem:

- Hangi geliştirme görevleri yapıldı
- Hangi AI etkileşimleri gerçekleşti (prompt ve yanıtlar)
- Hangi değişiklikler neden yapıldı

**Çalıştırılabilir Fastify sunucu** (`--with-server`) ve **Antigravity entegrasyonu** (`--antigravity`) ile otomatik prompt/yanıt loglama dahil.

### State Protocol (Durum Protokolü)

Framework-bağımsız güvenli state mutation standardı:

- **İdempotanslık** `requestId` ile — tekrar denemeler güvenlidir
- **Revizyon takibi** `rev` ile — her mutasyon versiyonu artırır
- **İyimser eşzamanlılık** `expectedRev` ile — eski yazımlar reddedilir

### Code Preservation (Kod Koruma)

AI, açıkça onaylanmadıkça mevcut çalışan kodu asla silmemeli, yeniden adlandırmamalı veya refactor yapmamalıdır. İki seviyede uygulanır:
- **Dosya tabanlı:** `RULES.md` Bölüm F
- **Veritabanı destekli:** `foundation_invariants` tablosu — kurallar yüklenmese bile hayatta kalır

### Safety Hardening v1 (Güvenlik Sertleştirme)

Her implementasyona eklenen altı zorunlu güvenlik kontrolü:

| Kural | Neyi Önler |
|---|---|
| **Etki Alanı Analizi** | Kontrolsüz değişiklikler — high-impact: >5 dosya, DB migration, kritik modül veya API kontrat değişikliği |
| **Kaynak Doğruluk** | UI'ın paylaşılan state'i backend persistence olmadan yönetmesi |
| **Minimum Test Çıtası** | Sıfır doğrulama ile değişiklik gönderme |
| **Gizli Bilgi Hijyeni** | Token commit etme, key loglama, dev endpoint'leri açığa çıkarma |
| **Güvenli Varsayılanlar** | Yeni özelliklerle mevcut davranışı bozma |
| **Halüsinasyon Koruması** | AI'ın var olmayan dosya yolları, route'lar veya kolonlar uydurması |

Detaylar: [docs/SAFETY.md](./docs/SAFETY.md) · Kontrol listesi: [docs/CHANGE_CHECKLIST.md](./docs/CHANGE_CHECKLIST.md)

### Backlog Discipline (Backlog Disiplini)

AI tespit ettiği her iyileştirmeyi uygulamamalıdır. Tespit edilen fikirler bir **karar tamponuna** (`BACKLOG.md`) gider ve uygulama öncesi açık insan onayı gerektirir.

---

## Hızlı Başlangıç

### 1. Foundation'ı klonla

```bash
git clone https://github.com/dgozeten/ai-dev-foundation.git
```

### 2. Projenize uygulayın

**Projenizin kök dizininden** (git repo olmalı):

```bash
bash /path/to/ai-dev-foundation/foundation/scripts/init.sh
```

Sadece kuralları ve dokümantasyonu kopyalar. Veritabanı yok, sunucu yok, bağımlılık yok.

### 3. Seviyenizi seçin

| Komut | Ne Yapar |
|---|---|
| `init.sh` | Sadece kurallar + dokümantasyon |
| `init.sh --with-db` | + Migration SQL dosyalarını kopyala (çalıştırmadan önce inceleyin) |
| `init.sh --with-db --run` | + Migration'ları hemen çalıştır (`$DATABASE_URL` + `psql` gerekli) |
| `init.sh --with-server --with-db` | + Çalıştırılabilir Dev Memory API sunucusu + migration'lar |
| `init.sh --with-server --with-db --antigravity` | **Tam kurulum**: sunucu + DB + otomatik prompt loglama |

### 4. Tam kurulum (sıfırdan çalışır hale)

Her şeyi istiyorsanız — Dev Memory API, veritabanı şeması ve Antigravity entegrasyonu:

```bash
# Tüm seçeneklerle foundation'ı uygula
bash /path/to/ai-dev-foundation/foundation/scripts/init.sh \
  --with-server --with-db --antigravity

# Dev Memory sunucusunu başlat
cd dev-memory-server
npm install
cp .env.example .env          # DATABASE_URL'yi düzenleyin
npm run migrate               # tabloları oluştur
npm start                     # API localhost:3100'de çalışır

# Antigravity'nin etkileşimleri loglaması için URL'yi ayarla
export DEV_MEMORY_URL=http://localhost:3100
```

Bundan sonra:
- ✅ AI kuralları uygulanıyor (Decision Gate aktif)
- ✅ Dev Memory API çalışıyor ve logları kabul ediyor
- ✅ Antigravity otomatik olarak prompt ve yanıtları logluyor
- ✅ Tüm geliştirme kararları PostgreSQL'de saklanıyor

---

## Ne Zaman KULLANILMAMALI

Bu altyapı ek yük getirir ve şunlar için haklı çıkarılamaz:

- **Tek kullanımlık scriptler** — kod bir gün yaşayacaksa izlenebilirlik gereksizdir
- **Bir günlük proof of concept'ler** — karar kapıları keşfi tasarım gereği yavaşlatır
- **Kalıcılığı olmayan projeler** — Dev Memory ve State Protocol bir veritabanı varsayar
- **Sadece UI demoları** — bu backend altyapısıdır
- **Devamlılığı olmayan solo denemeler** — projeye bir daha dönmeyecekseniz hatırlanacak bir şey yoktur

Proje **önemli** olduğunda kullanın.

---

## Proje Yapısı

```
ai-dev-foundation/
├── README.md
├── README-TR.md
├── LICENSE
├── docs/
│   ├── OVERVIEW.md                            # Zihinsel model + akış diyagramı
│   ├── SAFETY.md                              # Safety Hardening v1 kuralları
│   └── CHANGE_CHECKLIST.md                    # Zorunlu implementasyon kontrol listesi
└── foundation/
    ├── foundation.config.json
    ├── rules/
    │   ├── RULES.md                           # Yönlendirici dosya
    │   └── .gemini/
    │       └── RULES.md                       # Kaynak doğruluk (A-H bölümleri)
    ├── scripts/
    │   ├── init.sh                            # Tek komutla kurulum
    │   └── log-interaction.sh                 # Fire-and-forget Dev Memory logger
    ├── templates/
    │   ├── BACKLOG.md                         # Karar tamponu şablonu
    │   ├── IMPLEMENTATION_CHECKLIST.md        # Yeniden kullanılabilir kontrol listesi
    │   ├── dev-memory-backend/                # Şema + API kontratı + loglama rehberi
    │   ├── dev-memory-server/                 # Çalıştırılabilir Fastify + pg sunucu
    │   ├── state-protocol/                    # Primitifler + desenler
    │   ├── full-bootstrap/                    # Opt-in DB migration'lar + invariant'lar
    │   └── integrations/antigravity/          # Antigravity workflow + kurallar
    └── patches/
```

---

## Lisans

MIT Lisansı — detaylar için [LICENSE](./LICENSE) dosyasına bakın.
