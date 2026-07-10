import 'package:flutter/material.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/presentation/view/home_view/component/history_component.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TranzgooApiService _apiService = TranzgooApiService();
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _apiService.getTransactions(limit: 50);

      if (!mounted) {
        return;
      }

      setState(() {
        transactions = data;
      });
    } on ApiException catch (error) {
      setState(() {
        errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Unable to load transactions.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('History', style: AppText.extraBold),
      ),
      body: SafeArea(
        bottom: false,
        child: isLoading
            ? const AppLoadingState(message: 'Loading transactions...')
            : errorMessage != null
            ? AppErrorState(message: errorMessage!, onRetry: loadTransactions)
            : RefreshIndicator(
                onRefresh: loadTransactions,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: HistoryComponent(
                    transactions: transactions,
                    shrinkWrap: false,
                    physics: const AlwaysScrollableScrollPhysics(),
                  ),
                ),
              ),
      ),
    );
  }
}
