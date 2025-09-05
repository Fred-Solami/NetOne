import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';
import '../widgets/receipt_widget.dart';
import 'auth_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  // Real NetOne Zambia Inventory - Enterprise IT Solutions & Neo Hardware (2024)
  final List<NetOneInventoryItem> _inventory = [
    // Enterprise IT Solutions Inventory
    NetOneInventoryItem(
      id: 'fiber_internet_capacity',
      name: 'Business Fiber Internet Capacity',
      category: 'Enterprise IT',
      stock: 500,
      minStock: 50,
      price: 2500.00,
      supplier: 'NetOne Network Infrastructure',
      description: 'Dedicated fiber internet bandwidth for business clients',
    ),
    NetOneInventoryItem(
      id: 'data_center_racks',
      name: 'Data Center Server Racks',
      category: 'Enterprise IT',
      stock: 25,
      minStock: 5,
      price: 5500.00,
      supplier: 'NetOne Data Center Division',
      description: 'Server rack space and hosting infrastructure',
    ),
    NetOneInventoryItem(
      id: 'managed_services_contracts',
      name: 'Managed IT Services Contracts',
      category: 'Enterprise IT',
      stock: 100,
      minStock: 20,
      price: 8500.00,
      supplier: 'NetOne Professional Services',
      description: 'Complete IT infrastructure management contracts',
    ),
    NetOneInventoryItem(
      id: 'cybersecurity_licenses',
      name: 'Cybersecurity Solution Licenses',
      category: 'Enterprise IT',
      stock: 50,
      minStock: 10,
      price: 4200.00,
      supplier: 'NetOne Security Division',
      description: 'Enterprise cybersecurity and threat protection licenses',
    ),
    NetOneInventoryItem(
      id: 'swish_pay_licenses',
      name: 'Swish Pay Integration Licenses',
      category: 'Fintech',
      stock: 80,
      minStock: 15,
      price: 1500.00,
      supplier: 'NetOne Fintech Division',
      description: 'Payment gateway integration licenses for businesses',
    ),
    NetOneInventoryItem(
      id: 'software_development_projects',
      name: 'Custom Software Development Projects',
      category: 'Enterprise IT',
      stock: 30,
      minStock: 5,
      price: 12000.00,
      supplier: 'NetOne Software Engineering',
      description: 'Bespoke software development project allocations',
    ),
    NetOneInventoryItem(
      id: 'network_infrastructure_kits',
      name: 'Network Infrastructure Deployment Kits',
      category: 'Enterprise IT',
      stock: 15,
      minStock: 3,
      price: 15000.00,
      supplier: 'NetOne Infrastructure Division',
      description: 'Complete network setup and deployment packages',
    ),
    NetOneInventoryItem(
      id: 'cloud_migration_services',
      name: 'Cloud Migration Service Packages',
      category: 'Enterprise IT',
      stock: 40,
      minStock: 8,
      price: 9800.00,
      supplier: 'NetOne Cloud Solutions',
      description: 'Professional cloud migration and optimization services',
    ),
    NetOneInventoryItem(
      id: 'enterprise_solution_stock',
      name: 'Enterprise Solution Packages',
      category: 'Business Services',
      stock: 50,
      minStock: 10,
      price: 750.00,
      supplier: 'NetOne Enterprise Division',
      description: 'Complete enterprise connectivity and support packages',
    ),

    // Neo Laptops Inventory - Hardware Division
    NetOneInventoryItem(
      id: 'neo_laptop_basic_stock',
      name: 'Neo Laptop Basic',
      category: 'Neo Laptops',
      stock: 45,
      minStock: 10,
      price: 2800.00,
      supplier: 'Neo Manufacturing Zambia',
      description: 'Entry-level laptops for students and basic business use',
    ),
    NetOneInventoryItem(
      id: 'neo_laptop_pro_stock',
      name: 'Neo Laptop Pro',
      category: 'Neo Laptops',
      stock: 28,
      minStock: 8,
      price: 4200.00,
      supplier: 'Neo Manufacturing Zambia',
      description: 'Professional laptops for business and creative work',
    ),
    NetOneInventoryItem(
      id: 'neo_laptop_elite_stock',
      name: 'Neo Laptop Elite',
      category: 'Neo Laptops',
      stock: 15,
      minStock: 5,
      price: 6500.00,
      supplier: 'Neo Manufacturing Zambia',
      description: 'High-performance laptops for demanding applications',
    ),
    NetOneInventoryItem(
      id: 'neo_gaming_laptop_stock',
      name: 'Neo Gaming Laptop',
      category: 'Neo Laptops',
      stock: 12,
      minStock: 3,
      price: 8800.00,
      supplier: 'Neo Gaming Division',
      description: 'Premium gaming laptops with dedicated graphics',
    ),

    // Neo Tablets Inventory - Mobile Computing
    NetOneInventoryItem(
      id: 'neo_tablet_7_stock',
      name: 'Neo Tablet 7"',
      category: 'Neo Tablets',
      stock: 85,
      minStock: 20,
      price: 850.00,
      supplier: 'Neo Mobile Devices',
      description: 'Compact tablets for everyday use and entertainment',
    ),
    NetOneInventoryItem(
      id: 'neo_tablet_10_stock',
      name: 'Neo Tablet 10"',
      category: 'Neo Tablets',
      stock: 60,
      minStock: 15,
      price: 1200.00,
      supplier: 'Neo Mobile Devices',
      description: 'Mid-size tablets ideal for work and media consumption',
    ),
    NetOneInventoryItem(
      id: 'neo_tablet_pro_stock',
      name: 'Neo Tablet Pro',
      category: 'Neo Tablets',
      stock: 25,
      minStock: 8,
      price: 2100.00,
      supplier: 'Neo Professional Series',
      description: 'Professional tablets with keyboard and stylus support',
    ),
    NetOneInventoryItem(
      id: 'neo_tablet_kids_stock',
      name: 'Neo Tablet Kids Edition',
      category: 'Neo Tablets',
      stock: 40,
      minStock: 12,
      price: 650.00,
      supplier: 'Neo Education Division',
      description: 'Child-friendly tablets with educational content and controls',
    ),

    // Neo Smartphones Inventory - Mobile Communication
    NetOneInventoryItem(
      id: 'neo_phone_lite_stock',
      name: 'Neo Phone Lite',
      category: 'Neo Phones',
      stock: 120,
      minStock: 30,
      price: 750.00,
      supplier: 'Neo Mobile Communications',
      description: 'Affordable smartphones for everyday communication',
    ),
    NetOneInventoryItem(
      id: 'neo_phone_standard_stock',
      name: 'Neo Phone Standard',
      category: 'Neo Phones',
      stock: 85,
      minStock: 20,
      price: 1200.00,
      supplier: 'Neo Mobile Communications',
      description: 'Feature-rich smartphones with excellent performance',
    ),
    NetOneInventoryItem(
      id: 'neo_phone_pro_stock',
      name: 'Neo Phone Pro',
      category: 'Neo Phones',
      stock: 45,
      minStock: 12,
      price: 1850.00,
      supplier: 'Neo Premium Devices',
      description: 'Premium smartphones with advanced camera systems',
    ),
    NetOneInventoryItem(
      id: 'neo_phone_max_stock',
      name: 'Neo Phone Max',
      category: 'Neo Phones',
      stock: 25,
      minStock: 8,
      price: 2600.00,
      supplier: 'Neo Flagship Division',
      description: 'Top-tier flagship phones with cutting-edge features',
    ),
    NetOneInventoryItem(
      id: 'neo_phone_business_stock',
      name: 'Neo Phone Business',
      category: 'Neo Phones',
      stock: 35,
      minStock: 10,
      price: 1650.00,
      supplier: 'Neo Enterprise Mobility',
      description: 'Business-focused phones with enterprise security features',
    ),

    // Neo Device Bundles & Accessories
    NetOneInventoryItem(
      id: 'neo_starter_bundle_stock',
      name: 'Neo Starter Bundle',
      category: 'Neo Bundles',
      stock: 50,
      minStock: 15,
      price: 950.00,
      supplier: 'Neo Bundle Solutions',
      description: 'Entry-level phone and data bundle packages',
    ),
    NetOneInventoryItem(
      id: 'neo_student_package_stock',
      name: 'Neo Student Package',
      category: 'Neo Bundles',
      stock: 20,
      minStock: 5,
      price: 3200.00,
      supplier: 'Neo Education Solutions',
      description: 'Complete student computing and connectivity packages',
    ),
    NetOneInventoryItem(
      id: 'neo_business_package_stock',
      name: 'Neo Business Package',
      category: 'Neo Bundles',
      stock: 15,
      minStock: 3,
      price: 8500.00,
      supplier: 'Neo Business Solutions',
      description: 'Comprehensive business device and connectivity solutions',
    ),

    // Neo Accessories and Support Hardware
    NetOneInventoryItem(
      id: 'neo_laptop_chargers',
      name: 'Neo Laptop Chargers (Universal)',
      category: 'Neo Accessories',
      stock: 200,
      minStock: 50,
      price: 85.00,
      supplier: 'Neo Components Division',
      description: 'Universal laptop chargers compatible with all Neo laptops',
    ),
    NetOneInventoryItem(
      id: 'neo_phone_cases',
      name: 'Neo Phone Protection Cases',
      category: 'Neo Accessories',
      stock: 350,
      minStock: 80,
      price: 25.00,
      supplier: 'Neo Accessories Zambia',
      description: 'Protective cases for all Neo phone models',
    ),
    NetOneInventoryItem(
      id: 'neo_tablet_keyboards',
      name: 'Neo Tablet Bluetooth Keyboards',
      category: 'Neo Accessories',
      stock: 75,
      minStock: 20,
      price: 120.00,
      supplier: 'Neo Input Devices',
      description: 'Wireless keyboards compatible with Neo tablets',
    ),
  ];

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
                color: const Color(0xFFFF6B35),
                errorBuilder: (context, error, stackTrace) {
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
                'NetOne Admin',
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
            icon: const Icon(Icons.notifications),
            onPressed: _showNotifications,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildOverviewScreen(),
          _buildInventoryScreen(),
          _buildOrdersScreen(),
          _buildReportsScreen(),
          _buildProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFFFF6B35),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewScreen() {
    final lowStockItems = _inventory.where((item) => item.stock <= item.minStock).toList();
    final totalValue = _inventory.fold<double>(0, (sum, item) => sum + (item.stock * item.price));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Card(
            color: const Color(0xFFFF6B35),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'NetOne Admin Portal',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'System Status: ${lowStockItems.isNotEmpty ? "⚠️ Attention Required" : "✅ All Systems Normal"}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Key Metrics
          const Text(
            'Key Metrics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Total Inventory Items',
                  '${_inventory.length}',
                  Icons.inventory_2,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Low Stock Alerts',
                  '${lowStockItems.length}',
                  Icons.warning,
                  lowStockItems.isNotEmpty ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Total Inventory Value',
                  'K${totalValue.toStringAsFixed(0)}',
                  Icons.attach_money,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Active Services',
                  '${_inventory.where((i) => i.category.contains('Services')).length}',
                  Icons.network_cell,
                  const Color(0xFFFF6B35),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Low Stock Alerts
          if (lowStockItems.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Low Stock Alerts',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => setState(() => _selectedIndex = 1),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...lowStockItems.take(3).map((item) => _buildAlertCard(item)),
          ],

          // Recent Activity (simulated)
          const SizedBox(height: 32),
          const Text(
            'Recent Activity',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildActivityCard('New customer order received', '5 minutes ago', Icons.shopping_cart, Colors.green),
          _buildActivityCard('Data bundle allocation updated', '15 minutes ago', Icons.data_usage, Colors.blue),
          _buildActivityCard('SIM card stock replenished', '1 hour ago', Icons.sim_card, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildInventoryScreen() {
    return Column(
      children: [
        // Inventory Summary
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[50],
          child: Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total Items',
                  _inventory.length.toString(),
                  Icons.inventory,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  'Low Stock',
                  _inventory.where((item) => item.stock <= item.minStock).length.toString(),
                  Icons.warning,
                  Colors.red,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  'Categories',
                  _inventory.map((i) => i.category).toSet().length.toString(),
                  Icons.category,
                  Colors.green,
                ),
              ),
            ],
          ),
        ),

        // Inventory List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _inventory.length,
            itemBuilder: (context, index) {
              final item = _inventory[index];
              final isLowStock = item.stock <= item.minStock;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isLowStock ? Colors.red : const Color(0xFFFF6B35),
                    child: Icon(
                      _getCategoryIcon(item.category),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category: ${item.category}'),
                      Text('Supplier: ${item.supplier}'),
                      Text('Min Stock: ${item.minStock}'),
                      if (isLowStock)
                        const Text(
                          'RESTOCK NEEDED!',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Stock: ${item.stock}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isLowStock ? Colors.red : Colors.black,
                        ),
                      ),
                      Text('K${item.price.toStringAsFixed(2)}'),
                    ],
                  ),
                  onTap: () => _showItemDetails(item),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersScreen() {
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
                Icon(Icons.shopping_bag, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No Orders Yet',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Customer orders will appear here once placed',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Sort orders by creation date (newest first)
        orders.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));

        return Column(
          children: [
            // Order Summary Header
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[50],
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'Total Orders',
                      orders.length.toString(),
                      Icons.shopping_bag,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      'Today\'s Orders',
                      _getTodaysOrderCount(orders).toString(),
                      Icons.today,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      'Total Revenue',
                      'K${_getTotalRevenue(orders).toStringAsFixed(0)}',
                      Icons.attach_money,
                      const Color(0xFFFF6B35),
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
                  return _buildOrderCard(order);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReportsScreen() {
    final categories = _inventory.map((i) => i.category).toSet().toList();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inventory Reports',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          
          // Category Breakdown
          const Text(
            'Stock by Category',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          ...categories.map((category) {
            final categoryItems = _inventory.where((i) => i.category == category).toList();
            final categoryValue = categoryItems.fold<double>(0, (sum, item) => sum + (item.stock * item.price));
            final lowStockCount = categoryItems.where((i) => i.stock <= i.minStock).length;
            
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        if (lowStockCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$lowStockCount low stock',
                              style: TextStyle(color: Colors.red[700], fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Items: ${categoryItems.length}'),
                    Text('Total Value: K${categoryValue.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
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
                      user != null ? '${user['first_name'][0]}${user['last_name'][0]}' : 'A',
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user != null ? '${user['first_name']} ${user['last_name']}' : 'Admin',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user?['email'] ?? 'admin@netone.zm',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Administrator',
                      style: TextStyle(color: Colors.orange[700], fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.settings, color: Color(0xFFFF6B35)),
            title: const Text('System Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.backup, color: Color(0xFFFF6B35)),
            title: const Text('Backup & Restore'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFFFF6B35)),
            title: const Text('Logout'),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(NetOneInventoryItem item) {
    return Card(
      color: Colors.red[50],
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.warning, color: Colors.red[600]),
        title: Text(item.name),
        subtitle: Text('Stock: ${item.stock} (Min: ${item.minStock})'),
        trailing: ElevatedButton(
          onPressed: () => _restockItem(item),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[600],
            foregroundColor: Colors.white,
          ),
          child: const Text('Restock'),
        ),
      ),
    );
  }

  Widget _buildActivityCard(String activity, String time, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(activity),
        subtitle: Text(time),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'sim cards':
        return Icons.sim_card;
      case 'data services':
        return Icons.data_usage;
      case 'voice services':
        return Icons.phone;
      case 'sms services':
        return Icons.sms;
      case 'combo packages':
        return Icons.card_giftcard;
      default:
        return Icons.inventory;
    }
  }

  void _showItemDetails(NetOneInventoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${item.description}'),
            const SizedBox(height: 8),
            Text('Category: ${item.category}'),
            Text('Current Stock: ${item.stock}'),
            Text('Minimum Stock: ${item.minStock}'),
            Text('Unit Price: K${item.price.toStringAsFixed(2)}'),
            Text('Supplier: ${item.supplier}'),
            Text('Total Value: K${(item.stock * item.price).toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateStock(item);
            },
            child: const Text('Update Stock'),
          ),
        ],
      ),
    );
  }

  void _updateStock(NetOneInventoryItem item) {
    final controller = TextEditingController(text: item.stock.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Stock - ${item.name}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'New Stock Quantity',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newStock = int.tryParse(controller.text) ?? item.stock;
              setState(() {
                item.stock = newStock;
              });
              Navigator.pop(context);

              NotificationService.showInAppNotification(
                context,
                title: 'Stock Updated',
                message: '${item.name} stock updated to $newStock units',
                type: NotificationType.success,
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _restockItem(NetOneInventoryItem item) {
    final suggestedStock = item.minStock * 3; // Suggest 3x minimum stock
    final controller = TextEditingController(text: suggestedStock.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Restock ${item.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current Stock: ${item.stock}'),
            Text('Minimum Required: ${item.minStock}'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Restock Quantity',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final restockAmount = int.tryParse(controller.text) ?? suggestedStock;
              setState(() {
                item.stock += restockAmount;
              });
              Navigator.pop(context);

              NotificationService.showInAppNotification(
                context,
                title: 'Restock Complete',
                message: '${item.name} restocked with $restockAmount units',
                type: NotificationType.success,
              );
            },
            child: const Text('Restock'),
          ),
        ],
      ),
    );
  }

  void _showNotifications() {
    final lowStockItems = _inventory.where((item) => item.stock <= item.minStock).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('System Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (lowStockItems.isNotEmpty) ...[
              Text('Low Stock Alerts: ${lowStockItems.length}'),
              const SizedBox(height: 8),
              ...lowStockItems.take(5).map((item) => 
                Text('• ${item.name} (${item.stock} left)', style: const TextStyle(fontSize: 12))),
            ] else ...[
              const Text('✅ No alerts at this time'),
              const Text('All inventory levels are adequate'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (lowStockItems.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 1); // Go to inventory
              },
              child: const Text('View Inventory'),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
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
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          'Order #${order['id']}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Receipt: ${order['receiptNumber']}'),
            Text('Customer: ${order['user']['first_name']} ${order['user']['last_name']}'),
            Text('Date: ${_formatOrderDate(order['createdAt'])}'),
            Text('Items: $itemCount ($totalItems total) • K${order['total'].toStringAsFixed(2)}'),
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
                style: TextStyle(color: Colors.green[700], fontSize: 12),
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
                // Customer Info
                const Text(
                  'Customer Details:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text('Name: ${order['user']['first_name']} ${order['user']['last_name']}'),
                Text('Email: ${order['user']['email'] ?? 'Not provided'}'),
                Text('Location: ${order['location']['latitude']}, ${order['location']['longitude']}'),
                
                const SizedBox(height: 16),
                
                // Order Items
                const Text(
                  'Order Items:',
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
                        child: Text('K${item['price'].toStringAsFixed(0)}', textAlign: TextAlign.center),
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
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _deleteOrder(order['id']),
                        icon: const Icon(Icons.delete, size: 16),
                        label: const Text('Delete'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _getTodaysOrderCount(List<Map<String, dynamic>> orders) {
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    return orders.where((order) {
      final orderDate = order['createdAt'] as String;
      return orderDate.startsWith(todayString);
    }).length;
  }

  double _getTotalRevenue(List<Map<String, dynamic>> orders) {
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

  void _deleteOrder(String orderId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Order'),
        content: Text('Are you sure you want to delete order #$orderId? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              try {
                await StorageService.deleteOrder(orderId);
                setState(() {}); // Refresh the orders list
                
                if (mounted) {
                  NotificationService.showInAppNotification(
                    context,
                    title: 'Order Deleted',
                    message: 'Order #$orderId has been deleted successfully',
                    type: NotificationType.success,
                  );
                }
              } catch (e) {
                if (mounted) {
                  NotificationService.showInAppNotification(
                    context,
                    title: 'Error',
                    message: 'Failed to delete order: $e',
                    type: NotificationType.error,
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
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

class NetOneInventoryItem {
  final String id;
  final String name;
  final String category;
  int stock;
  final int minStock;
  final double price;
  final String supplier;
  final String description;

  NetOneInventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.stock,
    required this.minStock,
    required this.price,
    required this.supplier,
    required this.description,
  });
}
