# NetOne Order Management System

Full-stack application built for NetOne Zambia with Flutter frontend and Laravel backend.

## Features

### Core Requirements
- **User Registration**: First name and last name input
- **Location Management**: GPS coordinates with current location detection
- **Order Management**: Order processing with 16% VAT calculation
- **Real-time Updates**: Backend updates when frontend actions occur

### Additional Features
- **Dashboard**: Order and revenue overview
- **Search**: Filter orders by various criteria
- **Inventory**: Basic stock management
- **Notifications**: In-app alerts for system events

## 🏗️ Architecture
- **Frontend**: Flutter (Dart) with Provider state management
- **Backend**: Laravel 12 with RESTful API
- **Database**: SQLite (easily configurable to MySQL/PostgreSQL)
- **Real-time**: WebSocket support with Laravel Reverb
- **Location**: Geolocator and Geocoding services

## 📁 Project Structure
```
├── flutter_app/          # Flutter mobile application
│   ├── lib/
│   │   ├── models/        # Data models (User, Order, Location)
│   │   ├── services/      # API and WebSocket services
│   │   ├── providers/     # State management
│   │   ├── screens/       # UI screens
│   │   └── widgets/       # Reusable UI components
└── laravel_backend/       # Laravel API backend
    ├── app/
    │   ├── Models/        # Eloquent models
    │   ├── Http/Controllers/Api/  # API controllers
    │   └── Events/        # WebSocket events
    ├── database/
    │   └── migrations/    # Database schema
    └── routes/api.php     # API routes
```

## 🛠️ Setup Instructions

### Prerequisites
- PHP 8.2+
- Composer
- Flutter SDK 3.9+
- Dart SDK

### Backend Setup (Laravel)
```bash
cd laravel_backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate:fresh --seed
php artisan serve --host=0.0.0.0 --port=8000
```

### Frontend Setup (Flutter)
```bash
cd flutter_app
flutter pub get
flutter packages pub run build_runner build
flutter run
```

## 🔧 API Endpoints

### Users
- `GET /api/users` - List all users
- `POST /api/users` - Create new user
- `GET /api/users/{id}` - Get user details
- `PUT /api/users/{id}` - Update user
- `DELETE /api/users/{id}` - Delete user

### Locations
- `GET /api/locations` - List all locations
- `POST /api/locations` - Create new location
- `GET /api/locations/{id}` - Get location details
- `PUT /api/locations/{id}` - Update location
- `DELETE /api/locations/{id}` - Delete location

### Orders
- `GET /api/orders` - List all orders
- `POST /api/orders` - Create new order
- `GET /api/orders/{id}` - Get order details
- `PUT /api/orders/{id}` - Update order
- `DELETE /api/orders/{id}` - Delete order

### Health Check
- `GET /api/health` - API health status

## 💡 Key Features Demonstrated

### 1. User Registration
- Clean form validation
- Real-time API integration
- Error handling and user feedback

### 2. Location Management
- GPS location detection
- Manual coordinate entry
- Google Maps integration ready
- Address geocoding

### 3. Order Processing
- Automatic VAT calculation (16%)
- Real-time total updates
- Order status tracking
- Professional order cards

### 4. Real-time Updates
- WebSocket integration
- Live data synchronization
- Connection status indicator

## Technical Implementation

### Backend (Laravel)
- RESTful API endpoints
- Database with proper relationships
- WebSocket events for real-time updates
- Input validation and error handling

### Frontend (Flutter)
- Material Design interface
- Provider state management
- GPS location services
- Real-time UI updates

### Key Functionality
- 16% VAT calculation
- Google coordinates integration
- Order history and management
- Basic inventory tracking

## Running the Application

1. **Start the Laravel backend**:
   ```bash
   cd laravel_backend && php artisan serve
   ```

2. **Run the Flutter app**:
   ```bash
   cd flutter_app && flutter run
   ```

3. **Test the workflow**:
   - Register a user with first and last name
   - Add a location using GPS or manual coordinates
   - Create an order to see 16% VAT calculation
   - Check that backend updates in real-time

---

**Built for NetOne Zambia**