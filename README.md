# 🛍️ eShop — Flutter eCommerce App

A full-stack eCommerce mobile and web application built with **Flutter**, **PHP**, **MySQL**, and **MAMP**. Features a complete shopping experience for users and a powerful admin panel.

---

## 📱 Screenshots

> Home Screen |Responsive for devices

---
<img width="1211" height="847" alt="Screenshot 2026-03-17 155805" src="https://github.com/user-attachments/assets/89d2100a-edb8-4e1c-aefb-a36a0d82c62c" />
<img width="1918" height="1014" alt="Screenshot 2026-03-17 155541" src="https://github.com/user-attachments/assets/78a9ac5d-0bcf-4288-9fd4-14aecc68d4b9" />

---
> Admin screen

<img width="1919" height="1002" alt="Screenshot 2026-03-17 155653" src="https://github.com/user-attachments/assets/990740eb-60fb-40bf-a0ad-d8141b32ec10" />

---
> Login screen


<img width="1203" height="858" alt="Screenshot 2026-03-17 155729" src="https://github.com/user-attachments/assets/999d10c8-e961-44eb-914d-b3f86839dee9" />

---
> Order details
<img width="1194" height="839" alt="Screenshot 2026-03-17 155833" src="https://github.com/user-attachments/assets/742b1a9d-ce6f-46bd-94cc-44b12fe224ec" />

---

## ⚙️ Tech Stack


| Layer | Technology |
|---|---|
| Frontend | Flutter (Dart) |
| State Management | GetX |
| Backend | PHP |
| Database | MySQL |
| Local Server | MAMP |
| Platform | Web (Chrome), Android, iOS |

---

## ✨ Key Features

### 👤 User
- Register and Login with validation
- Browse products with search and category filter
- View product details with images and description
- Add to cart and manage quantities
- Place orders with delivery address
- Cancel orders (pending/processing only)
- View order history with status tracking
- Add products to wishlist
- Write reviews and give star ratings
- View profile

### 👨‍💼 Admin
- Secure admin login
- Dashboard with product and order stats
- Add, edit, and delete products
- Live image preview when adding product URL
- Category dropdown with icons
- View all customer orders
- Update order status — Pending → Processing → Shipped → Delivered → Cancelled
- Visual order status stepper

### 🎨 UI/UX
- Fully responsive — works on mobile, tablet, and desktop
- Clean purple theme with smooth navigation
- Loading indicators and error handling
- Snackbar notifications for all actions
- Pull to refresh on all lists

---

## 🗂️ Project Structure

```
eshop/
├── lib/
│   ├── main.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   ├── home_screen.dart
│   │   ├── product_detail_screen.dart
│   │   ├── cart_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── wishlist_screen.dart
│   │   └── admin/
│   │       ├── admin_dashboard_screen.dart
│   │       ├── admin_products_screen.dart
│   │       └── admin_orders_screen.dart
│   ├── controllers/
│   ├── services/
│   ├── models/
│   └── utils/
│
htdocs/eshop_api/
├── config/database.php
├── auth/
├── products/
├── cart/
├── orders/
├── reviews/
└── wishlist/
```

---

## 🚀 How to Run This Project

### Prerequisites

Make sure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.0 or above)
- [MAMP](https://www.mamp.info/en/downloads/) (for local server)
- [VS Code](https://code.visualstudio.com/) with Flutter extension
- Chrome browser

---

### Step 1 — Setup MAMP

1. Download and install MAMP
2. Open MAMP and click **Start Servers**
3. Set Apache port to **8888** and MySQL port to **8889**
   - Go to MAMP → Preferences → Ports
4. Confirm servers are running (green light)

---

### Step 2 — Setup Database

1. Open phpMyAdmin at `http://localhost:8888/phpMyAdmin`
2. Login with username `root` and password `root`
3. Click the **SQL** tab
4. Create the database and all tables by running the SQL file provided in the `/database` folder
5. This will also insert a default admin and sample products

---

### Step 3 — Setup PHP Backend

1. Copy the `eshop_api` folder
2. Paste it inside your MAMP htdocs folder
   - Windows path: `C:\MAMP\htdocs\`
   - Mac path: `/Applications/MAMP/htdocs/`
3. Verify it works by opening this in Chrome:
   ```
   http://localhost:8888/eshop_api/products/get_products.php
   ```
   You should see a JSON response with products

---

### Step 4 — Setup Flutter App

1. Clone or download this repository
2. Open the project in VS Code
3. Run the following command to install dependencies:
   ```
   flutter pub get
   ```
4. Open `lib/utils/app_constants.dart`
5. Make sure the base URL matches your setup:
   ```
   http://localhost:8888/eshop_api
   ```

---

### Step 5 — Run the App

```
flutter run -d chrome
```

The app will open in Chrome browser.

---

### Step 6 — Login

**User Account**
- Register a new account from the Register screen

**Admin Account**
--- you will find in main

---

## 📦 Dependencies

| Package | Purpose |
|---|---|
| get | State management and navigation |
| http | API calls to PHP backend |
| shared_preferences | Save login session |
| badges | Cart item count badge |
| cached_network_image | Load product images |
| google_fonts | Custom fonts |
| shimmer | Loading skeleton effect |

---

## 🗄️ Database Tables

| Table | Description |
|---|---|
| users | Registered users and admin |
| products | Product listing with details |
| cart | User cart items |
| orders | Placed orders |
| order_items | Items inside each order |
| reviews | Product ratings and comments |
| wishlist | User saved products |

---

## 🔐 Default Credentials

| Role | Email | Password |
|---|---|---|
| Admin |you will find in main
| User | Register yourself | Your choice |

---

## 🌐 API Endpoints

| Endpoint | Method | Description |
|---|---|---|
| /auth/register.php | POST | Register new user |
| /auth/login.php | POST | User login |
| /products/get_products.php | GET | Get all products |
| /products/add_product.php | POST | Add new product (admin) |
| /cart/add_to_cart.php | POST | Add item to cart |
| /cart/get_cart.php | GET | Get user cart |
| /orders/place_order.php | POST | Place an order |
| /orders/get_orders.php | GET | Get orders |
| /orders/update_order_status.php | POST | Update order status (admin) |
| /orders/cancel_order.php | POST | Cancel order (user) |
| /reviews/add_review.php | POST | Add product review |
| /reviews/get_reviews.php | GET | Get product reviews |
| /wishlist/toggle_wishlist.php | POST | Add or remove wishlist |
| /wishlist/get_wishlist.php | GET | Get user wishlist |

---

## 🐛 Common Issues

| Issue | Solution |
|---|---|
| Images not loading | Make sure image URL starts with https:// and is accessible in browser |
| API not working | Check MAMP is running and ports are correct |
| CORS error | Confirm database.php has correct CORS headers |
| DB connection failed | Check MySQL port is 8889 and password is root |
| App not loading | Run `flutter pub get` and restart |

---

## 📝 Notes

- This is a local development project using MAMP
- To run on physical Android/iOS device, replace `localhost` with your computer's IP address in `app_constants.dart`
- All passwords are stored using MD5 — upgrade to bcrypt for production

---

## 👨‍💻 Author

@Damish-7

---

## 📄 License

This project is open source and available for learning purposes.
