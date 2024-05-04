import 'package:json_annotation/json_annotation.dart';
part 'order.g.dart';

@JsonSerializable()
class orders {
  @JsonKey(name: "address")
  String? address;

  @JsonKey(name: "customer")
  String? customer;

  @JsonKey(name: "item")
  String? item;

  @JsonKey(name: "phone")
  num? phone;

  @JsonKey(name: "price")
  num? price;

  @JsonKey(name: "transactionId")
  String? transactionId;

  orders(
      {this.address,
        this.customer,
        this.price,
        this.item,
        this.phone,
        this.transactionId,
      });

  factory orders.fromJson(Map<String, dynamic> json) =>
      _$orderFromJson(json);

  Map<String, dynamic> toJson() => _$orderToJson(this);
}
