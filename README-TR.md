# ai-dev-foundation 🇹🇷

AI destekli geliştirme süreçleri için **yeniden kullanılabilir altyapı paketi**.

Bu repo bir ürün değildir — her yeni projeye aynı standartları taşıyan bir **geliştirme altyapısıdır**.

---

## Ne İşe Yarar?

| Modül | Açıklama |
|---|---|
| **Decision Gate** | AI kod yazmadan önce plan sunar, risk analizi yapar ve **insan onayı bekler**. Kafasına göre kod yazmaz. |
| **Dev Memory** | Geliştirme kararlarını veritabanında saklar. Chat sıfırlansa bile **"bu kodu neden böyle yazdık?"** sorusuna cevap verir. |
| **State Protocol** | Aynı anda yapılan değişikliklerde **çakışma algılar**, veri sessizce kaybolmaz. Versiyon takibi (`rev`) yapar. |
| **AI Kuralları** | AI davranış kuralları repo içinde yaşar — sohbet geçmişine bağımlı değildir. Oturum sıfırlansa bile kurallar geçerlidir. |
| **Auto Task Binding** | AI her zaman aktif bir görev bağlamında çalışır — tüm değişiklikler izlenebilir. |

---

## Repo Yapısı

```
ai-dev-foundation/
├── README.md                          # İngilizce açıklama
├── README-TR.md                       # Türkçe açıklama (bu dosya)
├── .gitignore
└── foundation/
    ├── foundation.config.json         # Merkezi yapılandırma ve özellik bayrakları
    ├── rules/
    │   ├── RULES.md                   # Kural yönlendirici dosya
    │   └── .gemini/
    │       └── RULES.md               # AI davranış kurallarının TEK kaynağı
    ├── scripts/
    │   └── init.sh                    # Tek komutla kurulum scripti
    ├── templates/
    │   ├── dev-memory-backend/        # Dev Memory şablonu (SQL + API kontratı)
    │   └── state-protocol/            # State Protocol şablonu (primitifler + kontrat)
    └── patches/
```

---

## Nasıl Kullanılır?

Yeni bir proje başlattığında:

```bash
mkdir yeni-proje && cd yeni-proje && git init
/path/to/ai-dev-foundation/foundation/scripts/init.sh
```

Bu tek komutla:
- ✅ AI kuralları projeye yerleşir (Decision Gate aktif)
- ✅ Dev Memory şablonu hazır olur
- ✅ State Protocol dokümantasyonu eklenir
- ✅ Her şey otomatik olarak git'e commit edilir

> **Not:** Zaten var olan dosyalar üzerine yazılmaz — script güvenli ve tekrarlanabilir (idempotent) çalışır.

---

## Temel Kurallar

1. **Sohbet hafızasına güvenilmez.** Kritik davranışlar repo içindeki kurallara bağlıdır.
2. **Onaysız kod yazılmaz.** AI her zaman önce plan sunar, onay bekler.
3. **Dev Memory asla iş mantığını engellemez.** Yazma hatası olursa sessizce atlanır.
4. **State Protocol çakışmaları açığa çıkarır.** "Son yazan kazanır" yaklaşımı yoktur.

---

## Lisans

Özel — yalnızca dahili kullanım.
