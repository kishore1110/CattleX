# CattleX

CattleX is a cross-platform (Mobile & Web) AI-powered Flutter application designed to assist Field Level Workers and farmers with accurate cattle breed identification. By integrating state-of-the-art Generative AI (Google Gemini) and highly-trained Computer Vision models, CattleX serves as a comprehensive tool and knowledge base for modern livestock management.

## Features

- **AI Breed Scanner:** Snap a photo or choose from your gallery to instantly identify various cattle breeds using a hosted FastAPI prediction backend.
- **Gemini AI Assistant:** Ask complex questions about breed characteristics, milk yields, feeding guidelines, and livestock health—and get detailed, conversational answers powered by Google's Gemini models.
- **Rich Offline Database:** Access a robust directory of Indian cattle breeds fully offline, ensuring Field Level Workers are prepared even in low-connectivity rural settings.
- **Knowledge Quizzes:** Interactive quizzes designed to help farmers and workers rigorously test and expand their knowledge about livestock care and identification.
- **Cross-Platform:** Fluid, responsive UI built natively with Flutter, supporting seamless usage on both Web platforms and Android devices.

## Technology Stack

- **Frontend:** Flutter & Dart
- **AI Chat Service:** `google_generative_ai` (Gemini 2.5 Flash / Pro)
- **Computer Vision Backend:** Python, FastAPI, Hugging Face Spaces (Predict API)
- **Key Packages:** `http`, `image_picker`, `flutter_dotenv`, `camera`, `flutter_markdown`

## Getting Started

Follow these steps to run the application locally on your machine.

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.0.0 or higher)
- Android Studio / SDK (for Android builds)
- Visual Studio Code or your preferred IDE

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/cattlex.git
   cd cattlex/demo
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables:**
   Create a `.env` file in the project's root directory (`demo/`) and configure your API keys:
   ```env
   GEMINI_API_KEY=your_gemini_api_key_here
   CATTLE_API_URL=https://cattlex-cattle-classification-api.hf.space/predict
   ```
   *(Note: The `.env` file must be listed in your `.gitignore` to prevent credential leakage!)*

4. **Run the Application:**
   For Android Emulators or Physical Devices:
   ```bash
   flutter run -d android
   ```
   For Web (Chrome):
   ```bash
   flutter run -d chrome
   ```

## Security & Architecture Notes

- **Zero-Hardcoding:** Sensitive information, including the Generative AI keys and computer vision backend URLs, are dynamically injected at runtime via environment variables (`flutter_dotenv`).
- **Resilient Fallbacks:** The app catches `SocketExceptions` flawlessly and falls back gracefully to its offline catalog, an absolute necessity for fieldwork in disconnected rural zones.
- **Model Efficiency:** Web requests are streamed natively through byte-uploading (`image_picker` -> `XFile`), circumventing browser-imposed `dart:io` memory crashes. 

## Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Repository
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

