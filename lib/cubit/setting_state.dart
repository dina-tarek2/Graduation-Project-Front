



part of 'setting_cubit.dart';
abstract class SettingState {}

class SettingInitial extends SettingState {}

class SettingLoading extends SettingState {}
class SettingLoaded extends SettingState {

}

class SettingWalletLoaded extends SettingState {
  final WalletModel wallet;
  SettingWalletLoaded(this.wallet);
}

class SettingError extends SettingState {
  final String message;
  SettingError(this.message);
}

class WalletHistoryLoaded extends SettingState {
  final List<WalletTransactionModel> transactions;
  WalletHistoryLoaded(this.transactions);
}

// إضافة حالة جديدة للدفع
class PaymentInitiated extends SettingState {
  final String iframeURL;
  final int orderId;

  PaymentInitiated({
    required this.iframeURL,
    required this.orderId,
  });
}

