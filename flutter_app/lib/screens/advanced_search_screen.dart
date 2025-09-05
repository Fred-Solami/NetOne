import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/order.dart';
import '../widgets/order_card.dart';

class AdvancedSearchScreen extends StatefulWidget {
  const AdvancedSearchScreen({super.key});

  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  final _searchController = TextEditingController();
  String _selectedStatus = 'All';
  double _minAmount = 0;
  double _maxAmount = 10000;
  DateTimeRange? _dateRange;
  List<Order> _filteredOrders = [];

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Search'),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search orders...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _applyFilters(),
                ),
                const SizedBox(height: 16),
                
                // Status Filter
                Row(
                  children: [
                    const Text('Status: '),
                    Expanded(
                      child: DropdownButton<String>(
                        value: _selectedStatus,
                        isExpanded: true,
                        items: ['All', 'Pending', 'Completed', 'Cancelled']
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value!;
                          });
                          _applyFilters();
                        },
                      ),
                    ),
                  ],
                ),
                
                // Amount Range
                const Text('Amount Range:'),
                RangeSlider(
                  values: RangeValues(_minAmount, _maxAmount),
                  min: 0,
                  max: 10000,
                  divisions: 100,
                  labels: RangeLabels(
                    'K${_minAmount.toStringAsFixed(0)}',
                    'K${_maxAmount.toStringAsFixed(0)}',
                  ),
                  onChanged: (values) {
                    setState(() {
                      _minAmount = values.start;
                      _maxAmount = values.end;
                    });
                    _applyFilters();
                  },
                ),
                
                // Date Range
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _selectDateRange,
                        icon: const Icon(Icons.date_range),
                        label: Text(_dateRange == null
                            ? 'Select Date Range'
                            : '${_dateRange!.start.day}/${_dateRange!.start.month} - ${_dateRange!.end.day}/${_dateRange!.end.month}'),
                      ),
                    ),
                    if (_dateRange != null)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _dateRange = null;
                          });
                          _applyFilters();
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
          
          // Results
          Expanded(
            child: _filteredOrders.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No orders found matching your criteria'),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredOrders.length,
                    itemBuilder: (context, index) {
                      return OrderCard(order: _filteredOrders[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final allOrders = provider.orders;
    
    setState(() {
      _filteredOrders = allOrders.where((order) {
        // Text search
        final searchTerm = _searchController.text.toLowerCase();
        final matchesSearch = searchTerm.isEmpty ||
            order.orderNumber?.toLowerCase().contains(searchTerm) == true ||
            order.description?.toLowerCase().contains(searchTerm) == true;
        
        // Status filter
        final matchesStatus = _selectedStatus == 'All' ||
            order.status?.toLowerCase() == _selectedStatus.toLowerCase();
        
        // Amount range
        final matchesAmount = order.amount >= _minAmount && order.amount <= _maxAmount;
        
        // Date range (simplified - would need proper date parsing in real app)
        final matchesDate = _dateRange == null; // Simplified for demo
        
        return matchesSearch && matchesStatus && matchesAmount && matchesDate;
      }).toList();
    });
  }

  void _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );
    
    if (picked != null) {
      setState(() {
        _dateRange = picked;
      });
      _applyFilters();
    }
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedStatus = 'All';
      _minAmount = 0;
      _maxAmount = 10000;
      _dateRange = null;
    });
    _applyFilters();
  }
}