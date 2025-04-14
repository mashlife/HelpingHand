# Helping Hand – For People in Trouble

![App Logo](media/image/hh-logo.png)

📥 ![**Download APK**](download_apk/)  
🛒 ![**Get it on Play Store**](https://groups.google.com/g/helpinghandbeta)


#### Everything else is AI generated based on the code
    
  "HELPING HAND" project is a little gift to our community specially in this unstable time. Anyone can be a victim, this is the bitter truth of life. Another bitter truth is we are not superheros or machine man. But together we can be more powerful, more secure. Give it a try and let me know your honest opinions and suggestions. 


A Flutter-based community support application providing real-time location-based assistance, emergency notifications, and crowd-sourced problem solving.

## Key Features

### Core Functionality
- 🚨 Real-time emergency alert system
- 📍 GPS-based location tracking
- 🔥 Firebase-powered backend services
- 📱 Cross-platform compatibility (Android/iOS)

### Technical Features
- 🗺️ Google Maps integration with Geofire
- 🔔 Push notifications (FCM) & local alerts
- 🛡️ Foreground service for continuous operation
- 📲 Overlay window interface for quick access
- 🔄 Real-time database synchronization
- 🔐 Shared Preferences for local storage
- 📊 User preference management

## Required Permissions
The app requires these Android permissions:
- `ACCESS_FINE_LOCATION` - Precise location tracking
- `ACCESS_BACKGROUND_LOCATION` - Continuous position monitoring
- `FOREGROUND_SERVICE` - Persistent notification service
- `SYSTEM_ALERT_WINDOW` - Overlay display capability
- `POST_NOTIFICATIONS` - Emergency alert delivery

## Getting Started

### Prerequisites
- Flutter SDK 3.5.2
- Android Studio/Xcode
- Google Maps API Key
- Firebase project configuration

### Installation
1. Clone the repository
2. Configure Firebase:
   ```bash
   flutterfire configure
   ```
3. Add Google Maps API key to `AndroidManifest.xml`
4. Install dependencies:
   ```bash
   flutter pub get
   ```
5. Run the application:
   ```bash
   flutter run
   ```

## Application Flow

1. **Splash Screen**  
   Initializes Firebase services and checks first-run status

2. **Main Interface**  
   - Real-time map display with user location
   - Emergency alert button
   - Crowd-sourced issue reporting
   - Location sharing controls

3. **Overlay System**  
   Persistent mini-window with:
   - Quick access to emergency features
   - Ongoing incident notifications
   - Location status monitoring

4. **Settings**  
   Manage preferences for:
   - Location sharing permissions
   - Notification preferences
   - Privacy controls
   - Overlay customization

## Firebase Configuration
The app uses these Firebase services:
- **Firebase Cloud Messaging**: Push notifications
- **Cloud Firestore**: Real-time data storage
- **Firebase Storage**: Media attachments
- **Realtime Database**: Geofire location tracking

Ensure proper configuration in:
- `firebase_options.dart`
- `AndroidManifest.xml`
- `GoogleService-Info.plist` (iOS)

## Security Considerations
- All location data encrypted in transit
- Firebase Security Rules enforced
- Regular token refresh implementation
- Permission revocation handling

## Troubleshooting
**Location Issues:**
1. Verify GPS is enabled
2. Check app permissions
3. Ensure background location access


## Contributing
1. Fork the repository
2. Create feature branch
3. Submit PR with detailed description

**Main Dependencies:**
- `firebase_core: ^3.12.1`
- `geolocator: ^13.0.2`
- `flutter_overlay_window: ^0.4.5`
- `permission_handler: ^11.4.0`
