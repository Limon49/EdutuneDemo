import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/models.dart';

// Events
abstract class TransactionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CashOutRequested extends TransactionEvent {
  final String agentNumber;
  final double amount;
  CashOutRequested({required this.agentNumber, required this.amount});
  @override
  List<Object?> get props => [agentNumber, amount];
}

class SendMoneyRequested extends TransactionEvent {
  final String contactNumber;
  final double amount;
  SendMoneyRequested({required this.contactNumber, required this.amount});
  @override
  List<Object?> get props => [contactNumber, amount];
}

class ResetTransaction extends TransactionEvent {}

// States
abstract class TransactionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class CashOutSuccess extends TransactionState {
  final double amount;
  final double newBalance;
  CashOutSuccess({required this.amount, required this.newBalance});
  @override
  List<Object?> get props => [amount, newBalance];
}

class SendMoneySuccess extends TransactionState {
  final double amount;
  final double newBalance;
  SendMoneySuccess({required this.amount, required this.newBalance});
  @override
  List<Object?> get props => [amount, newBalance];
}

class TransactionError extends TransactionState {
  final String message;
  TransactionError({required this.message});
  @override
  List<Object?> get props => [message];
}

// BLoC
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  double _balance = 13999.00;

  TransactionBloc() : super(TransactionInitial()) {
    on<CashOutRequested>(_onCashOutRequested);
    on<SendMoneyRequested>(_onSendMoneyRequested);
    on<ResetTransaction>(_onReset);
  }

  Future<void> _onCashOutRequested(
    CashOutRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    await Future.delayed(const Duration(seconds: 1));
    if (event.amount > _balance) {
      emit(TransactionError(message: 'Insufficient balance'));
    } else {
      _balance -= event.amount;
      emit(CashOutSuccess(amount: event.amount, newBalance: _balance));
    }
  }

  Future<void> _onSendMoneyRequested(
    SendMoneyRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    await Future.delayed(const Duration(seconds: 1));
    if (event.amount > _balance) {
      emit(TransactionError(message: 'Insufficient balance'));
    } else {
      _balance -= event.amount;
      emit(SendMoneySuccess(amount: event.amount, newBalance: _balance));
    }
  }

  void _onReset(ResetTransaction event, Emitter<TransactionState> emit) {
    emit(TransactionInitial());
  }

  double get currentBalance => _balance;
}
