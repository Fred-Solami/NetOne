import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/notification_service.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final List<InventoryItem> _inventory = [
    InventoryItem(
      id: 1,
      name: 'NetOne SIM Cards',
      category: 'SIM Cards',
      stock: 150,
      minStock: 50,
      price: 5.00,
      supplier: 'NetOne HQ',
    ),
    InventoryItem(
      id: 2,
      name: 'Data Bundles (1GB)',
      category: 'Data Packages',
      stock: 25,
      minStock: 100,
      price: 15.00,
      supplier: 'NetOne Systems',
    ),
    InventoryItem(
      id: 3,
      name: 'Voice Bundles',
      category: 'Voice Packages',
      stock: 200,
      minStock: 75,
      price: 10.00,
      supplier: 'NetOne Systems',
    ),
    InventoryItem(
      id: 4,
      name: 'Mobile Handsets',
      category: 'Devices',
      stock: 12,
      minStock: 20,
      price: 250.00,
      supplier: 'Tech Distributors',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewItem,
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: _showInventoryReport,
          ),
        ],
      ),
      body: Column(
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
                    'Total Value',
                    'K${_inventory.fold<double>(0, (sum, item) => sum + (item.stock * item.price)).toStringAsFixed(0)}',
                    Icons.attach_money,
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
                        if (isLowStock)
                          const Text(
                            'LOW STOCK ALERT!',
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _restockAlert,
        backgroundColor: const Color(0xFFFF6B35),
        child: const Icon(Icons.refresh, color: Colors.white),
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
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'sim cards':
        return Icons.sim_card;
      case 'data packages':
        return Icons.data_usage;
      case 'voice packages':
        return Icons.phone;
      case 'devices':
        return Icons.phone_android;
      default:
        return Icons.inventory;
    }
  }

  void _showItemDetails(InventoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${item.category}'),
            Text('Current Stock: ${item.stock}'),
            Text('Minimum Stock: ${item.minStock}'),
            Text('Price: K${item.price.toStringAsFixed(2)}'),
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

  void _updateStock(InventoryItem item) {
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

  void _addNewItem() {
    NotificationService.showInAppNotification(
      context,
      title: 'Feature Coming Soon',
      message: 'Add new inventory item functionality will be available soon',
      type: NotificationType.info,
    );
  }

  void _showInventoryReport() {
    final lowStockItems = _inventory.where((item) => item.stock <= item.minStock).toList();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Inventory Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Items: ${_inventory.length}'),
            Text('Low Stock Items: ${lowStockItems.length}'),
            Text('Total Inventory Value: K${_inventory.fold<double>(0, (sum, item) => sum + (item.stock * item.price)).toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            if (lowStockItems.isNotEmpty) ...[
              const Text('Items Requiring Restock:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...lowStockItems.map((item) => Text('• ${item.name} (${item.stock} left)')),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _restockAlert() {
    final lowStockItems = _inventory.where((item) => item.stock <= item.minStock).toList();
    
    if (lowStockItems.isNotEmpty) {
      NotificationService.showInAppNotification(
        context,
        title: 'Restock Alert',
        message: '${lowStockItems.length} items need restocking',
        type: NotificationType.warning,
      );
    } else {
      NotificationService.showInAppNotification(
        context,
        title: 'Inventory Status',
        message: 'All items are adequately stocked',
        type: NotificationType.success,
      );
    }
  }
}

class InventoryItem {
  final int id;
  final String name;
  final String category;
  int stock;
  final int minStock;
  final double price;
  final String supplier;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.stock,
    required this.minStock,
    required this.price,
    required this.supplier,
  });
}