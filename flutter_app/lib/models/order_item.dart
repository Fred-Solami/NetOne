class OrderItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  int quantity;

  OrderItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.quantity = 0,
  });

  double get total => price * quantity;

  static List<OrderItem> getNetOneItems() {
    return [
      // Data Packages
      OrderItem(
        id: 'data_1gb',
        name: '1GB Data Bundle',
        description: 'Valid for 30 days',
        price: 25.00,
        category: 'Data',
      ),
      OrderItem(
        id: 'data_5gb',
        name: '5GB Data Bundle',
        description: 'Valid for 30 days',
        price: 100.00,
        category: 'Data',
      ),
      OrderItem(
        id: 'data_10gb',
        name: '10GB Data Bundle',
        description: 'Valid for 30 days',
        price: 180.00,
        category: 'Data',
      ),
      OrderItem(
        id: 'data_20gb',
        name: '20GB Data Bundle',
        description: 'Valid for 30 days',
        price: 320.00,
        category: 'Data',
      ),
      
      // Voice Packages
      OrderItem(
        id: 'voice_minutes_100',
        name: '100 Minutes',
        description: 'Voice minutes to any network',
        price: 50.00,
        category: 'Voice',
      ),
      OrderItem(
        id: 'voice_minutes_300',
        name: '300 Minutes',
        description: 'Voice minutes to any network',
        price: 120.00,
        category: 'Voice',
      ),
      OrderItem(
        id: 'voice_minutes_600',
        name: '600 Minutes',
        description: 'Voice minutes to any network',
        price: 200.00,
        category: 'Voice',
      ),
      
      // SMS Packages
      OrderItem(
        id: 'sms_100',
        name: '100 SMS Bundle',
        description: 'SMS to any network',
        price: 15.00,
        category: 'SMS',
      ),
      OrderItem(
        id: 'sms_500',
        name: '500 SMS Bundle',
        description: 'SMS to any network',
        price: 60.00,
        category: 'SMS',
      ),
      
      // Combo Packages
      OrderItem(
        id: 'combo_starter',
        name: 'Starter Combo',
        description: '2GB + 50 Minutes + 50 SMS',
        price: 80.00,
        category: 'Combo',
      ),
      OrderItem(
        id: 'combo_premium',
        name: 'Premium Combo',
        description: '10GB + 200 Minutes + 200 SMS',
        price: 350.00,
        category: 'Combo',
      ),
    ];
  }
}
