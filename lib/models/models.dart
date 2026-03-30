import 'package:flutter/material.dart';

class UserModel {
  final String name;
  final String phoneNumber;
  final double balance;
  final int points;
  final String avatarText;

  const UserModel({
    required this.name,
    required this.phoneNumber,
    required this.balance,
    required this.points,
    required this.avatarText,
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
