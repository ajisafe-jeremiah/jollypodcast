import 'package:equatable/equatable.dart';
import 'subscription_details.dart';

class Subscription extends Equatable {
  final int? id;
  final int? userId;
  final String? userIdString;
  final String? effectiveTime;
  final String? expiryTime;
  final String? updateTime;
  final String? isOTC;
  final String? productId;
  final String? serviceId;
  final String? spId;
  final String? statusCode;
  final String? chargeMode;
  final String? chargeNumber;
  final String? referenceId;
  final SubscriptionDetails? details;
  final String? createdAt;
  final String? updatedAt;

  const Subscription({
    this.id,
    this.userId,
    this.userIdString,
    this.effectiveTime,
    this.expiryTime,
    this.updateTime,
    this.isOTC,
    this.productId,
    this.serviceId,
    this.spId,
    this.statusCode,
    this.chargeMode,
    this.chargeNumber,
    this.referenceId,
    this.details,
    this.createdAt,
    this.updatedAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      userId: json['user_id'],
      userIdString: json['userId'],
      effectiveTime: json['effectiveTime'],
      expiryTime: json['expiryTime'],
      updateTime: json['updateTime'],
      isOTC: json['isOTC'],
      productId: json['productId'],
      serviceId: json['serviceId'],
      spId: json['spId'],
      statusCode: json['statusCode'],
      chargeMode: json['chargeMode'],
      chargeNumber: json['chargeNumber'],
      referenceId: json['referenceId'],
      details: json['details'] != null
          ? SubscriptionDetails.fromJson(json['details'])
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (userIdString != null) 'userId': userIdString,
      if (effectiveTime != null) 'effectiveTime': effectiveTime,
      if (expiryTime != null) 'expiryTime': expiryTime,
      if (updateTime != null) 'updateTime': updateTime,
      if (isOTC != null) 'isOTC': isOTC,
      if (productId != null) 'productId': productId,
      if (serviceId != null) 'serviceId': serviceId,
      if (spId != null) 'spId': spId,
      if (statusCode != null) 'statusCode': statusCode,
      if (chargeMode != null) 'chargeMode': chargeMode,
      if (chargeNumber != null) 'chargeNumber': chargeNumber,
      if (referenceId != null) 'referenceId': referenceId,
      if (details != null) 'details': details?.toJson(),
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }

  Subscription copyWith({
    int? id,
    int? userId,
    String? userIdString,
    String? effectiveTime,
    String? expiryTime,
    String? updateTime,
    String? isOTC,
    String? productId,
    String? serviceId,
    String? spId,
    String? statusCode,
    String? chargeMode,
    String? chargeNumber,
    String? referenceId,
    SubscriptionDetails? details,
    String? createdAt,
    String? updatedAt,
  }) {
    return Subscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userIdString: userIdString ?? this.userIdString,
      effectiveTime: effectiveTime ?? this.effectiveTime,
      expiryTime: expiryTime ?? this.expiryTime,
      updateTime: updateTime ?? this.updateTime,
      isOTC: isOTC ?? this.isOTC,
      productId: productId ?? this.productId,
      serviceId: serviceId ?? this.serviceId,
      spId: spId ?? this.spId,
      statusCode: statusCode ?? this.statusCode,
      chargeMode: chargeMode ?? this.chargeMode,
      chargeNumber: chargeNumber ?? this.chargeNumber,
      referenceId: referenceId ?? this.referenceId,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isActive => statusCode == 'stActive';
  bool get isEmpty => this == Subscription.empty;
  bool get isNotEmpty => this != Subscription.empty;

  static const empty = Subscription();

  @override
  List<Object?> get props => [
    id,
    userId,
    userIdString,
    effectiveTime,
    expiryTime,
    updateTime,
    isOTC,
    productId,
    serviceId,
    spId,
    statusCode,
    chargeMode,
    chargeNumber,
    referenceId,
    details,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'Subscription('
        'id: $id, '
        'userId: $userId, '
        'statusCode: $statusCode, '
        'effectiveTime: $effectiveTime, '
        'expiryTime: $expiryTime, '
        'details: $details)';
  }
}
