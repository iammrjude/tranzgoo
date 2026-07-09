import 'package:flutter/material.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';

class LegalScreen extends StatefulWidget {
  const LegalScreen({Key? key}) : super(key: key);

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  final TranzgooApiService _apiService = TranzgooApiService();
  List<Map<String, dynamic>> documents = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadDocuments();
  }

  Future<void> loadDocuments() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _apiService.getLegalDocuments();

      if (!mounted) {
        return;
      }

      setState(() {
        documents = data;
      });
    } on ApiException catch (error) {
      setState(() {
        errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Unable to load legal documents.';
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
        title: const Text('Legal', style: AppText.extraBold),
      ),
      body: SafeArea(
        bottom: false,
        child: isLoading
            ? const AppLoadingState(message: 'Loading legal documents...')
            : errorMessage != null
                ? AppErrorState(
                    message: errorMessage!,
                    onRetry: loadDocuments,
                  )
                : RefreshIndicator(
                    onRefresh: loadDocuments,
                    color: AppColors.primaryColor,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                      children: [
                        appSectionTitle('Legal Documents'),
                        const SizedBox(height: 8),
                        Text(
                          'Review TranzGOO policies and account rules.',
                          style:
                              AppText.mediumStyle.copyWith(letterSpacing: 0.09),
                        ),
                        const SizedBox(height: 20),
                        if (documents.isEmpty)
                          const AppEmptyState(
                            title: 'No documents',
                            message: 'Legal documents will appear here.',
                          )
                        else
                          ...documents.map(
                            (document) => AppInfoCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    document['title']?.toString() ?? '',
                                    style: AppText.extraBold.copyWith(
                                      color: AppColors.primaryColor,
                                      letterSpacing: 0.09,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    document['summary']?.toString() ?? '',
                                    style: AppText.mediumStyle.copyWith(
                                      letterSpacing: 0.09,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
