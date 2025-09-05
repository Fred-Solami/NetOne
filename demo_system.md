# NetOne Order Management System - Demo Guide

## System Components

### Backend (Laravel) - http://localhost:8000
- API endpoints for users, locations, orders
- WebSocket support for real-time updates
- Database with proper relationships

### Frontend (Flutter) - Linux Desktop App
- User registration with first/last name
- Location services with GPS coordinates
- Order management with 16% VAT calculation
- Real-time backend synchronization

## Demo Features

### 1. User Registration
- First name and last name input (as required)
- Form validation and backend sync

### 2. Location Management
- GPS integration with "Use Current Location" button
- Manual coordinate entry (latitude/longitude)
- Shows Google coordinates format

### 3. Order Processing
- Amount input
- Automatic 16% VAT calculation
- Total amount display (amount + VAT)
- Real-time backend updates

### 4. Dashboard
- Order count and revenue totals
- VAT collection summary
- User statistics

### 5. Additional Features
- Order search and filtering
- Basic inventory management
- In-app notifications

## Demo Instructions

### Step 1: Start Applications
```bash
# Backend
cd laravel_backend && php artisan serve

# Frontend
cd flutter_app && flutter run -d linux
```

### Step 2: Quick Demo
1. Click the ⚡ "Demo Real-time Updates" button in the app header
2. This will:
   - Create a demo user with first/last name
   - Add a location with GPS coordinates
   - Create an order with 16% VAT calculation
   - Show real-time notifications
   - Update the dashboard

### Step 3: Manual Testing
1. **User Registration**: Add users with first and last names
2. **Location**: Use GPS or enter coordinates manually
3. **Orders**: Enter amount, see VAT calculation and total
4. **Dashboard**: View updated statistics

## Technical Implementation

### Backend Features
- RESTful API endpoints
- Real-time WebSocket events
- Input validation and error handling
- Database relationships
- VAT calculation logic

### Frontend Features
- Material Design interface
- Provider state management
- GPS location services
- Real-time UI updates
- Form validation

### Core Requirements Met
- First name + last name input
- Google coordinates integration
- 16% VAT calculation
- Real-time backend updates
- Order management workflow