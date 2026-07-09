import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/presentation/view/services/service_form_widgets.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/app_textfield.dart';

class SendView extends StatefulWidget {
  const SendView({Key? key}) : super(key: key);

  @override
  State<SendView> createState() => _SendViewState();
}

class _SendViewState extends State<SendView> {
  final TranzgooApiService _apiService = TranzgooApiService();
  final TextEditingController tranzgoId = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController note = TextEditingController();
  Map<String, dynamic>? receiver;
  String? resultMessage;
  bool isLookingUp = false;
  bool isSending = false;

  @override
  void dispose() {
    tranzgoId.dispose();
    amount.dispose();
    note.dispose();
    super.dispose();
  }

  Future<void> lookupReceiver() async {
    if (tranzgoId.text.trim().isEmpty) {
      showMessage('Please enter a TranzGOO ID.');
      return;
    }

    setState(() {
      isLookingUp = true;
      receiver = null;
      resultMessage = null;
    });

    try {
      final data = await _apiService.lookupUser(tranzgoId.text);

      if (!mounted) {
        return;
      }

      setState(() {
        receiver = data;
      });
    } on ApiException catch (error) {
      showMessage(error.message);
    } catch (_) {
      showMessage('Unable to look up receiver.');
    } finally {
      if (mounted) {
        setState(() {
          isLookingUp = false;
        });
      }
    }
  }

  Future<void> sendMoney() async {
    if (tranzgoId.text.trim().isEmpty || amount.text.trim().isEmpty) {
      showMessage('Please enter receiver ID and amount.');
      return;
    }

    setState(() {
      isSending = true;
      resultMessage = null;
    });

    try {
      final result = await _apiService.transfer(
        receiverTranzgoId: tranzgoId.text,
        amount: amount.text,
        note: note.text,
      );
      final wallet = result['wallet'];
      final balance = wallet is Map ? wallet['balance']?.toString() : null;

      if (!mounted) {
        return;
      }

      setState(() {
        resultMessage = balance == null
            ? 'Transfer successful.'
            : 'Transfer successful. New balance: NGN $balance';
      });
      showMessage('Transfer successful.');
    } on ApiException catch (error) {
      showMessage(error.message);
    } catch (_) {
      showMessage('Unable to complete transfer.');
    } finally {
      if (mounted) {
        setState(() {
          isSending = false;
        });
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Send',
                style: AppText.extraBold.copyWith(
                  fontSize: 16,
                  letterSpacing: 0.09,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Transfer funds to another user on \nTranzGOO.',
                textAlign: TextAlign.center,
                style: AppText.regularStyle.copyWith(letterSpacing: 0.09),
              ),
              const SizedBox(height: 8),
              Text(
                'TranzGOO ID',
                style:
                    AppText.extraBold.copyWith(color: AppColors.primaryColor),
              ),
              const SizedBox(height: 5),
              AppTextField(
                controller: tranzgoId,
                textCenter: true,
                hintText: '* * * * * *',
                width: 254.w,
              ),
              AppButton(
                onPressed: lookupReceiver,
                label: 'Check ID',
                isText: true,
                isLoading: isLookingUp,
                width: 254.w,
              ),
              const SizedBox(height: 12),
              if (receiver != null)
                ServiceResultCard(
                  title: 'Receiver',
                  lines: [
                    '${receiver!['fullName'] ?? ''}',
                    'ID: ${receiver!['tranzgoId'] ?? ''}',
                  ],
                ),
              Text(
                'Amount',
                style:
                    AppText.extraBold.copyWith(color: AppColors.primaryColor),
              ),
              const SizedBox(height: 5),
              AppTextField(
                textCenter: true,
                controller: amount,
                hintText: '0.00',
                keyboardType: TextInputType.number,
                width: 254.w,
              ),
              AppTextField(
                controller: note,
                hintText: 'Note (optional)',
                width: 254.w,
              ),
              if (resultMessage != null)
                ServiceResultCard(
                  title: 'Completed',
                  lines: [resultMessage!],
                ),
              const SizedBox(height: 20),
              AppButton(
                onPressed: sendMoney,
                label: 'Send',
                isText: true,
                isLoading: isSending,
              )
            ],
          ),
        ),
      ),
    );
  }
}
