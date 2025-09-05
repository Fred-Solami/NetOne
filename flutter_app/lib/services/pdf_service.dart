import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../models/order.dart';
import '../models/user.dart';
import '../models/location.dart';

class PDFService {
  static Future<String> generateReceipt({
    required Map<String, dynamic> orderData,
    required List<Map<String, dynamic>> orderItems,
  }) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'NetOne Zambia',
                          style: pw.TextStyle(
                            fontSize: 28,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.orange800,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'E-RECEIPT',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey700,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Order #${orderData['id']}',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          'Receipt: ${orderData['receiptNumber']}',
                          style: pw.TextStyle(
                            fontSize: 14,
                            color: PdfColors.grey700,
                          ),
                        ),
                        pw.Text(
                          _formatDate(orderData['createdAt']),
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                pw.SizedBox(height: 32),
                pw.Divider(),
                pw.SizedBox(height: 24),

                // Customer Information
                pw.Text(
                  'CUSTOMER INFORMATION',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                  ),
                ),
                pw.SizedBox(height: 12),
                _buildInfoRow('Name', '${orderData['user']['first_name']} ${orderData['user']['last_name']}'),
                _buildInfoRow('Email', orderData['user']['email'] ?? 'Not provided'),
                _buildInfoRow('Phone', 'Contact via NetOne'),
                _buildInfoRow('Location', '${orderData['location']['latitude']}, ${orderData['location']['longitude']}'),
                
                pw.SizedBox(height: 24),

                // Order Items
                pw.Text(
                  'ORDER ITEMS',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                  ),
                ),
                pw.SizedBox(height: 12),
                
                // Items table header
                pw.Row(
                  children: [
                    pw.Expanded(flex: 3, child: pw.Text('Item', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Expanded(flex: 1, child: pw.Text('Qty', style: pw.TextStyle(fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
                    pw.Expanded(flex: 1, child: pw.Text('Price', style: pw.TextStyle(fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
                    pw.Expanded(flex: 1, child: pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Divider(),
                pw.SizedBox(height: 8),

                // Items
                ...orderItems.map((item) => _buildItemRow(
                  item['name'],
                  item['quantity'],
                  item['price'],
                  item['total'],
                )),

                pw.SizedBox(height: 24),
                pw.Divider(),
                pw.SizedBox(height: 16),

                // Payment Summary
                pw.Text(
                  'PAYMENT SUMMARY',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                  ),
                ),
                pw.SizedBox(height: 12),
                _buildInfoRow('Subtotal', 'K${orderData['subtotal'].toStringAsFixed(2)}'),
                _buildInfoRow('VAT (16%)', 'K${orderData['vat'].toStringAsFixed(2)}'),
                pw.SizedBox(height: 8),
                pw.Divider(thickness: 2),
                pw.SizedBox(height: 8),
                _buildTotalRow('TOTAL AMOUNT', 'K${orderData['total'].toStringAsFixed(2)}'),

                pw.SizedBox(height: 32),

                // Footer
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'Thank you for choosing NetOne Zambia!',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.orange800,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        'Empowering Businesses, Enabling Success',
                        style: pw.TextStyle(
                          fontSize: 14,
                          color: PdfColors.grey700,
                          fontStyle: pw.FontStyle.italic,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(height: 16),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        children: [
                          pw.Text('📞 +260 XXX XXX XXX', style: pw.TextStyle(fontSize: 10)),
                          pw.Text('🌐 netone.co.zm', style: pw.TextStyle(fontSize: 10)),
                          pw.Text('📧 info@netone.zm', style: pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );

      // Save PDF to device
      final directory = await getExternalStorageDirectory();
      final path = '${directory!.path}/NetOne_Receipt_${orderData['id']}.pdf';
      final file = File(path);
      await file.writeAsBytes(await pdf.save());

      return path;
    } catch (e) {
      print('Error generating PDF: $e');
      rethrow;
    }
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 12)),
          pw.Text(value, style: pw.TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  static pw.Widget _buildTotalRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.orange800,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.orange800,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildItemRow(String name, int quantity, double price, double total) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        children: [
          pw.Expanded(flex: 3, child: pw.Text(name, style: pw.TextStyle(fontSize: 12))),
          pw.Expanded(flex: 1, child: pw.Text('×$quantity', style: pw.TextStyle(fontSize: 12), textAlign: pw.TextAlign.center)),
          pw.Expanded(flex: 1, child: pw.Text('K${price.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 12), textAlign: pw.TextAlign.center)),
          pw.Expanded(flex: 1, child: pw.Text('K${total.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
        ],
      ),
    );
  }

  static String _formatDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      final now = DateTime.now();
      return '${now.day}/${now.month}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    }
  }

  // Share or print PDF
  static Future<void> shareOrPrintPDF(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      await Printing.sharePdf(bytes: bytes, filename: 'NetOne_Receipt.pdf');
    } catch (e) {
      print('Error sharing PDF: $e');
      rethrow;
    }
  }
}
