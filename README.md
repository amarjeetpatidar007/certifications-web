# 🏆 Certification Tracker Web App

## Overview
A professional web application to track, manage, and showcase your certifications seamlessly.

## 🚀 Project Features
- Centralized certification management
- Unique shareable profile URLs
- Firebase authentication
- Responsive web design
- Easy certification addition and editing

## 📦 Dependencies

### Core Flutter
```yaml
flutter:
  sdk: flutter
```

### Authentication & Backend
- `firebase_auth`: User authentication
- `google_sign_in`: Google login integration
- `cloud_firestore`: Database for storing certifications
- `firebase_app_check`: Security for Firebase

### Navigation & State Management
- `go_router`: Advanced routing
- `provider`: State management

### Utilities
- `cupertino_icons`: iOS-style icons
- `url_launcher`: Open external links
- `firebase_analytics`: Track user interactions

## 🔧 Setup Instructions

### 1. Prerequisites
- Flutter SDK
- Firebase project
- Google Cloud Console project

### 2. Firebase Configuration
1. Create a Firebase project
2. Enable Authentication (Google Sign-In)
3. Set up Firestore database
4. Generate `firebase_options.dart`

```bash
flutterfire configure
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Run the Application
```bash
flutter run -d chrome
```

## 🌟 Key Screens
- Login/Authentication
- Dashboard
- Certification Detail
- Profile Editor
- Shareable Public Profile

## 📦 Data Model
```dart
class Certification {
  final String id;
  final String title;
  final String issuingOrganization;
  final DateTime obtainedDate;
  final String? verificationUrl;
  final String? certificateImageUrl;
}
```

## 🔒 Security Features
- Firebase Authentication
- Google Sign-In
- App Check
- Secure URL generation
- Role-based access control

## 🚀 Deployment
- Web: Firebase Hosting
- Continuous Integration/Deployment (GitHub Actions)

## 📱 Responsive Design
- Adaptive layouts
- Mobile and desktop-friendly
- Tailored UI for different screen sizes

## 📊 Performance Monitoring
- Firebase Analytics
- Performance tracking
- User interaction insights

## 🤝 Contributing
1. Fork the repository
2. Create your feature branch
3. Commit changes
4. Push to the branch
5. Create a pull request

## 📄 License
MIT License

## 🔗 Connect
[LinkedIn](https://www.linkedin.com/in/amarjeet-patidar-688b6a141/)  
[Portfolio](https://amarjeetpatidar.web.app/)


## 🚀 Future Roadmap
- [ ] PDF Certificate Upload
- [ ] Advanced Sharing Options
- [ ] Dark Mode Support
- [ ] Import Certifications from LinkedIn
