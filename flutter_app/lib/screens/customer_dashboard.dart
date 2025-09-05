import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/app_provider.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';
import '../services/pdf_service.dart';
import '../widgets/receipt_widget.dart';
import '../models/user.dart';
import '../models/location.dart' as app_models;
import '../models/order.dart';
import 'auth_screen.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  int _selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String _currentLocation = 'Detecting location...';
  Position? _currentPosition;
  
  // Order state
  final Map<String, int> _orderQuantities = {};
  double _subtotal = 0.0;
  double _vat = 0.0;
  double _total = 0.0;
  
  // Real NetOne Zambia Products & Services - Enterprise IT Solutions & Neo Hardware
  final List<NetOneProduct> _products = [
    // NetOne Enterprise IT Solutions
    NetOneProduct(
      id: 'business_internet',
      name: 'NetOne Business Internet',
      category: 'Enterprise IT',
      price: 2500.00,
      description: 'Dedicated fiber internet for businesses - monthly subscription',
      icon: Icons.business,
    ),
    NetOneProduct(
      id: 'data_center_hosting',
      name: 'Data Center Hosting Services',
      category: 'Enterprise IT',
      price: 5500.00,
      description: 'Secure data center hosting and colocation services',
      icon: Icons.cloud,
    ),
    NetOneProduct(
      id: 'managed_it_services',
      name: 'Managed IT Services',
      category: 'Enterprise IT',
      price: 8500.00,
      description: 'Complete IT infrastructure management and support',
      icon: Icons.settings,
    ),
    NetOneProduct(
      id: 'cybersecurity_solutions',
      name: 'Cybersecurity Solutions',
      category: 'Enterprise IT',
      price: 4200.00,
      description: 'Advanced cybersecurity and threat protection services',
      icon: Icons.security,
    ),
    NetOneProduct(
      id: 'software_development',
      name: 'Custom Software Development',
      category: 'Enterprise IT',
      price: 12000.00,
      description: 'Bespoke software solutions for enterprise clients',
      icon: Icons.code,
    ),
    NetOneProduct(
      id: 'swish_pay_integration',
      name: 'Swish Pay Payment Integration',
      category: 'Fintech',
      price: 1500.00,
      description: 'Fintech payment gateway integration for businesses',
      icon: Icons.payment,
    ),
    NetOneProduct(
      id: 'network_infrastructure',
      name: 'Network Infrastructure Setup',
      category: 'Enterprise IT',
      price: 15000.00,
      description: 'Complete network infrastructure design and deployment',
      icon: Icons.router,
    ),
    NetOneProduct(
      id: 'cloud_migration',
      name: 'Cloud Migration Services',
      category: 'Enterprise IT',
      price: 9800.00,
      description: 'Professional cloud migration and optimization services',
      icon: Icons.cloud_upload,
    ),
    
    // Neo Laptops - NetOne Hardware Division
    NetOneProduct(
      id: 'neo_laptop_basic',
      name: 'Neo Laptop Basic',
      category: 'Laptops',
      price: 2800.00,
      description: 'Intel Core i3, 8GB RAM, 256GB SSD, 14" Display',
      icon: Icons.laptop_mac,
    ),
    NetOneProduct(
      id: 'neo_laptop_pro',
      name: 'Neo Laptop Pro',
      category: 'Laptops',
      price: 4200.00,
      description: 'Intel Core i5, 16GB RAM, 512GB SSD, 15" Display',
      icon: Icons.laptop_mac,
    ),
    NetOneProduct(
      id: 'neo_laptop_elite',
      name: 'Neo Laptop Elite',
      category: 'Laptops',
      price: 6500.00,
      description: 'Intel Core i7, 32GB RAM, 1TB SSD, 16" Display, Dedicated Graphics',
      icon: Icons.laptop_mac,
    ),
    NetOneProduct(
      id: 'neo_gaming_laptop',
      name: 'Neo Gaming Laptop',
      category: 'Laptops',
      price: 8800.00,
      description: 'Gaming Beast: i7, 32GB RAM, RTX Graphics, 17" 144Hz Display',
      icon: Icons.laptop_mac,
    ),
    
    // Neo Tablets - Portable Computing Solutions
    NetOneProduct(
      id: 'neo_tablet_7',
      name: 'Neo Tablet 7"',
      category: 'Tablets',
      price: 850.00,
      description: '7" Android Tablet, 4GB RAM, 64GB Storage, Wi-Fi + 4G',
      icon: Icons.tablet_mac,
    ),
    NetOneProduct(
      id: 'neo_tablet_10',
      name: 'Neo Tablet 10"',
      category: 'Tablets',
      price: 1200.00,
      description: '10" Android Tablet, 6GB RAM, 128GB Storage, Wi-Fi + 4G',
      icon: Icons.tablet_mac,
    ),
    NetOneProduct(
      id: 'neo_tablet_pro',
      name: 'Neo Tablet Pro',
      category: 'Tablets',
      price: 2100.00,
      description: '12" Android Tablet, 8GB RAM, 256GB Storage, Keyboard & Stylus',
      icon: Icons.tablet_mac,
    ),
    NetOneProduct(
      id: 'neo_tablet_kids',
      name: 'Neo Tablet Kids Edition',
      category: 'Tablets',
      price: 650.00,
      description: '8" Kids Tablet, Parental Controls, Educational Apps, Rugged Case',
      icon: Icons.tablet_mac,
    ),
    
    // Neo Smartphones - Mobile Communication Devices
    NetOneProduct(
      id: 'neo_phone_lite',
      name: 'Neo Phone Lite',
      category: 'Phones',
      price: 750.00,
      description: '5" Android, 4GB RAM, 64GB Storage, Dual Camera, 4G Ready',
      icon: Icons.phone_android,
    ),
    NetOneProduct(
      id: 'neo_phone_standard',
      name: 'Neo Phone Standard',
      category: 'Phones',
      price: 1200.00,
      description: '6" Android, 6GB RAM, 128GB Storage, Triple Camera, 5G Ready',
      icon: Icons.phone_android,
    ),
    NetOneProduct(
      id: 'neo_phone_pro',
      name: 'Neo Phone Pro',
      category: 'Phones',
      price: 1850.00,
      description: '6.5" AMOLED, 8GB RAM, 256GB Storage, Quad Camera, 5G',
      icon: Icons.phone_android,
    ),
    NetOneProduct(
      id: 'neo_phone_max',
      name: 'Neo Phone Max',
      category: 'Phones',
      price: 2600.00,
      description: '6.8" AMOLED, 12GB RAM, 512GB Storage, Pro Camera System, 5G',
      icon: Icons.phone_android,
    ),
    NetOneProduct(
      id: 'neo_phone_business',
      name: 'Neo Phone Business',
      category: 'Phones',
      price: 1650.00,
      description: '6.2" Display, Enterprise Security, 8GB RAM, 256GB, Dual SIM',
      icon: Icons.phone_android,
    ),
    
    // Device Bundles & Accessories
    NetOneProduct(
      id: 'neo_starter_bundle',
      name: 'Neo Starter Bundle',
      category: 'Bundles',
      price: 950.00,
      description: 'Neo Phone Lite + 2GB Monthly Data for 12 Months',
      icon: Icons.card_giftcard,
    ),
    NetOneProduct(
      id: 'neo_student_package',
      name: 'Neo Student Package',
      category: 'Bundles',
      price: 3200.00,
      description: 'Neo Laptop Basic + Neo Tablet 7" + 6 Months Internet',
      icon: Icons.card_giftcard,
    ),
    NetOneProduct(
      id: 'neo_business_package',
      name: 'Neo Business Package',
      category: 'Bundles',
      price: 8500.00,
      description: 'Neo Laptop Pro + Neo Phone Business + Enterprise Solutions',
      icon: Icons.card_giftcard,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _currentLocation = 'Location permission denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _currentLocation = 'Location permissions are permanently denied');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() {
        _currentPosition = position;
        _currentLocation = 'Location: ${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
      });
    } catch (e) {
      setState(() => _currentLocation = 'Error getting location: $e');
    }
  }

  void _updateQuantity(String productId, int change) {
    setState(() {
      _orderQuantities[productId] = (_orderQuantities[productId] ?? 0) + change;
      if (_orderQuantities[productId]! <= 0) {
        _orderQuantities.remove(productId);
      }
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    _subtotal = 0.0;
    for (final entry in _orderQuantities.entries) {
      final product = _products.firstWhere((p) => p.id == entry.key);
      _subtotal += product.price * entry.value;
    }
    _vat = _subtotal * 0.16; // 16% VAT
    _total = _subtotal + _vat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.all(3),
              child: Image.asset(
                'assets/images/netone_logo.png',
                fit: BoxFit.contain,
                width: 22,
                height: 22,
                color: const Color(0xFFFF6B35), // Apply color overlay to make it visible
                errorBuilder: (context, error, stackTrace) {
                  print('Logo loading error: $error'); // Debug info
                  return Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Text(
                        'N1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'NetOne Customer',
                style: TextStyle(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildOrderScreen(),
          _buildMyOrdersScreen(),
          _buildProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFFFF6B35),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Order Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'My Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildOrderScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              color: const Color(0xFFFF6B35),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome to NetOne Zambia!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enterprise IT Solutions & Neo Hardware',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _currentLocation,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Customer Info Section
            const Text(
              'Customer Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Products Section
            const Text(
              'NetOne Enterprise Solutions & Neo Hardware',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Product Categories
            ..._buildProductsByCategory(),
            
            const SizedBox(height: 32),
            
            // Order Summary
            if (_orderQuantities.isNotEmpty) ...[
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Summary',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      
                      // Order Items
                      ..._orderQuantities.entries.map((entry) {
                        final product = _products.firstWhere((p) => p.id == entry.key);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${product.name} x${entry.value}'),
                              Text('K${(product.price * entry.value).toStringAsFixed(2)}'),
                            ],
                          ),
                        );
                      }).toList(),
                      
                      const Divider(),
                      
                      // Totals
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal:'),
                          Text('K${_subtotal.toStringAsFixed(2)}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('VAT (16%):'),
                          Text('K${_vat.toStringAsFixed(2)}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'K${_total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6B35),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Place Order Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _placeOrder,
                  child: const Text(
                    'Place Order',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProductsByCategory() {
    final categories = _products.map((p) => p.category).toSet().toList();
    
    return categories.map((category) {
      final categoryProducts = _products.where((p) => p.category == category).toList();
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              category,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          ...categoryProducts.map((product) => _buildProductCard(product)),
          const SizedBox(height: 16),
        ],
      );
    }).toList();
  }

  Widget _buildProductCard(NetOneProduct product) {
    final quantity = _orderQuantities[product.id] ?? 0;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFFF6B35),
              child: Icon(product.icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'K${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B35),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: quantity > 0 ? () => _updateQuantity(product.id, -1) : null,
                ),
                Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => _updateQuantity(product.id, 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyOrdersScreen() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: StorageService.getAllOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFFF6B35),
            ),
          );
        }

        final orders = snapshot.data ?? [];

        if (orders.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.list_alt, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No orders yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Your order history will appear here',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Sort orders by creation date (newest first)
        orders.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));

        return RefreshIndicator(
          color: const Color(0xFFFF6B35),
          onRefresh: () async {
            setState(() {}); // Trigger rebuild to refresh data
          },
          child: Column(
            children: [
              // Order Summary Header
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[50],
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${orders.length}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6B35),
                            ),
                          ),
                          const Text(
                            'Total Orders',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'K${_getTotalSpent(orders).toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const Text(
                            'Total Spent',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Orders List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _buildOrderHistoryCard(order);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileScreen() {
    final appProvider = Provider.of<AppProvider>(context);
    final user = appProvider.currentUserData;
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFFFF6B35),
                    child: Text(
                      user != null ? '${user['first_name'][0]}${user['last_name'][0]}' : 'U',
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user != null ? '${user['first_name']} ${user['last_name']}' : 'User',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user?['email'] ?? 'user@netone.zm',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Customer',
                      style: TextStyle(color: Colors.green[700], fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFFFF6B35)),
            title: const Text('Logout'),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_orderQuantities.isEmpty) {
      NotificationService.showInAppNotification(
        context,
        title: 'No Items Selected',
        message: 'Please select at least one service to order',
        type: NotificationType.warning,
      );
      return;
    }
    
    if (_currentPosition == null) {
      NotificationService.showInAppNotification(
        context,
        title: 'Location Required',
        message: 'Please allow location access to place order',
        type: NotificationType.warning,
      );
      return;
    }

    try {
      // Show loading
      NotificationService.showInAppNotification(
        context,
        title: 'Processing Order...',
        message: 'Please wait while we process your NetOne order',
        type: NotificationType.success,
      );
      
      // Simulate processing time
      await Future.delayed(const Duration(seconds: 2));
      
      // Create mock user
      final mockUser = User(
        id: DateTime.now().millisecondsSinceEpoch,
        firstName: _firstNameController.text.isNotEmpty 
            ? _firstNameController.text 
            : 'Demo',
        lastName: _lastNameController.text.isNotEmpty 
            ? _lastNameController.text 
            : 'Customer',
        email: '${_firstNameController.text.toLowerCase()}@netone.zm',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
      
      // Create mock location  
      final mockLocation = app_models.Location(
        id: DateTime.now().millisecondsSinceEpoch,
        name: 'Customer Location',
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        address: _currentLocation.contains('Detecting') 
            ? 'Lusaka, Zambia' 
            : _currentLocation,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
      
      // Prepare order items for receipt
      final orderItems = _orderQuantities.entries.map((entry) {
        final product = _products.firstWhere((p) => p.id == entry.key);
        return {
          'name': product.name,
          'quantity': entry.value,
          'price': product.price,
          'total': product.price * entry.value,
        };
      }).toList();
      
      // Create mock order
      final mockOrder = Order(
        id: DateTime.now().millisecondsSinceEpoch,
        userId: mockUser.id!,
        locationId: mockLocation.id!,
        amount: _subtotal,
        vatRate: 16.0,
        vatAmount: _vat,
        totalAmount: _total,
        description: 'NetOne Services Order - ${_orderQuantities.length} items',
        status: 'CONFIRMED',
        user: mockUser,
        location: mockLocation,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
      
      // Save order to local storage
      final orderId = await StorageService.saveOrder(
        user: mockUser,
        location: mockLocation,
        orderItems: orderItems,
        subtotal: _subtotal,
        vat: _vat,
        total: _total,
      );
      
      // Show success notification
      NotificationService.showInAppNotification(
        context,
        title: '🎉 Order Placed Successfully!',
        message: 'Order #$orderId - Total: K${_total.toStringAsFixed(2)}',
        type: NotificationType.success,
      );
      
      // Get saved order data for receipt
      final savedOrder = await StorageService.getOrderById(orderId);
      
      // Show enhanced e-receipt dialog with PDF download
      if (mounted && savedOrder != null) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => EnhancedReceiptDialog(
            orderData: savedOrder,
            orderItems: orderItems,
          ),
        );
      }
      
      // Clear form after receipt is shown
      _firstNameController.clear();
      _lastNameController.clear();
      setState(() {
        _orderQuantities.clear();
        _calculateTotal();
        _selectedIndex = 1; // Switch to orders tab
      });
      
    } catch (e) {
      NotificationService.showInAppNotification(
        context,
        title: 'Order Failed',
        message: 'Something went wrong. Please try again.',
        type: NotificationType.error,
      );
    }
  }

  Widget _buildOrderHistoryCard(Map<String, dynamic> order) {
    final orderItems = (order['items'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    final itemCount = orderItems.length;
    final totalItems = orderItems.fold<int>(0, (sum, item) => sum + (item['quantity'] as int));
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFFF6B35),
          child: Text(
            '${order['id']}'.substring(0, 2).toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          'Order #${order['id']}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Receipt: ${order['receiptNumber']}'),
            Text('Date: ${_formatOrderDate(order['createdAt'])}'),
            Text('Items: $itemCount ($totalItems total)'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Completed',
                style: TextStyle(color: Colors.green[700], fontSize: 10),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'K${order['total'].toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Items
                const Text(
                  'Items Ordered:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                ...orderItems.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(item['name']),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('×${item['quantity']}', textAlign: TextAlign.center),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'K${item['total'].toStringAsFixed(0)}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                )),
                
                const SizedBox(height: 16),
                const Divider(),
                
                // Payment Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal:'),
                    Text('K${order['subtotal'].toStringAsFixed(2)}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('VAT (16%):'),
                    Text('K${order['vat'].toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TOTAL:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'K${order['total'].toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFFF6B35)),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _viewOrderReceipt(order, orderItems),
                    icon: const Icon(Icons.receipt, size: 16),
                    label: const Text('View Receipt'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B35),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _getTotalSpent(List<Map<String, dynamic>> orders) {
    return orders.fold<double>(0, (sum, order) => sum + (order['total'] as double));
  }

  String _formatOrderDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Unknown date';
    }
  }

  void _viewOrderReceipt(Map<String, dynamic> order, List<Map<String, dynamic>> orderItems) {
    showDialog(
      context: context,
      builder: (context) => EnhancedReceiptDialog(
        orderData: order,
        orderItems: orderItems,
      ),
    );
  }

  Future<void> _logout() async {
    await Provider.of<AppProvider>(context, listen: false).clearCurrentUser();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    }
  }
}

class NetOneProduct {
  final String id;
  final String name;
  final String category;
  final double price;
  final String description;
  final IconData icon;

  NetOneProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.icon,
  });
}
