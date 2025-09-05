import 'package:json_annotation/json_annotation.dart';
import 'user.dart';
import 'location.dart' as app_models;

part 'order.g.dart';

@JsonSerializable()
class Order {
  final int? id;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'location_id')
  final int locationId;
  @JsonKey(name: 'order_number')
  final String? orderNumber;
  final double amount;
  @JsonKey(name: 'vat_rate')
  final double vatRate;
  @JsonKey(name: 'vat_amount')
  final double? vatAmount;
  @JsonKey(name: 'total_amount')
  final double? totalAmount;
  final String? status;
  final String? description;
  final User? user;
  final app_models.Location? location;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Order({
    this.id,
    required this.userId,
    required this.locationId,
    this.orderNumber,
    required this.amount,
    this.vatRate = 16.0,
    this.vatAmount,
    this.totalAmount,
    this.status,
    this.description,
    this.user,
    this.location,
    this.createdAt,
    this.updatedAt,
  });

  double get calculatedVatAmount => (amount * vatRate) / 100;
  double get calculatedTotalAmount => amount + calculatedVatAmount;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}