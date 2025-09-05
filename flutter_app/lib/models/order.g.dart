// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['user_id'] as num).toInt(),
  locationId: (json['location_id'] as num).toInt(),
  orderNumber: json['order_number'] as String?,
  amount: (json['amount'] as num).toDouble(),
  vatRate: (json['vat_rate'] as num?)?.toDouble() ?? 16.0,
  vatAmount: (json['vat_amount'] as num?)?.toDouble(),
  totalAmount: (json['total_amount'] as num?)?.toDouble(),
  status: json['status'] as String?,
  description: json['description'] as String?,
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
  location: json['location'] == null
      ? null
      : app_models.Location.fromJson(json['location'] as Map<String, dynamic>),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'location_id': instance.locationId,
  'order_number': instance.orderNumber,
  'amount': instance.amount,
  'vat_rate': instance.vatRate,
  'vat_amount': instance.vatAmount,
  'total_amount': instance.totalAmount,
  'status': instance.status,
  'description': instance.description,
  'user': instance.user,
  'location': instance.location,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
