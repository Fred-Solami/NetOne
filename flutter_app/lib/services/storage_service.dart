import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/location.dart' as app_models;

class StorageService {
  static const String _ordersKey = 'netone_orders';
  static const String _orderCounterKey = 'netone_order_counter';

  // Generate unique order ID
  static Future<String> _generateOrderId() async {
    final prefs = await SharedPreferences.getInstance();
    int counter = prefs.getInt(_orderCounterKey) ?? 1000;
    counter++;
    await prefs.setInt(_orderCounterKey, counter);
    return 'NET${counter.toString().padLeft(6, '0')}';
  }

  // Save order to local storage
  static Future<String> saveOrder({
    required User user,
    required app_models.Location location,
    required List<Map<String, dynamic>> orderItems,
    required double subtotal,
    required double vat,
    required double total,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final orderId = await _generateOrderId();
      final now = DateTime.now();
      
      // Create order object
      final order = {
        'id': orderId,
        'receiptNumber': 'RCP-${orderId}',
        'user': user.toJson(),
        'location': location.toJson(),
        'items': orderItems,
        'subtotal': subtotal,
        'vat': vat,
        'total': total,
        'status': 'CONFIRMED',
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      };

      // Get existing orders
      List<String> existingOrders = prefs.getStringList(_ordersKey) ?? [];
      
      // Add new order
      existingOrders.add(jsonEncode(order));
      
      // Save back to storage
      await prefs.setStringList(_ordersKey, existingOrders);
      
      // Send to Laravel backend (don't block if it fails)
      _sendToBackend(order).catchError((e) {
        print('Failed to send order to backend: $e');
      });
      
      return orderId;
    } catch (e) {
      print('Error saving order: $e');
      rethrow;
    }
  }

  // Get all orders
  static Future<List<Map<String, dynamic>>> getAllOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> orderStrings = prefs.getStringList(_ordersKey) ?? [];
      
      return orderStrings.map((orderString) {
        return Map<String, dynamic>.from(jsonDecode(orderString));
      }).toList();
    } catch (e) {
      print('Error getting orders: $e');
      return [];
    }
  }

  // Get orders for specific user
  static Future<List<Map<String, dynamic>>> getUserOrders(String userEmail) async {
    try {
      final allOrders = await getAllOrders();
      return allOrders.where((order) {
        final user = order['user'] as Map<String, dynamic>?;
        return user?['email'] == userEmail;
      }).toList();
    } catch (e) {
      print('Error getting user orders: $e');
      return [];
    }
  }

  // Get order by ID
  static Future<Map<String, dynamic>?> getOrderById(String orderId) async {
    try {
      final allOrders = await getAllOrders();
      return allOrders.firstWhere(
        (order) => order['id'] == orderId,
        orElse: () => {},
      );
    } catch (e) {
      print('Error getting order by ID: $e');
      return null;
    }
  }

  // Clear all orders (for testing)
  static Future<void> clearAllOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_ordersKey);
      await prefs.remove(_orderCounterKey);
    } catch (e) {
      print('Error clearing orders: $e');
    }
  }

  // Delete a specific order by ID
  static Future<bool> deleteOrder(String orderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = prefs.getStringList(_ordersKey) ?? [];
      
      // Filter out the order to delete
      final updatedOrders = ordersJson.where((orderStr) {
        final orderData = Map<String, dynamic>.from(jsonDecode(orderStr));
        return orderData['id'] != orderId;
      }).toList();
      
      // Save the updated list
      await prefs.setStringList(_ordersKey, updatedOrders);
      
      print('Order $orderId deleted successfully');
      return true;
    } catch (e) {
      print('Error deleting order: $e');
      return false;
    }
  }

  // Get orders count
  static Future<int> getOrdersCount() async {
    try {
      final orders = await getAllOrders();
      return orders.length;
    } catch (e) {
      print('Error getting orders count: $e');
      return 0;
    }
  }

  // Get today's orders
  static Future<List<Map<String, dynamic>>> getTodaysOrders() async {
    try {
      final allOrders = await getAllOrders();
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      final todayEnd = todayStart.add(const Duration(days: 1));

      return allOrders.where((order) {
        final orderDate = DateTime.parse(order['createdAt']);
        return orderDate.isAfter(todayStart) && orderDate.isBefore(todayEnd);
      }).toList();
    } catch (e) {
      print('Error getting today\'s orders: $e');
      return [];
    }
  }
  
  /// Send order data to Laravel backend
  static Future<void> _sendToBackend(Map<String, dynamic> order) async {
    try {
      const apiUrl = 'https://4f5335395ae0.ngrok-free.app/api'; // Your live backend!
      
      // Create order in backend
      final orderResponse = await http.post(
        Uri.parse('$apiUrl/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'user_id': 1, // Use default user ID
          'location_id': 1, // Use default location ID
          'amount': order['total'],
          'vat_rate': 16.0,
          'vat_amount': order['vat'],
          'total_amount': order['total'],
          'description': 'NetOne Order - ${order['items'].length} items',
          'status': 'CONFIRMED',
          'receipt_number': order['receiptNumber'],
        }),
      );
      
      print('✅ Order sent to Laravel backend: ${orderResponse.statusCode}');
      
    } catch (e) {
      print('❌ Error sending to Laravel backend: $e');
      rethrow;
    }
  }
}
