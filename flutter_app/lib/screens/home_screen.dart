import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import 'user_registration_screen.dart';
import 'order_management_screen.dart';
import 'dashboard_screen.dart';
import 'advanced_search_screen.dart';
import 'inventory_screen.dart';
import 'netone_order_screen.dart';
import '../widgets/connection_status.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const NetOneOrderScreen(),
    const DashboardScreen(),
    const UserRegistrationScreen(),
    const OrderManagementScreen(),
    const InventoryScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final apiService = Provider.of<ApiService>(context, listen: false);
    
    provider.setLoading(true);
    
    try {
      final users = await apiService.getUsers();
      final locations = await apiService.getLocations();
      final orders = await apiService.getOrders();
      
      provider.setUsers(users);
      provider.setLocations(locations);
      provider.setOrders(orders);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      provider.setLoading(false);
    }
  }

  Future<void> _demonstrateRealTimeUpdates() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final apiService = Provider.of<ApiService>(context, listen: false);

    // Show demo dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🚀 Real-time Demo'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Creating demo user, location, and order...'),
            Text('Watch the backend update in real-time!'),
          ],
        ),
      ),
    );

    try {
      // 1. Create a demo user
      await Future.delayed(const Duration(seconds: 1));
      final user = await apiService.createUser(
        'Demo', 
        'User ${DateTime.now().millisecond}',
        email: 'demo${DateTime.now().millisecond}@netone.zm'
      );
      provider.addUser(user);
      
      NotificationService.showInAppNotification(
        context,
        title: '✅ User Created',
        message: 'New user ${user.firstName} ${user.lastName} added to backend',
        type: NotificationType.success,
      );

      // 2. Create a demo location with coordinates
      await Future.delayed(const Duration(seconds: 1));
      final location = await apiService.createLocation(
        'NetOne Office ${DateTime.now().millisecond}',
        -15.3875 + (DateTime.now().millisecond % 100) / 10000, // Lusaka coordinates with variation
        28.3228 + (DateTime.now().millisecond % 100) / 10000,
        address: 'Lusaka, Zambia'
      );
      provider.addLocation(location);
      
      NotificationService.showInAppNotification(
        context,
        title: '📍 Location Added',
        message: 'GPS coordinates: ${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}',
        type: NotificationType.success,
      );

      // 3. Create a demo order
      await Future.delayed(const Duration(seconds: 1));
      final order = await apiService.createOrder(
        user.id!,
        location.id!,
        100.0 + (DateTime.now().millisecond % 500), // Random amount
        description: 'Demo order - Real-time test'
      );
      provider.addOrder(order);
      
      NotificationService.showInAppNotification(
        context,
        title: '🛒 Order Created',
        message: 'Amount: K${order.amount.toStringAsFixed(2)} + VAT = K${order.calculatedTotalAmount.toStringAsFixed(2)}',
        type: NotificationType.success,
      );

      Navigator.of(context).pop(); // Close loading dialog

      // Show success summary
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('🎉 Real-time Demo Complete!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('✅ Backend updated in real-time:'),
              const SizedBox(height: 8),
              Text('👤 User: ${user.firstName} ${user.lastName}'),
              Text('📍 Location: ${location.name}'),
              Text('🌍 Coordinates: ${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}'),
              Text('🛒 Order: K${order.amount.toStringAsFixed(2)} (+ 16% VAT)'),
              Text('💰 Total: K${order.calculatedTotalAmount.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              const Text('Check the Dashboard tab to see live analytics!'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _selectedIndex = 0; // Switch to Dashboard
                });
              },
              child: const Text('View Dashboard'),
            ),
          ],
        ),
      );

    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Demo failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NetOne Order Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdvancedSearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.flash_on),
            tooltip: 'Demo Real-time Updates',
            onPressed: () => _demonstrateRealTimeUpdates(),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              NotificationService.simulateOrderNotification(context, 'ORD-${DateTime.now().millisecondsSinceEpoch}');
            },
          ),
          const ConnectionStatus(),
          const SizedBox(width: 16),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading...'),
                ],
              ),
            );
          }
          
          return _screens[_selectedIndex];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFF6B35),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.phone_android),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Register',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Manage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
        ],
      ),
    );
  }
}