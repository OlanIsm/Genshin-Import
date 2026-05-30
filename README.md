# Genshin Import - Weapon & Artifact Shop
<img width="620" height="426" alt="image" src="https://github.com/user-attachments/assets/19af9595-ed89-4e91-929b-1d69c35687c9" />

Genshin Import is a catalog and e-commerce application built with Flutter (Frontend), Node.js/Express (Backend), and MySQL (Database) designed to simulate a Weapon and Artifact shop from the game Genshin Impact.

---
<img width="402" height="855" alt="image" src="https://github.com/user-attachments/assets/05c0df5f-6c26-4ebe-bb3b-c80395ae7ac2" />

## Key Features
1. **Weapon & Artifact Catalog**: Displays a list of weapons based on category (Sword, Claymore, Polearm, Catalyst, Bow) and a complete list of Artifacts.
2. **Shopping Cart System**: Users can add weapons and artifacts to the shopping cart, update quantities, and calculate the total price in real time.
3. **Checkout & Stock Reduction**: When users check out, the weapon stock in the database is automatically reduced.
4. **Dual Authentication**:
   - **Manual Login & Registration**: Using email and encrypted password.
   - **Google OAuth Login**: Third-party integration using Google Sign-In, which automatically synchronizes with the backend database.
5. **Admin Dashboard (Protected)**: A dedicated administrator panel for CRUD (Create, Read, Update, Delete) operations on weapons and simple analytics. This page is strictly protected on both the frontend and backend.

---

## Project Folder Structure

```text
Genshin-Import/
├── backend/                  # Node.js / Express API Server
│   ├── db.js                 # MySQL Database Connection Configuration
│   ├── server.js             # API Server Entry Point & HTTP Routes
│   └── package.json          # Backend Dependencies
│
├── database/                 # Database Schema
│   └── genshin_import.sql    # SQL dump file for phpMyAdmin / MySQL
│
└── frontend/                 # Flutter Application (Client)
    ├── lib/
    │   ├── core/
    │   │   ├── constants/    # Global Colors & Text Styles (Genshin Theme)
    │   │   ├── models/       # JSON Object Mapping (Weapon, Artifact, CartItem, User)
    │   │   ├── providers/    # State Management (AuthProvider, CartProvider, WeaponProvider)
    │   │   └── services/     # API Service (ApiService)
    │   ├── screens/          # UI Screens (Home, Cart, Admin, Profile, Auth)
    │   ├── widgets/          # Reusable UI Components (GenshinButton, WeaponCard, etc.)
    │   └── main.dart         # Flutter Application Entry Point
    └── pubspec.yaml          # Flutter Configuration & Package Dependencies
```

---

## Installation & Run Guide

### 1. Setup Database (MySQL & XAMPP)
1. Open XAMPP Control Panel and enable Apache and MySQL modules.
2. Go to the phpMyAdmin page in your browser (http://localhost/phpmyadmin).
3. Create a new database named: genshin_import.
4. Select the genshin_import database, click the Import tab, choose the database/genshin_import.sql file, and click Go / Import.

### 2. Run Backend Server (Port 3000)
1. Open Terminal or Command Prompt, then navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Install the required dependencies:
   ```bash
   npm install
   ```
3. Start the backend server:
   ```bash
   node server.js
   ```
   *The server will run on http://localhost:3000 and log connection success to the database.*

### 3. Run Frontend (Flutter)
1. Open a new Terminal, then navigate to the frontend directory:
   ```bash
   cd frontend
   ```
2. Fetch the required Flutter packages/dependencies:
   ```bash
   flutter pub get
   ```
3. **IMPORTANT: Run on Chrome Web (For Google OAuth to Work)**
   Google OAuth requires correct JavaScript Origins. Run the following command to launch the app on localhost port 6767:
   ```bash
   flutter run -d chrome --web-port 6767 --web-hostname localhost
   ```
4. **Run on Android Emulator (Android SDK)**
   If the lab assistant or examiner wants to run on an Android Emulator, simply run the standard command:
   ```bash
   flutter run
   ```
   *Note: The app dynamically detects the platform. On Chrome Web it connects to localhost:3000, while on Android Emulator it automatically connects to the host IP 10.0.2.2:3000.*

---

## Google OAuth Integration & Configuration

### Google Cloud Console Setup
To prevent errors when logging in with Google, adjust the following configurations in your Google Cloud Console project:
1. **Authorized JavaScript Origins**: http://localhost:6767
2. **Authorized Redirect URIs**: http://localhost:6767

### People API Activation (Required)
If you encounter a login error stating ClientException: [403] People API has not been used..., you must enable it with the following steps:
1. Go to this link in your browser:
   Link: https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=368893081990
2. Click the blue Enable button.
3. Wait 1–2 minutes, then try Google Login again on the application.

---

## Administrator Access Privileges (Admin Dashboard)

The Admin Dashboard page is strictly secured from external access:
- **On the Frontend**: AdminDashboardScreen checks the user's isAdmin property. If a regular user tries to access it, the screen is redirected to the "Access Denied" view.
- **On the Backend**: POST, PUT, and DELETE routes for weapons are protected by database checks where only tokens belonging to users with the 'admin' role can process these transactions.

### How to Get Admin Access for Testing:
1. Run the application, register a new account (or log in via Google).
2. Open phpMyAdmin and navigate to the users table.
3. Find the row matching the email you registered and click Edit.
4. Change the role column value from "user" to "admin", then save.
5. Perform a Hot Restart in Flutter, log back into the app, and click the Admin tab. You can now fully access the admin dashboard!

More feature and Updates coming soon!. 
