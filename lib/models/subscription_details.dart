import 'package:equatable/equatable.dart';

class SubscriptionDetails extends Equatable {
  final int? id;
  final String? code;
  final String? title;
  final int? amount;
  final String? createdAt;
  final String? updatedAt;

  const SubscriptionDetails({
    this.id,
    this.code,
    this.title,
    this.amount,
    this.createdAt,
    this.updatedAt,
  });

  factory SubscriptionDetails.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetails(
      id: json['id'],
      code: json['code'],
      title: json['title'],
      amount: json['amount'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }

  SubscriptionDetails copyWith({
    int? id,
    String? code,
    String? title,
    int? amount,
    String? createdAt,
    String? updatedAt,
  }) {
    return SubscriptionDetails(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        code,
        title,
        amount,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'SubscriptionDetails('
        'id: $id, '
        'code: $code, '
        'title: $title, '
        'amount: $amount)';
  }
}