import 'package:bloc/bloc.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/models/wallet_model.dart';
import 'package:graduation_project_frontend/models/wallet_transaction_model.dart';
part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  final ApiConsumer api;

  SettingCubit(this.api) : super(SettingInitial());

  /// جلب رصيد المحفظة
  Future<void> getWalletBalance(String centerId) async {
    emit(SettingLoading());
    try {
      final response = await api.get(
        "https://graduation-project-mmih.vercel.app/api/wallet/getWallet/RadiologyCenter/$centerId",
      );

      print('Response: $response');
      print('Response type: ${response.runtimeType}');

      // استخراج البيانات من Response object
      dynamic responseData;
      if (response != null) {
        // إذا كان response من نوع Response (Dio أو http package)
        if (response.runtimeType.toString().contains('Response')) {
          responseData = response.data; // للـ Dio
          // أو يمكن أن يكون response.body للـ http package
        } else {
          responseData = response;
        }
      }

      print('Response Data: $responseData');
      print('Response Data type: ${responseData.runtimeType}');

      // التحقق من وجود البيانات
      if (responseData != null && responseData is Map<String, dynamic>) {
        print('Response is valid Map');

        // التحقق من وجود message للتأكد من نجاح العملية
        final message = responseData['message'];
        print('API Message: $message');

        final walletData = responseData['wallet'];
        print('Wallet Data: $walletData');
        print('Wallet Data type: ${walletData.runtimeType}');

        if (walletData != null && walletData is Map<String, dynamic>) {
          print('Wallet data is valid Map');
          print('Wallet balance from JSON: ${walletData['balance']}');

          try {
            final wallet = WalletModel.fromJson(walletData);

            emit(SettingWalletLoaded(wallet));
          } catch (modelError) {
            emit(SettingError('Error parsing wallet data: $modelError'));
          }
        } else {
          emit(SettingError('No valid wallet data found'));
        }
      } else {
        emit(SettingError('Invalid response format'));
      }
    } catch (e, stackTrace) {
      emit(SettingError(e.toString()));
    }
  }

  /// جلب سجل العمليات
  Future<void> getWalletHistory(String centerId) async {
    emit(SettingLoading());
    try {
      final response = await api.get(
        "https://graduation-project-mmih.vercel.app/api/wallet/wallet-history/$centerId?userType=RadiologyCenter",
      );
      // استخراج البيانات من Response object
      dynamic responseData;
      if (response != null) {
        if (response.runtimeType.toString().contains('Response')) {
          responseData = response.data;
        } else {
          responseData = response;
        }
      }

      if (responseData != null && responseData is Map<String, dynamic>) {
        final transactionsData = responseData['transactions'];

        if (transactionsData != null && transactionsData is List) {
          try {
            final transactions = List<WalletTransactionModel>.from(
              transactionsData.map((x) => WalletTransactionModel.fromJson(x)),
            );
            emit(WalletHistoryLoaded(transactions));
          } catch (modelError) {
            emit(SettingError('Error parsing transaction data: $modelError'));
          }
        } else {
          // إذا لم توجد معاملات، نرسل قائمة فارغة
          print('No transactions found, emitting empty list');
          emit(WalletHistoryLoaded([]));
        }
      } else {
        emit(SettingError('Invalid response format'));
      }
    } catch (e, stackTrace) {
      emit(SettingError(e.toString()));
    }
  }

  /// بدء عملية الدفع وإنشاء رابط الدفع
  Future<void> initiatePayment(String centerId, int amount) async {
    emit(SettingLoading());
    try {
      final response = await api.post(
        "https://graduation-project-mmih.vercel.app/api/payments/initiate",
        data: {
          "amountCents": amount * 100,
          "centerId": centerId,
          "billing_data": {
            "first_name": "Center",
            "last_name": "Test",
            "email": "test@example.com",
            "phone_number": "01000000000",
            "apartment": "1",
            "floor": "2",
            "street": "Test Street",
            "building": "12",
            "city": "Cairo",
            "country": "EG",
            "state": "Cairo",
          },
        },
      );

      // استخراج البيانات من Response object
      dynamic responseData;
      if (response != null) {
        if (response.runtimeType.toString().contains('Response')) {
          responseData = response.data;
        } else {
          responseData = response;
        }
      }

      if (responseData != null && responseData is Map<String, dynamic>) {
        final iframeURL = responseData['iframeURL'];
        final orderId = responseData['orderId'];

        if (iframeURL != null && orderId != null) {
          emit(PaymentInitiated(
            iframeURL: iframeURL,
            orderId: orderId,
          ));
        } else {
          emit(
              SettingError('Failed to initiate payment - missing payment URL'));
        }
        final req = await api.patch(
          "https://graduation-project-mmih.vercel.app/api/payments/confirm/$orderId",
          data: {},
        );
      } else {
        emit(SettingError('Invalid payment response'));
      }

      refreshWalletAfterPayment(centerId);
    } catch (e, stackTrace) {
      emit(SettingError(e.toString()));
    }
  }

  /// إعادة تحميل بيانات المحفظة بعد الدفع
  Future<void> refreshWalletAfterPayment(String centerId) async {
    print('Refreshing wallet after payment...');
    await getWalletBalance(centerId);
  }

  /// طريقة لاختبار البيانات الخام
  Future<void> testWalletDataParsing(String centerId) async {
    try {
      final response = await api.get(
        "https://graduation-project-mmih.vercel.app/api/wallet/getWallet/RadiologyCenter/$centerId",
      );
      // استخراج البيانات من Response object
      dynamic responseData;
      if (response != null) {
        if (response.runtimeType.toString().contains('Response')) {
          responseData = response.data;
        } else {
          responseData = response;
        }
      }

      if (responseData != null && responseData is Map<String, dynamic>) {
        final walletData = responseData['wallet'];
        if (walletData != null) {
          // اختبار إنشاء النموذج يدوياً
          try {
            final testWallet = WalletModel.fromJson(walletData);
          } catch (e) {}
        }
      }
    } catch (e) {}
  }
}
