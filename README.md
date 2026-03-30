# Crecki

## Ringkasan Eksekutif

### Masalah

Pasca terjadinya bencana alam seperti gempa bumi atau pergerakan tanah, masyarakat seringkali dilanda kepanikan dan kebigungan dalam menilai apakah rumah atau bangunan yang mereka tempat maish aman atau berisiko roboh. Menunggu tim ahli datang untuk memeriksa struktur bangunan tentu memakan waktu yang lama, sementara keputusan untuk mengungsi atau bertahan harus diambil secara cepat demi keselamatan nyawa.

### Solusi

**Crecki** hadir sebagai aplikasi kesiapsiagaan bencana yang memanfaatkan teknologi *Computer Vision* untuk membantu masyarakat melakukan skrining mandiri terhadap tingkat kerusakan dinding bangunan. Dengan memanfaatkan rendering engine Flutter yang berkinerja tinggi serta kecerdasan buatan (AI) yang berjalan secara lokal (*on-device*), aplikasi ini menyediakan:

* **Analisis Kerusakan Instan:** Memberikan penilaian cepat terhadap kondisi retakan bangunan hanya melalui kamera *smartphone*.
* **Operasional Tanpa Sinyal (100% Offline):** aplikasi mampu berfungsi saat infrastruktur jaringan terputus akibat bencana alam.
* **Panduan Mitigasi Mandiri:** Memberikan rekomendasi tindakan berdasarkan tingkat keparahan yang terdeteksi untuk  meminimalisir korban jiwa.

---

## 📸 Tangkapan Layar Aplikasi
Berikut adalah dokumentasi antarmuka aplikasi Crecki: 

| Halaman Utama | Halaman Utama ketika terdapat gambar |
| --- | --- |
| ![halaman utama](screenshots/screenshot_halaman_utama.jpg) | ![halaman utama](screenshots/screenshot_halaman_utama_2.jpg) |

### Hasil Prediksi AI
| Hasil Prediksi Aman | Hasil Prediksi Peringatan | Hasil Prediksi Bahaya |
| --- | --- | --- |
| ![halaman utama](screenshots/screenshot_prediksi_aman.jpg) | ![halaman utama](screenshots/screenshot_prediksi_peringatan.jpg) | ![halaman utama](screenshots/screenshot_prediksi_bahaya.jpg) |

---

## Fitur Utama
* **Model AI MobileNetV2 (On-Device):** menggunakan arsitektur MobileNetV2 yang sangat ringan dan cepat. Model ini dilatih khusus untuk mengklasifikasikan 3 tingkat kerusakan fisik bangunan: **Tanpa Retakan (Aman)**, **Retakan Ringan**, dan **Retakan Bercabang(Bahaya)**.
* **Performa Kilat (< 1 detik):** Proses inferensi gambar dan prediksi kondisi infrastruktur berlangsung secara instan untuk mendukung pengambilan keputusan darurat yang cepat.
* **Akses Offline:** Tidak memerlukan koneksi internet ataupun API eksternal. Semua pemrosesan gambar dilakukan langsung di dalam memori ponsel pengguna. 
---

## 🛠 Tech Stack (Teknologi)

* **Frontend:** Flutter (Dart)
* **State Management:** BLoC – *Dipilih karena transisi state yang dapat diprediksi dan kemudahan dalam pengujian.*
* **Machine Learning:** TensorFlow Lite (FTLite) - *Untuk menjalankan model MobileNetV2 secara offline pada perangkat mobile.*

---

## 🏗 Arsitektur Sistem & Alur Data

Proyek ini mengikuti prinsip **Clean Architecture** untuk memastikan basis kode dapat ditingkatkan (*scalable*), mudah diuji (*testable*), dan tidak bergantung pada *framework* eksternal.

### Struktur Folder

* `models/`: Representasi objek data dan parsing JSON.
* `blocs/`: Pengelola *state*.
* `pages/`: Antarmuka pengguna utama.
* `services/`: Komunikasi API dan layanan eksternal.
* `core/`: Fungsi pembantu, konstanta, dan tema.
* `widgets/`: Komponen UI yang dapat digunakan kembali.

### Struktur Folder (Clean Architecture)

Proyek ini menerapkan **Clean Architecture** dengan memisahkan kode ke dalam 3 lapisan utama (*Data*, *Domain*, dan *Presentation*) untuk memastikan kode mudah diuji (*testable*) dan memiliki ketergantungan yang rendah (*low coupling*).

* **core/**: Menyimpan fungsi pembantu (*utils*), konstanta, tema aplikasi, dan konfigurasi global yang digunakan di seluruh fitur.

* **1. domain/** (Inti Logika Bisnis - Pure Dart)
    * `entities/`: Objek data inti yang digunakan oleh aplikasi.
    * `repositories/`: Kontrak antarmuka (*abstract class*) untuk komunikasi data.
    * `usecases/`: Logika bisnis spesifik untuk setiap aksi pengguna (misal: *GetPrediction*).

* **2. 💽 data/** (Sumber Data & Infrastruktur)
    * `models/`: Perluasan dari *entities* dengan kemampuan parsing JSON (dari API atau TFLite).
    * `repositories/`: Implementasi nyata dari *repositories* yang ada di layer domain.
    * `datasources/`: Sumber data mentah, baik itu *remote* (Supabase API) maupun *local* (Hive DB / TFLite Model).

* **3. 📱 presentation/** (Antarmuka & Manajemen State)
    * `blocs/`: Pengelola *state* menggunakan BLoC (Event, State, dan Bloc) untuk menjembatani UI dan Use Case.
    * `pages/`: Halaman antarmuka pengguna utama.
    * `widgets/`: Komponen UI kecil yang dapat digunakan kembali khusus untuk fitur tersebut.

---

## 🧠 Keputusan Teknis & Trade-offs

### Mengapa BLoC?

Saya memilih **BLoC** sebagai solusi *state management* utama dalam aplikasi ini dibandingkan Riverpod atau Provider standar. Keputusan ini didasarkan pada beberapa alasan krusial:
1. **Pemisahan Logika yang Ketat:** BLoC memaksa pemisahan yang jelas antara antarmuka pengguna (UI) dan logika bisnis. Hal ini sangat penting untuk menjaga kode tetap bersih (*clean code*) dan mudah diuji (*testable*).
2. **Aliran Data Berbasis Event (Sreams):** Menggunakan pendekatan berbasis *event-driven*, membuat perubahan status (*state*) menjadi sangat mudah diprediksi. Dalam aplikasi darurat bencana seperti ini, kepastian transisi status aplikasi (seperti: *Loading*, *Success*, *Failure*) sangat penting untuk menghindari *crash*.
3. **Skalabilitas Tinggi:** Sangat cocok dipadukan dengan *Clean Architecture* yang diterapkan pada proyek ini, memudahkan pengembangan fitur baru di masa mendatang tanpa merusak fitur yang sudah ada.

### Mengapa MobileNetV2?

Untuk bagian *Computer Vision*, saya memilih arsitektur **MobileNetV2** sebagai otak pemrosesan gambar karena beberapa keunggulan teknis berikut:
1. **Sangat Ringan & Efisien:** Dirancang khusus untuk perangkat mobile dengan keterbatasan sumber daya (CPU dan RAM). Ukuran model yang kecil memastikan aplikasi tidak membebani kapasitas penyimpanan ponsel pengguna.
2. **Performa Kecepatan Tinggi:** MobileNetV2 menggunakan *Inverted Residuals* dan *Linear Bottlenecks* yang memungkinkannya melakukan klasifikasi gambar dengan sangat cepat (kurang dari 1 detik) tanpa membutuhkan GPU tingkat tinggi.
3. **Optimal untuk On-Device AI:** Sangat andal ketika dikonversi ke format `.tflite` (TensorFlow Lite), mendukung penuh kebutuhan aplikasi ini untuk dapat menganalisis retakan bangunan secara offline total saat terjadi bencana.
---

## ⚙️ Persiapan & Instalasi

Ikuti langkah-langkah berikut untuk menjalankan proyek secara lokal:

1. **Prasyarat:** - Flutter SDK sudah terinstal (`flutter doctor` harus menunjukkan status hijau).

2. **Klon repositori:**
   ```bash
   git clone [https://github.com/usernameanda/crecki-disaster-app.git](https://github.com/usernameanda/crecki-disaster-app.git)
   cd crecki-disaster-app



3. **Instal dependensi:**
    ```bash
    flutter pub get

    ```


4. **Jalankan aplikasi:**
    ```bash
    flutter run
    ```