import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/pdf_service.dart';
import '../models/order.dart';
import '../models/user.dart';
import '../models/location.dart';
import '../services/pdf_service.dart';

class ReceiptWidget extends StatelessWidget {
  final Order order;
  final User user;
  final Location location;
  final List<Map<String, dynamic>> orderItems;

  const ReceiptWidget({
    super.key,
    required this.order,
    required this.user,
    required this.location,
    required this.orderItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with NetOne Logo
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(
                    'assets/images/netone_logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.business,
                        size: 24,
                        color: Color(0xFFFF6B35),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NetOne Zambia',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6B35),
                        ),
                      ),
                      const Text(
                        'E-RECEIPT',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Order #${order.id.toString().length > 8 ? order.id.toString().substring(0, 8) : order.id}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _formatDate(order.createdAt ?? DateTime.now().toIso8601String()),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Customer Information
            _buildSection(
              'CUSTOMER INFORMATION',
              [
                _buildInfoRow('Name', '${user.firstName} ${user.lastName}'),
                _buildInfoRow('Email', user.email ?? 'Not provided'),
                _buildInfoRow('Phone', 'Contact via NetOne'),
                _buildInfoRow('Location', '${location.latitude}, ${location.longitude}'),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Order Items
            _buildSection(
              'ORDER ITEMS',
              [
                ...orderItems.map((item) => _buildItemRow(
                  item['name'],
                  item['quantity'],
                  item['price'],
                  item['total'],
                )),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Payment Summary
            _buildSection(
              'PAYMENT SUMMARY',
              [
                _buildInfoRow('Subtotal', 'K${(order.calculatedTotalAmount / 1.16).toStringAsFixed(2)}'),
                _buildInfoRow('VAT (16%)', 'K${(order.calculatedTotalAmount * 0.16 / 1.16).toStringAsFixed(2)}'),
                const Divider(thickness: 2),
                _buildInfoRow(
                  'TOTAL AMOUNT',
                  'K${order.calculatedTotalAmount.toStringAsFixed(2)}',
                  isTotal: true,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    'Thank you for choosing NetOne Zambia!',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B35),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Empowering Businesses, Enabling Success',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(child: _buildContactInfo('📞', '+260 XXX XXX XXX')),
                      Flexible(child: _buildContactInfo('🌐', 'netone.co.zm')),
                      Flexible(child: _buildContactInfo('📧', 'info@netone.zm')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
  
  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: isTotal ? 15 : 13,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal ? const Color(0xFFFF6B35) : Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontSize: isTotal ? 15 : 13,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal ? const Color(0xFFFF6B35) : Colors.black87,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: isTotal ? 1 : 2,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildItemRow(String name, int quantity, double price, double total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 1,
            child: Text(
              '×$quantity',
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'K${price.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'K${total.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactInfo(String icon, String info) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 2),
        Text(
          info,
          style: const TextStyle(fontSize: 9, color: Colors.grey),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
  
  String _formatDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      final now = DateTime.now();
      return '${now.day}/${now.month}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    }
  }
}

class ReceiptDialog extends StatelessWidget {
  final Order order;
  final User user;
  final Location location;
  final List<Map<String, dynamic>> orderItems;

  const ReceiptDialog({
    super.key,
    required this.order,
    required this.user,
    required this.location,
    required this.orderItems,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenWidth - 40, // Account for inset padding
          maxHeight: screenHeight - 120, // Leave more space for system UI
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Receipt content in scrollable area
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                  child: ReceiptWidget(
                    order: order,
                    user: user,
                    location: location,
                    orderItems: orderItems,
                  ),
                ),
              ),
              // Fixed bottom buttons
              Container(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _copyReceipt(context),
                        icon: const Icon(Icons.copy, size: 18),
                        label: const Text('Copy', style: TextStyle(fontSize: 14)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text('Close', style: TextStyle(fontSize: 14)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _copyReceipt(BuildContext context) {
    final receiptText = '''
═══════════════════════════════════
        NETONE ZAMBIA E-RECEIPT
═══════════════════════════════════

Order #: ${order.id}
Date: ${_formatDate(order.createdAt ?? DateTime.now().toIso8601String())}

CUSTOMER INFORMATION:
Name: ${user.firstName} ${user.lastName}
Email: ${user.email ?? 'Not provided'}
Phone: Contact via NetOne
Location: ${location.latitude}, ${location.longitude}

ORDER ITEMS:
${orderItems.map((item) => '${item['name']} × ${item['quantity']} - K${item['total'].toStringAsFixed(2)}').join('\n')}

PAYMENT SUMMARY:
Subtotal: K${(order.calculatedTotalAmount / 1.16).toStringAsFixed(2)}
VAT (16%): K${(order.calculatedTotalAmount * 0.16 / 1.16).toStringAsFixed(2)}
TOTAL: K${order.calculatedTotalAmount.toStringAsFixed(2)}

═══════════════════════════════════
Thank you for choosing NetOne Zambia!
Empowering Businesses, Enabling Success
═══════════════════════════════════
''';

    Clipboard.setData(ClipboardData(text: receiptText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Receipt copied to clipboard!'),
        backgroundColor: Color(0xFFFF6B35),
      ),
    );
  }

  String _formatDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      final now = DateTime.now();
      return '${now.day}/${now.month}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    }
  }
}

// Enhanced Receipt Dialog with PDF Download
class EnhancedReceiptDialog extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final List<Map<String, dynamic>> orderItems;

  const EnhancedReceiptDialog({
    super.key,
    required this.orderData,
    required this.orderItems,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenWidth - 40,
          maxHeight: screenHeight - 120,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Receipt content in scrollable area
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                  child: _buildReceiptContent(),
                ),
              ),
              // Enhanced bottom buttons with PDF download
              Container(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _downloadPDF(context),
                            icon: const Icon(Icons.download, size: 18),
                            label: const Text('Download PDF', style: TextStyle(fontSize: 14)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6B35),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _copyReceipt(context),
                            icon: const Icon(Icons.copy, size: 18),
                            label: const Text('Copy', style: TextStyle(fontSize: 14)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text('Close', style: TextStyle(fontSize: 14)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptContent() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with NetOne Logo
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(
                    'assets/images/netone_logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.business,
                        size: 24,
                        color: Color(0xFFFF6B35),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NetOne Zambia',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6B35),
                        ),
                      ),
                      const Text(
                        'E-RECEIPT',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Order #${orderData['id']}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Receipt: ${orderData['receiptNumber']}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _formatDate(orderData['createdAt']),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Customer Information
            _buildSection(
              'CUSTOMER INFORMATION',
              [
                _buildInfoRow('Name', '${orderData['user']['first_name']} ${orderData['user']['last_name']}'),
                _buildInfoRow('Email', orderData['user']['email'] ?? 'Not provided'),
                _buildInfoRow('Phone', 'Contact via NetOne'),
                _buildInfoRow('Location', '${orderData['location']['latitude']}, ${orderData['location']['longitude']}'),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Order Items
            _buildSection(
              'ORDER ITEMS',
              [
                ...orderItems.map((item) => _buildItemRow(
                  item['name'],
                  item['quantity'],
                  item['price'],
                  item['total'],
                )),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Payment Summary
            _buildSection(
              'PAYMENT SUMMARY',
              [
                _buildInfoRow('Subtotal', 'K${orderData['subtotal'].toStringAsFixed(2)}'),
                _buildInfoRow('VAT (16%)', 'K${orderData['vat'].toStringAsFixed(2)}'),
                const Divider(thickness: 2),
                _buildInfoRow(
                  'TOTAL AMOUNT',
                  'K${orderData['total'].toStringAsFixed(2)}',
                  isTotal: true,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    'Thank you for choosing NetOne Zambia!',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B35),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Empowering Businesses, Enabling Success',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(child: _buildContactInfo('📞', '+260 XXX XXX XXX')),
                      Flexible(child: _buildContactInfo('🌐', 'netone.co.zm')),
                      Flexible(child: _buildContactInfo('📧', 'info@netone.zm')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
  
  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: isTotal ? 15 : 13,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal ? const Color(0xFFFF6B35) : Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontSize: isTotal ? 15 : 13,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal ? const Color(0xFFFF6B35) : Colors.black87,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: isTotal ? 1 : 2,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildItemRow(String name, int quantity, double price, double total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            flex: 1,
            child: Text(
              '×$quantity',
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'K${price.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'K${total.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactInfo(String icon, String info) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 2),
        Text(
          info,
          style: const TextStyle(fontSize: 9, color: Colors.grey),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Future<void> _downloadPDF(BuildContext context) async {
    try {
      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Generating PDF receipt...'),
          backgroundColor: Color(0xFFFF6B35),
        ),
      );

      // Generate PDF
      final filePath = await PDFService.generateReceipt(
        orderData: orderData,
        orderItems: orderItems,
      );

      // Share/Save PDF
      await PDFService.shareOrPrintPDF(filePath);

      // Success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF receipt generated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _copyReceipt(BuildContext context) {
    final receiptText = '''
═══════════════════════════════════
        NETONE ZAMBIA E-RECEIPT
═══════════════════════════════════

Order #: ${orderData['id']}
Receipt: ${orderData['receiptNumber']}
Date: ${_formatDate(orderData['createdAt'])}

CUSTOMER INFORMATION:
Name: ${orderData['user']['first_name']} ${orderData['user']['last_name']}
Email: ${orderData['user']['email'] ?? 'Not provided'}
Phone: Contact via NetOne
Location: ${orderData['location']['latitude']}, ${orderData['location']['longitude']}

ORDER ITEMS:
${orderItems.map((item) => '${item['name']} × ${item['quantity']} - K${item['total'].toStringAsFixed(2)}').join('\n')}

PAYMENT SUMMARY:
Subtotal: K${orderData['subtotal'].toStringAsFixed(2)}
VAT (16%): K${orderData['vat'].toStringAsFixed(2)}
TOTAL: K${orderData['total'].toStringAsFixed(2)}

═══════════════════════════════════
Thank you for choosing NetOne Zambia!
Empowering Businesses, Enabling Success
═══════════════════════════════════
''';

    Clipboard.setData(ClipboardData(text: receiptText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Receipt copied to clipboard!'),
        backgroundColor: Color(0xFFFF6B35),
      ),
    );
  }

  String _formatDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      final now = DateTime.now();
      return '${now.day}/${now.month}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    }
  }
}
