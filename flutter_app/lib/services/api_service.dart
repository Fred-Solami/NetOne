import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/location.dart' as app_models;
import '../models/order.dart';

class ApiService {
  static const String baseUrl = String.fromEnvironment('BACKEND_BASE_URL', defaultValue: 'https://4f5335395ae0.ngrok-free.app/api'); // Your live backend!

  // Users
  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    }
    throw Exception('Failed to load users');
  }

  Future<User> createUser(String firstName, String lastName, {String? email}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'first_name': firstName,
        'last_name': lastName,
        if (email != null) 'email': email,
      }),
    );
    
    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return User.fromJson(data['user']);
    }
    throw Exception('Failed to create user');
  }

  // Locations
  Future<List<app_models.Location>> getLocations() async {
    final response = await http.get(Uri.parse('$baseUrl/locations'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => app_models.Location.fromJson(json)).toList();
    }
    throw Exception('Failed to load locations');
  }

  Future<app_models.Location> createLocation(String name, double latitude, double longitude, {String? address}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/locations'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        if (address != null) 'address': address,
      }),
    );
    
    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return app_models.Location.fromJson(data['location']);
    }
    throw Exception('Failed to create location');
  }

  // Orders
  Future<List<Order>> getOrders() async {
    final response = await http.get(Uri.parse('$baseUrl/orders'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Order.fromJson(json)).toList();
    }
    throw Exception('Failed to load orders');
  }

  Future<Order> createOrder(int userId, int locationId, double amount, {String? description}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': userId,
        'location_id': locationId,
        'amount': amount,
        'vat_rate': 16.0,
        if (description != null) 'description': description,
      }),
    );
    
    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return Order.fromJson(data['order']);
    }
    throw Exception('Failed to create order');
  }

  // Health check
  Future<bool> checkHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}