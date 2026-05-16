# Genshin Import — External Documentation

> **Project**: E-Commerce Marketplace (Flutter Frontend)
> **Theme**: Genshin Impact — Fantasy Teyvat Weapons Marketplace

---

## 1. Pages (7 total)

| # | Page | Route | Description |
|---|---|---|---|
| 1 | Splash | /splash | Animated logo, particles, auto-navigate |
| 2 | Login | /login | Email/password + OAuth + Bearer token display |
| 3 | Register | /register | 4-field form with full validation |
| 4 | Home | /home | Carousel banner, category chips, weapon grid |
| 5 | Weapon Detail | /weapon/:id | Hero image, stats, quantity, add to cart |
| 6 | Cart | /cart | Item list, qty controls, checkout modal |
| 7 | Admin Dashboard | /admin | Analytics, CRUD weapons, bar chart |
| 8 | Profile | /profile | User card, purchase history, favorites |

---

## 2. UI Components (8 types)

1. CarouselSlider — Featured weapons banner (auto-scroll)
2. BottomNavigationBar — Main navigation shell with cart badge
3. ModalBottomSheet — Admin weapon form (draggable)
4. AlertDialog — Delete confirmation, checkout success, clear cart
5. Search Bar (TextField) — Home screen with crystal icon
6. DropdownButton — Weapon type selector in admin form
7. Form + TextFormField — Login, Register, Admin with validation
8. FloatingActionButton — Admin add weapon trigger

---

## 3. UI Theme Customizations (4 properties)

| # | Property | Value |
|---|---|---|
| 1 | Font Family | Cinzel (headings) + Raleway (body) via Google Fonts |
| 2 | Font Size | H1=32sp, H2=24sp, Body=16sp, Caption=11sp |
| 3 | Font Color | Gold #D4AF37 (headings), White #F0F0F0 (body), Red #E74C3C (errors) |
| 4 | Background Color | Navy #0D0E2B -> Royal Blue #1A1F5E -> Purple #2D1B69 gradient |

---

## 4. Validations (7 rules)

| # | Field | Rule | Error Message |
|---|---|---|---|
| 1 | Email | Regex format check | Invalid email format |
| 2 | Password | Min 8 characters | Password must be at least 8 characters |
| 3 | All fields | Not empty | X cannot be empty |
| 4 | Weapon Price | Must be positive number | Price must be a positive number |
| 5 | Weapon Stock | Must be non-negative integer | Stock must be a non-negative integer |
| 6 | Confirm Password | Must match | Passwords do not match |
| 7 | Username | Min 3 characters | Username must be at least 3 characters |

---

## 5. Authentication

- Email + password login -> JWT bearer token (>=20 alphanumeric chars)
- Token stored in SharedPreferences, shown in Login snackbar + Profile screen
- OAuth: Google, Facebook, Twitter buttons -> backend /api/auth/{provider}
- All protected API calls: Authorization: Bearer <token> header

---

## 6. Backend API Contract (Node.js + Express + MySQL)

POST   /api/auth/register
POST   /api/auth/login  -> { success, token, user }
GET    /api/auth/google
GET    /api/weapons            (Bearer required)
GET    /api/weapons/:id        (Bearer required)
POST   /api/weapons            (Bearer required)
PUT    /api/weapons/:id        (Bearer required)
DELETE /api/weapons/:id        (Bearer required)
GET    /api/artifacts          (Bearer required)
GET    /api/cart               (Bearer required)
POST   /api/cart               (Bearer required)
DELETE /api/cart/:id           (Bearer required)
GET    /api/users/me           (Bearer required)

To connect: set useMock = false in lib/core/services/api_service.dart

---

## 7. MySQL Schema

Tables: users, weapons, artifacts, cart_items
CRUD operations: Create/Read/Update/Delete weapons (Admin dashboard)

---

## 8. Creativity Highlights

- Custom particle system with CustomPainter (30-50 floating particles)
- Pulsing glow animation on all CTA buttons (AnimationController)
- 7 Genshin elemental badges (Anemo=wind, Pyro=fire, Hydro=water, etc.)
- Rarity color system: 5★=bronze-gold, 4★=purple, 3★=blue
- JWT mock: 3-part alphanumeric token (header.payload.signature format)
- SliverAppBar hero image on weapon detail (cinematic scroll)
- fl_chart bar chart with element colors on admin dashboard
- Plug-and-play API: flip useMock=false -> instant backend connection
