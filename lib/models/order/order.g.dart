// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

orders _$orderFromJson(Map<String, dynamic> json) => orders(
      address: json['address'] as String?,
      customer: json['customer'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      item: json['item'] as String?,
      phone: json['phone'] as num?,
      transactionId: json['transactionId'] as String?,
    );

Map<String, dynamic> _$orderToJson(orders instance) => <String, dynamic>{
      'address': instance.address,
      'customer': instance.customer,
      'item': instance.item,
      'phone': instance.phone,
      'price': instance.price,
      'transactionId': instance.transactionId,
    };
