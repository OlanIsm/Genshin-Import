# Genshin Import — Project Requirements & Compliance Checklist
> **Course:** COSC6094 Mobile Hybrid Solution — Even Semester 2025/2026  
> **Stack:** Flutter (Frontend) · Node.js + Express (Backend) · MySQL (Database)  
> **Scoring:** 100% Project

---

## Project Overview

**Genshin Import** is a Flutter mobile application that serves as an in-app store for Teyvat weapons and artifacts. The app has two user roles:

- **Admin** — can insert, update, and delete weapons
- **User** — can view weapons and buy weapons

---

## 1. Database Requirements (MySQL)

### 1.1 CRUD Operations
The application **must** perform at least one of each:

| # | Operation | Description | Status |
|---|-----------|-------------|--------|
| 1.1.1 | **CREATE** | Insert at least one record to the database (e.g., admin adds a weapon) | ☐ |
| 1.1.2 | **RETRIEVE** | Read/fetch at least one record from the database (e.g., view weapon list) | ☐ |
| 1.1.3 | **UPDATE** | Modify at least one existing record (e.g., admin edits weapon details) | ☐ |
| 1.1.4 | **DELETE** | Remove at least one record (e.g., admin deletes a weapon) | ☐ |

### 1.2 Weapon Table Structure
The weapon entity **must** include all of the following fields:

| # | Field | Type (Recommended) | Required | Status |
|---|-------|--------------------|----------|--------|
| 1.2.1 | `id` | INT / VARCHAR (Primary Key) | ✅ | ☐ |
| 1.2.2 | `name` | VARCHAR | ✅ | ☐ |
| 1.2.3 | `type` | VARCHAR / ENUM | ✅ | ☐ |
| 1.2.4 | `description` | TEXT | ✅ | ☐ |
| 1.2.5 | `stock` | INT | ✅ | ☐ |
| 1.2.6 | `image` | VARCHAR (URL/path) | ✅ | ☐ |
| 1.2.7 | `price` | DECIMAL / INT | ✅ | ☐ |

### 1.3 User Table Structure (minimum for authentication)

| # | Field | Required | Status |
|---|-------|----------|--------|
| 1.3.1 | User stored in DB | ✅ | ☐ |
| 1.3.2 | Role differentiation (admin / user) | ✅ | ☐ |

---

## 2. Frontend Requirements (Flutter)

### 2.1 UI Components
The application **must** use at least **5 kinds** of UI components:

| # | Component | Example Usage | Status |
|---|-----------|---------------|--------|
| 2.1.1 | Component 1 | e.g., `TextField` (input fields in forms) | ☐ |
| 2.1.2 | Component 2 | e.g., `ElevatedButton` / `TextButton` | ☐ |
| 2.1.3 | Component 3 | e.g., `ListView` / `GridView` (weapon list) | ☐ |
| 2.1.4 | Component 4 | e.g., `Image` / `NetworkImage` (weapon image) | ☐ |
| 2.1.5 | Component 5 | e.g., `DropdownButton`, `Card`, `AppBar`, `BottomNavigationBar`, etc. | ☐ |

> ⚠️ Must be **5 different kinds** (types), not 5 instances of the same component.

### 2.2 Pages
The application **must** have at least **5 pages**:

| # | Page | Description | Status |
|---|------|-------------|--------|
| 2.2.1 | Login Page | Login form (email/password + OAuth option) | ☐ |
| 2.2.2 | Weapon List Page (User) | Display all available weapons/artifacts | ☐ |
| 2.2.3 | Weapon Detail Page | Show full weapon detail + buy button | ☐ |
| 2.2.4 | Admin Dashboard / Weapon Management | Admin CRUD interface | ☐ |
| 2.2.5 | Add / Edit Weapon Page | Form for admin to create or update weapon | ☐ |

> ⚠️ If you split add and edit into separate pages, that counts as 2. You only need 5 minimum total — any additional pages (e.g., cart, profile, register) are a bonus.

### 2.3 Data Validations
The application **must** have at least **3 kinds** of data validations:

| # | Validation Type | Example | Triggers Error Message? | Status |
|---|-----------------|---------|------------------------|--------|
| 2.3.1 | Validation 1 | e.g., **Empty/Required field** — "Field cannot be empty" | ✅ Must show error | ☐ |
| 2.3.2 | Validation 2 | e.g., **Format validation** — invalid email format | ✅ Must show error | ☐ |
| 2.3.3 | Validation 3 | e.g., **Numeric/Range** — price must be > 0, stock must be non-negative | ✅ Must show error | ☐ |

> ⚠️ **Each failed validation MUST display a specific error message** (not a generic one). The message should describe what went wrong.

---

## 3. Backend Requirements (Node.js + Express)

### 3.1 API Endpoints
The backend **must** have at least **2 GET requests** and **1 POST/PUT/PATCH/DELETE request**:

| # | Method | Endpoint (example) | Description | Status |
|---|--------|--------------------|-------------|--------|
| 3.1.1 | `GET` | `/weapons` | Retrieve all weapons | ☐ |
| 3.1.2 | `GET` | `/weapons/:id` | Retrieve single weapon by ID | ☐ |
| 3.1.3 | `POST` \| `PUT` \| `PATCH` \| `DELETE` | e.g., `/weapons` (POST) or `/weapons/:id` (DELETE) | At least 1 write/mutate operation | ☐ |

> ✅ Recommended to have full CRUD endpoints to support the admin features: `POST /weapons`, `PUT /weapons/:id`, `DELETE /weapons/:id`

---

## 4. Authentication Requirements

### 4.1 Login with DB User

| # | Requirement | Details | Status |
|---|-------------|---------|--------|
| 4.1.1 | Login with credentials stored in DB | Email/username + password stored in MySQL; login must succeed | ☐ |

### 4.2 External OAuth Login

| # | Requirement | Details | Status |
|---|-------------|---------|--------|
| 4.2.1 | External OAuth integration | Must support Google, Facebook, Twitter, or another OAuth provider | ☐ |
| 4.2.2 | OAuth login must succeed | The OAuth flow should complete and log the user in | ☐ |

### 4.3 Bearer Token

| # | Requirement | Details | Status |
|---|-------------|---------|--------|
| 4.3.1 | Generate bearer token on login | Token must be **at least 20 characters** long | ☐ |
| 4.3.2 | Token must be alphanumeric | Only letters and numbers (e.g., `n8x7wfqtsrvxnvsm8dcz`) | ☐ |
| 4.3.3 | Bearer token verification | At least **1 API endpoint** must verify the bearer token before responding | ☐ |

> ⚠️ Common implementation: JWT or a random alphanumeric string stored in DB/session. Make sure the token is checked on at least one protected endpoint (e.g., add weapon, delete weapon).

---

## 5. UI Design Requirements (Theme)

### 5.1 Theming

| # | Requirement | Details | Status |
|---|-------------|---------|--------|
| 5.1.1 | Theme applied across the app | The app must have a consistent visual theme | ☐ |
| 5.1.2 | At least **2–4 customized properties** | Must change at least 2 of: font size, font family, font color, background color, tint, alpha, content mode, etc. | ☐ |
| 5.1.3 | Customizations are **visible** in the app | The theme changes must be clearly visible when running the app | ☐ |
| 5.1.4 | Theme noted in documentation | All customizations must be listed in the external doc | ☐ |

### 5.2 Usability

| # | Requirement | Details | Status |
|---|-------------|---------|--------|
| 5.2.1 | Sufficient color contrast | Font color and background must be readable | ☐ |
| 5.2.2 | Colors do not clash | The color palette should be harmonious | ☐ |
| 5.2.3 | Design does not hamper usability | UI must remain functional and navigable | ☐ |

---

## 6. External Documentation Requirements

| # | Requirement | Details | Status |
|---|-------------|---------|--------|
| 6.1 | External documentation file included | A `.doc` / `.docx` / PDF file bundled with submission | ☐ |
| 6.2 | Feature details explained | Describe all pages, what each feature does | ☐ |
| 6.3 | Creativity explained | Describe any extra features or design choices beyond the minimum | ☐ |
| 6.4 | All pages documented | Each page shown (screenshot or description) | ☐ |
| 6.5 | Asset reference links | Any external images, audio, or video used must have their source URL listed | ☐ |
| 6.6 | Theme customizations listed | All 2–4 theme properties documented | ☐ |
| 6.7 | Usage instructions | How to run / use the app explained | ☐ |

---

## 7. File Submission Requirements

| # | Requirement | Details | Status |
|---|-------------|---------|--------|
| 7.1 | Flutter folder project submitted | The entire Flutter project folder (DART files + asset files) | ☐ |
| 7.2 | All assets included | Images, audio, video files used in the project | ☐ |
| 7.3 | Documentation `.doc` file included | See Section 6 | ☐ |
| 7.4 | Submitted before deadline | Late submissions are not accepted or graded | ☐ |

---

## 8. Software Version Compliance

| # | Software | Required Version | Status |
|---|----------|-----------------|--------|
| 8.1 | Android SDK | API 35 | ☐ |
| 8.2 | Android Studio | Meerkat Feature Drop 2024.3.2 Patch 1 | ☐ |
| 8.3 | Flutter SDK | 3.32.2 | ☐ |
| 8.4 | Node.js | 22.16.0 | ☐ |
| 8.5 | XAMPP (MySQL) | 8.2.12 | ☐ |

> ⚠️ Using different software versions than specified may result in the answer not being graded.

---

## Quick Summary Checklist

Use this as a final review before submission:

```
DATABASE
 ☐ All 7 weapon fields present (id, name, type, description, stock, image, price)
 ☐ At least 1 CREATE, 1 RETRIEVE, 1 UPDATE, 1 DELETE operation

FRONTEND
 ☐ At least 5 different UI component types
 ☐ At least 5 pages
 ☐ At least 3 data validation types
 ☐ Each failed validation shows a specific error message

BACKEND
 ☐ At least 2 GET endpoints
 ☐ At least 1 POST/PUT/PATCH/DELETE endpoint

AUTHENTICATION
 ☐ DB user login works
 ☐ External OAuth login works
 ☐ Bearer token generated (≥20 alphanumeric characters)
 ☐ Bearer token verified on at least 1 endpoint

UI DESIGN
 ☐ 2–4 theme properties customized and visible
 ☐ App is usable (readable colors, no clashing)

DOCUMENTATION
 ☐ External doc file included
 ☐ Features, creativity, theme, assets, usage all documented

SUBMISSION
 ☐ Full Flutter project folder submitted
 ☐ All asset files included
 ☐ Submitted before deadline
```

---

## How to Use This Document With Claude

Paste this document into Claude with a message like:

> *"Here are my requirements. Below is my current project structure / code. Please check if my project meets all the checklist items and tell me what's missing."*

Then share your relevant code (e.g., Flutter pages, Node.js routes, DB schema, auth logic) and Claude will cross-reference against each requirement.
