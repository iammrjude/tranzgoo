import 'package:flutter/material.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_button.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';
import 'package:tranzgoo/utils/widget/app_textfield.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TranzgooApiService _apiService = TranzgooApiService();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  List<Map<String, dynamic>> tickets = [];
  bool isLoading = true;
  bool isSubmitting = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadTickets();
  }

  @override
  void dispose() {
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> loadTickets() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _apiService.getSupportTickets();

      if (!mounted) {
        return;
      }

      setState(() {
        tickets = data;
      });
    } on ApiException catch (error) {
      setState(() {
        errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Unable to load support tickets.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> createTicket() async {
    if (subjectController.text.trim().isEmpty ||
        messageController.text.trim().isEmpty) {
      showMessage('Please enter a subject and message.');
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      await _apiService.createSupportTicket(
        subject: subjectController.text,
        message: messageController.text,
      );
      subjectController.clear();
      messageController.clear();
      await loadTickets();
      showMessage('Support ticket created.');
    } on ApiException catch (error) {
      showMessage(error.message);
    } catch (_) {
      showMessage('Unable to create support ticket.');
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Support', style: AppText.extraBold),
      ),
      body: isLoading
          ? const AppLoadingState(message: 'Loading support...')
          : errorMessage != null
          ? AppErrorState(message: errorMessage!, onRetry: loadTickets)
          : RefreshIndicator(
              color: AppColors.primaryColor,
              onRefresh: loadTickets,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
                children: [
                  appSectionTitle('Contact Support'),
                  const SizedBox(height: 8),
                  Text(
                    'Create a ticket and track your support requests.',
                    style: AppText.mediumStyle.copyWith(letterSpacing: 0.09),
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: subjectController,
                    hintText: 'Subject',
                    icon: Image.asset('assets/icons/bx_support.png'),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 17),
                    child: TextFormField(
                      controller: messageController,
                      minLines: 4,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Message',
                        filled: true,
                        fillColor: AppColors.whiteColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  AppButton(
                    onPressed: createTicket,
                    label: 'Create Ticket',
                    isText: true,
                    isLoading: isSubmitting,
                  ),
                  const SizedBox(height: 24),
                  appSectionTitle('Your Tickets'),
                  const SizedBox(height: 12),
                  if (tickets.isEmpty)
                    const AppEmptyState(
                      title: 'No support tickets',
                      message: 'Tickets you create will appear here.',
                    )
                  else
                    ...tickets.map(
                      (ticket) => AppInfoCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    ticket['subject']?.toString() ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppText.extraBold.copyWith(
                                      letterSpacing: 0.09,
                                    ),
                                  ),
                                ),
                                Text(
                                  ticket['status']?.toString() ?? 'open',
                                  style: AppText.mediumStyle.copyWith(
                                    color: AppColors.primaryColor,
                                    letterSpacing: 0.09,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              ticket['message']?.toString() ?? '',
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
    );
  }
}
