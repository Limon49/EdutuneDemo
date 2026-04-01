import 'package:flutter/material.dart';

class Transaction {
  final String id;
  final String type;
  final double amount;
  final String receiver;
  final DateTime timestamp;
  final double balance;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.receiver,
    required this.timestamp,
    required this.balance,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'receiver': receiver,
      'timestamp': timestamp.toIso8601String(),
      'balance': balance,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: json['type'],
      amount: json['amount'].toDouble(),
      receiver: json['receiver'],
      timestamp: DateTime.parse(json['timestamp']),
      balance: json['balance'].toDouble(),
    );
  }
}

class UserModel {
  final String name;
  final String phoneNumber;
  final double balance;
  final int points;
  final String avatarText;
  final String? avatarImage;

  const UserModel({
    required this.name,
    required this.phoneNumber,
    required this.balance,
    required this.points,
    required this.avatarText,
    this.avatarImage,
  });
}

class ContactModel {
  final String name;
  final String number;
  final String type;

  const ContactModel({
    required this.name,
    required this.number,
    required this.type,
  });
}

class BankModel {
  final String name;
  final String branch;

  const BankModel({
    required this.name,
    required this.branch,
  });
}

class AppData {
  static const UserModel demoUser = UserModel(
    name: 'RAHUL',
    phoneNumber: '01701*****4',
    balance: 13999.00,
    points: 1972,
    avatarText: 'R',
  );

  static const List<ContactModel> recentContacts = [
    ContactModel(name: 'Samantha', number: '0987 3422 8756', type: 'Bank'),
    ContactModel(name: 'Rose Hope', number: '0987 3422 8756', type: 'Bank'),
  ];

  static const List<ContactModel> allContacts = [
    ContactModel(name: 'Andrea Summer', number: '0987 3422 8756', type: 'Bank'),
    ContactModel(name: 'Karen William', number: '0987 3422 8756', type: 'Bank'),
    ContactModel(name: 'Samantha', number: '0987 3422 8756', type: 'Bank'),
    ContactModel(name: 'Rose Hope', number: '0987 3422 8756', type: 'Bank'),
  ];

  static const List<BankModel> banks = [
    BankModel(name: 'Basic Bank', branch: 'Mirpur 11'),
    BankModel(name: 'Brak Bank', branch: 'Banani'),
    BankModel(name: 'Islamic Bank', branch: 'Gulshan 1'),
  ];
}
