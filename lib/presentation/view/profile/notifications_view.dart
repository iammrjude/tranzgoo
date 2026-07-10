import 'package:flutter/material.dart';
import 'package:tranzgoo/data/services/api_exception.dart';
import 'package:tranzgoo/data/services/tranzgoo_api_service.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_clickable_surface.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final TranzgooApiService _apiService = TranzgooApiService();
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await _apiService.getNotifications();

      if (!mounted) {
        return;
      }

      setState(() {
        notifications = data;
      });
    } on ApiException catch (error) {
      setState(() {
        errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        errorMessage = 'Unable to load notifications.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> markRead(Map<String, dynamic> notification) async {
    final id =
        notification['_id']?.toString() ?? notification['id']?.toString();

    if (id == null || id.isEmpty || notification['readAt'] != null) {
      return;
    }

    try {
      await _apiService.markNotificationRead(id);
      await loadNotifications();
    } on ApiException catch (error) {
      showMessage(error.message);
    } catch (_) {
      showMessage('Unable to mark notification as read.');
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
        title: const Text('Notifications', style: AppText.extraBold),
      ),
      body: SafeArea(
        bottom: false,
        child: isLoading
            ? const AppLoadingState(message: 'Loading notifications...')
            : errorMessage != null
            ? AppErrorState(message: errorMessage!, onRetry: loadNotifications)
            : RefreshIndicator(
                onRefresh: loadNotifications,
                color: AppColors.primaryColor,
                child: notifications.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 160),
                          AppEmptyState(
                            title: 'No notifications',
                            message:
                                'Important account updates will appear here.',
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          final isRead = notification['readAt'] != null;

                          return AppClickableSurface(
                            onTap: isRead ? null : () => markRead(notification),
                            semanticLabel:
                                notification['title']?.toString() ??
                                'Notification',
                            color: isRead
                                ? AppColors.whiteColor
                                : AppColors.primaryLightColor,
                            border: Border.all(color: AppColors.grey200),
                            borderRadius: BorderRadius.circular(10),
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification['title']?.toString() ?? '',
                                  style: AppText.extraBold.copyWith(
                                    color: AppColors.primaryColor,
                                    letterSpacing: 0.09,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  notification['message']?.toString() ?? '',
                                  style: AppText.mediumStyle.copyWith(
                                    letterSpacing: 0.09,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
      ),
    );
  }
}
