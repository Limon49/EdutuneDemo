import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/models.dart';

// Transaction States (keeping same structure as BLoC for UI compatibility)
abstract class TransactionState {
  bool get isLoading;
  String? get errorMessage;
}

class TransactionInitial extends TransactionState {
  @override
  bool get isLoading => false;
  @override
  String? get errorMessage => null;
}

class TransactionLoading extends TransactionState {
  @override
  bool get isLoading => true;
  @override
  String? get errorMessage => null;
}

class CashOutSuccess extends TransactionState {
  final double amount;
  final double newBalance;
  CashOutSuccess({required this.amount, required this.newBalance});
  
  @override
  bool get isLoading => false;
  @override
  String? get errorMessage => null;
}

class SendMoneySuccess extends TransactionState {
  final double amount;
  final double newBalance;
  SendMoneySuccess({required this.amount, required this.newBalance});
  
  @override
  bool get isLoading => false;
  @override
  String? get errorMessage => null;
}

class TransactionError extends TransactionState {
  final String message;
  TransactionError({required this.message});
  
  @override
  bool get isLoading => false;
  @override
  String? get errorMessage => message;
}

// Transaction Events (keeping same structure as BLoC for UI compatibility)
abstract class TransactionEvent {
  const TransactionEvent();
}

class CashOutRequested extends TransactionEvent {
  final String agentNumber;
  final double amount;
  CashOutRequested({required this.agentNumber, required this.amount});
}

class SendMoneyRequested extends TransactionEvent {
  final String contactNumber;
  final double amount;
  SendMoneyRequested({required this.contactNumber, required this.amount});
}

class ResetTransaction extends TransactionEvent {
  const ResetTransaction();
}

// GetX TransactionController with BLoC compatibility
class TransactionController extends GetxController {
  final GetStorage _storage = GetStorage();
  
  // Internal state
  double _balance = 13999.00;
  var transactions = <Transaction>[].obs;
  
  // Reactive state
  final transactionState = Rx<TransactionState>(TransactionInitial());
  
  // Getters for current state
  TransactionState get state => transactionState.value;
  bool get isLoading => transactionState.value.isLoading;
  String? get errorMessage => transactionState.value.errorMessage;
  double get currentBalance => _balance;
  
  @override
  void onInit() {
    super.onInit();
    _loadBalance();
    _loadTransactions();
  }
  
  void _loadBalance() {
    final savedBalance = _storage.read('balance');
    if (savedBalance != null) {
      _balance = savedBalance;
    }
  }
  
  void _saveBalance() {
    _storage.write('balance', _balance);
  }
  
  void _loadTransactions() {
    final savedTransactions = _storage.read('transactions');
    if (savedTransactions != null) {
      transactions.value = List<Transaction>.from(
        savedTransactions.map((item) => Transaction.fromJson(item))
      );
    }
  }
  
  void _saveTransactions() {
    _storage.write('transactions', transactions.map((t) => t.toJson()).toList());
  }
  
  // BLoC-like add method for UI compatibility
  void add(TransactionEvent event) {
    if (event is CashOutRequested) {
      _onCashOutRequested(event);
    } else if (event is SendMoneyRequested) {
      _onSendMoneyRequested(event);
    } else if (event is ResetTransaction) {
      _onReset();
    }
  }

  Future<void> _onCashOutRequested(CashOutRequested event) async {
    transactionState.value = TransactionLoading();
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      if (event.amount > _balance) {
        transactionState.value = TransactionError(message: 'Insufficient balance');
        return;
      }
      
      if (event.agentNumber.length < 11) {
        transactionState.value = TransactionError(message: 'Invalid agent number');
        return;
      }
      
      _balance -= event.amount;
      _saveBalance();
      
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'Cash Out',
        amount: event.amount,
        receiver: event.agentNumber,
        timestamp: DateTime.now(),
        balance: _balance,
      );
      
      transactions.add(transaction);
      _saveTransactions();
      
      transactionState.value = CashOutSuccess(
        amount: event.amount,
        newBalance: _balance,
      );
      
    } catch (e) {
      transactionState.value = TransactionError(message: 'Cash out failed: ${e.toString()}');
    }
  }

  Future<void> _onSendMoneyRequested(SendMoneyRequested event) async {
    transactionState.value = TransactionLoading();
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      if (event.amount > _balance) {
        transactionState.value = TransactionError(message: 'Insufficient balance');
        return;
      }
      
      if (event.contactNumber.length < 11) {
        transactionState.value = TransactionError(message: 'Invalid contact number');
        return;
      }
      
      _balance -= event.amount;
      _saveBalance();
      
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'Send Money',
        amount: event.amount,
        receiver: event.contactNumber,
        timestamp: DateTime.now(),
        balance: _balance,
      );
      
      transactions.add(transaction);
      _saveTransactions();
      
      transactionState.value = SendMoneySuccess(
        amount: event.amount,
        newBalance: _balance,
      );
      
    } catch (e) {
      transactionState.value = TransactionError(message: 'Send money failed: ${e.toString()}');
    }
  }

  void _onReset() {
    transactionState.value = TransactionInitial();
  }
  
  // Convenience methods
  Future<void> cashOut(String agentNumber, double amount) async {
    add(CashOutRequested(agentNumber: agentNumber, amount: amount));
  }
  
  Future<void> sendMoney(String contactNumber, double amount) async {
    add(SendMoneyRequested(contactNumber: contactNumber, amount: amount));
  }
  
  Future<void> addMoney(double amount) async {
    try {
      transactionState.value = TransactionLoading();
      
      await Future.delayed(const Duration(seconds: 1));
      
      _balance += amount;
      _saveBalance();
      
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'Add Money',
        amount: amount,
        receiver: 'Self',
        timestamp: DateTime.now(),
        balance: _balance,
      );
      
      transactions.add(transaction);
      _saveTransactions();
      
      transactionState.value = TransactionInitial();
      
    } catch (e) {
      transactionState.value = TransactionInitial();
    }
  }
  
  List<Transaction> getTransactionsByType(String type) {
    return transactions.where((t) => t.type == type).toList();
  }
  
  List<Transaction> getRecentTransactions({int limit = 10}) {
    final sorted = List<Transaction>.from(transactions);
    sorted.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted.take(limit).toList();
  }
}
