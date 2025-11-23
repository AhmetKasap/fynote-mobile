# Fynote Mobile

AI destekli modern not uygulaması - Flutter mobil uygulaması

## 🏗️ Mimari

Bu proje **Clean Architecture** ve **MVVM** prensiplerine göre tasarlanmıştır.

### Katmanlar

```
lib/
├── core/                    # Temel yapı taşları
│   ├── constants/          # Sabitler (API endpoints, app constants)
│   ├── theme/              # Tema yapılandırması
│   ├── network/            # Dio client ve interceptor'lar
│   ├── error/              # Hata yönetimi (failures, exceptions)
│   └── utils/              # Yardımcı fonksiyonlar ve extension'lar
├── data/                    # Veri katmanı
│   ├── models/             # JSON models (freezed ile)
│   ├── datasources/        # Remote ve Local data source'lar
│   └── repositories/       # Repository implementasyonları
├── domain/                  # İş mantığı katmanı
│   ├── entities/           # Domain entity'leri
│   ├── repositories/       # Repository interface'leri
│   └── usecases/           # Use case'ler
└── presentation/            # Sunum katmanı
    ├── providers/          # Riverpod provider'ları (state management)
    ├── router/             # Go Router yapılandırması
    ├── screens/            # Ekranlar
    └── widgets/            # Ortak widget'lar
```

## 🛠️ Teknolojiler

### State Management
- **Riverpod** - Modern ve güçlü state management
- **Hooks Riverpod** - Reactive programming desteği

### Network
- **Dio** - HTTP client
- **Flutter Secure Storage** - Token ve hassas veri depolama

### Code Generation
- **Freezed** - Immutable model'ler
- **JSON Serializable** - JSON parsing

### Navigation
- **Go Router** - Declarative routing

### UI
- **Google Fonts** - Modern tipografi
- **Material 3** - Modern UI tasarımı

### Utilities
- **Dartz** - Functional programming (Either, Option)
- **Equatable** - Value equality

## 🚀 Kurulum

1. Gerekli paketleri yükleyin:
```bash
flutter pub get
```

2. Freezed kod üretimi yapın:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Backend URL'ini güncelleyin:
`lib/core/constants/api_constants.dart` dosyasında `baseUrl`'i kendi backend URL'inize göre güncelleyin.

4. Uygulamayı çalıştırın:
```bash
flutter run
```

## 📱 Özellikler

### ✅ Tamamlanan Modüller

#### Authentication
- ✅ Kullanıcı kayıt
- ✅ Giriş yapma
- ✅ Email doğrulama
- ✅ Şifremi unuttum
- ✅ Şifre sıfırlama
- ✅ Çıkış yapma
- ✅ Token yönetimi (secure storage)

#### User Profile
- ✅ Profil görüntüleme
- ✅ Profil düzenleme (ad, soyad)
- ✅ Şifre değiştirme

### 🚧 Geliştirme Aşamasında
- 📝 Not oluşturma, düzenleme, silme
- 📁 Klasör yönetimi
- 🤖 AI destekli özellikler
- 🔍 Not arama
- 🏷️ Etiketleme

## 🎨 Tasarım

- Modern ve temiz arayüz
- Material 3 design system
- Light ve Dark tema desteği
- Responsive tasarım
- Smooth animasyonlar

## 📡 API Entegrasyonu

Backend API endpoint'leri:

### Auth Endpoints
```
POST /api/v1/auth/register
POST /api/v1/auth/login
POST /api/v1/auth/verify-email
POST /api/v1/auth/resend-verification-email
```

### User Profile Endpoints
```
GET  /api/v1/user-profile/
PUT  /api/v1/user-profile/
POST /api/v1/user-profile/forgot-password
POST /api/v1/user-profile/reset-password
```

## 🧪 Test

```bash
# Analiz
flutter analyze

# Test çalıştır
flutter test
```

## 📄 Lisans

Bu proje özel bir projedir.

## 👨‍💻 Geliştirici

Ahmet

