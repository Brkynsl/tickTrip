# TickTrip ✈️

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-Framework-blue.svg)](https://developer.apple.com/xcode/swiftui/)
[![Firebase](https://img.shields.io/badge/Firebase-Backend-yellow.svg)](https://firebase.google.com/)

**TickTrip** is a modern, premium travel companion app designed to simplify your journey from planning to execution. With a sleek UI and powerful features, it's the ultimate tool for the modern explorer.

![TickTrip Mockup](Media/mockup.png)

## ✨ Features

- **🗺️ Explore**: Discover your next adventure with breathtaking destinations powered by Unsplash.
- **📅 My Trip**: Manage your itineraries, tickets, and bookings in one organized place.
- **🌍 World View**: Explore the globe with an interactive and immersive interface.
- **👥 Community**: Share your travel experiences and get inspired by fellow travelers.
- **🔐 Secure Auth**: Seamless and secure authentication powered by Firebase.
- **💳 Subscriptions**: Premium features and exclusive content with a professional paywall.
- **🌐 Localization**: Fully localized in English, Turkish, German, French, and Spanish.

## 🛠️ Tech Stack

- **UI Framework**: SwiftUI (Declarative UI for modern iOS experiences)
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **Design Pattern**: MVVM (Model-View-ViewModel)
- **Image API**: Unsplash API for high-quality destination imagery
- **Localization**: LocalizedStrings for multi-language support

## 🚀 Getting Started

### Prerequisites

- Xcode 15.0+
- iOS 17.0+
- Cocoapods or Swift Package Manager (depending on your dependency preference)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Brkynsl/tickTrip.git
   cd tickTrip
   ```

2. **Setup Firebase**:
   - Create a new project in the [Firebase Console](https://console.firebase.google.com/).
   - Add an iOS app to your Firebase project.
   - Download the `GoogleService-Info.plist` and add it to the `TickTrip` folder in Xcode.

3. **Configure Unsplash**:
   - Get your API keys from the [Unsplash Developer Portal](https://unsplash.com/developers).
   - Update `Core/Utilities/UnsplashConfig.swift` with your keys:
     ```swift
     static let accessKey = "YOUR_UNSPLASH_ACCESS_KEY"
     static let secretKey = "YOUR_UNSPLASH_SECRET_KEY"
     ```

4. **Build and Run**:
   - Open `TickTrip.xcodeproj` in Xcode.
   - Select your target device and press `Cmd + R`.

## 📸 Screenshots

| Explore | My Trip | Profile |
| :---: | :---: | :---: |
| ![Explore](Media/mockup.png) | ![My Trip](Media/mockup.png) | ![Profile](Media/mockup.png) |

*(Note: Mockups used for demonstration. Real screenshots can be added here.)*

## 🌍 Localization

TickTrip supports:
- 🇺🇸 English
- 🇹🇷 Türkçe
- 🇩🇪 Deutsch
- 🇫🇷 Français
- 🇪🇸 Español

---

Developed by **[Brkynsl](https://github.com/Brkynsl)**
