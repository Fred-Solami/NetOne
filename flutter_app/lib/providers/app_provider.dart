import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';
import '../models/location.dart' as app_models;
import '../models/order.dart';

class AppProvider extends ChangeNotifier {
  static const String _userSessionKey = 'user_session';
  static const String _sessionExpiryKey = 'session_expiry';
  
  List<User> _users = [];
  List<app_models.Location> _locations = [];
  List<Order> _orders = [];
  User? _currentUser;
  Map<String, dynamic>? _currentUserData;
  bool _isLoading = false;
  bool _sessionChecked = false;

  List<User> get users => _users;
  List<app_models.Location> get locations => _locations;
  List<Order> get orders => _orders;
  User? get currentUser => _currentUser;
  Map<String, dynamic>? get currentUserData => _currentUserData;
  bool get isLoading => _isLoading;
  
  bool get isAuthenticated => _currentUserData != null;
  bool get isAdmin => _currentUserData?['role'] == 'ADMIN';
  bool get isCustomer => _currentUserData?['role'] == 'USER';
  bool get sessionChecked => _sessionChecked;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setUsers(List<User> users) {
    _users = users;
    notifyListeners();
  }

  void addUser(User user) {
    _users.add(user);
    notifyListeners();
  }

  Future<void> setCurrentUser(dynamic user) async {
    if (user is Map<String, dynamic>) {
      _currentUserData = user;
      _currentUser = null; // Clear the old User object
      await _saveSession(user);
    } else if (user is User) {
      _currentUser = user;
      _currentUserData = null; // Clear the new user data
      await _saveSession({
        'id': user.id,
        'first_name': user.firstName,
        'last_name': user.lastName,
        'email': user.email,
        'role': 'USER',
      });
    } else {
      _currentUser = user;
      _currentUserData = null;
    }
    notifyListeners();
  }
  
  Future<void> clearCurrentUser() async {
    _currentUser = null;
    _currentUserData = null;
    await _clearSession();
    notifyListeners();
  }

  void setLocations(List<app_models.Location> locations) {
    _locations = locations;
    notifyListeners();
  }

  void addLocation(app_models.Location location) {
    _locations.add(location);
    notifyListeners();
  }

  void setOrders(List<Order> orders) {
    _orders = orders;
    notifyListeners();
  }

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  void updateOrder(Order updatedOrder) {
    final index = _orders.indexWhere((order) => order.id == updatedOrder.id);
    if (index != -1) {
      _orders[index] = updatedOrder;
      notifyListeners();
    }
  }

  void removeOrder(int orderId) {
    _orders.removeWhere((order) => order.id == orderId);
    notifyListeners();
  }

  // Session Management Methods
  Future<void> _saveSession(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final expiryTime = DateTime.now().add(const Duration(hours: 24)).millisecondsSinceEpoch;
      
      await prefs.setString(_userSessionKey, jsonEncode(userData));
      await prefs.setInt(_sessionExpiryKey, expiryTime);
    } catch (e) {
      print('Error saving session: $e');
    }
  }

  Future<void> _clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userSessionKey);
      await prefs.remove(_sessionExpiryKey);
    } catch (e) {
      print('Error clearing session: $e');
    }
  }

  Future<void> checkStoredSession() async {
    if (_sessionChecked) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionData = prefs.getString(_userSessionKey);
      final expiryTime = prefs.getInt(_sessionExpiryKey);
      
      if (sessionData != null && expiryTime != null) {
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        
        if (currentTime < expiryTime) {
          // Session is still valid
          final userData = Map<String, dynamic>.from(jsonDecode(sessionData));
          _currentUserData = userData;
        } else {
          // Session expired, clear it
          await _clearSession();
        }
      }
    } catch (e) {
      print('Error checking stored session: $e');
      await _clearSession();
    } finally {
      _sessionChecked = true;
      notifyListeners();
    }
  }

  Future<bool> isSessionValid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionData = prefs.getString(_userSessionKey);
      final expiryTime = prefs.getInt(_sessionExpiryKey);
      
      if (sessionData == null || expiryTime == null) {
        return false;
      }
      
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      return currentTime < expiryTime;
    } catch (e) {
      print('Error checking session validity: $e');
      return false;
    }
  }
}
