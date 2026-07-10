import 'package:tranzgoo/data/services/api_client.dart';

class TranzgooApiService {
  final ApiClient _apiClient;

  TranzgooApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<Map<String, dynamic>> getUser() async {
    final response = await _apiClient.get('/api/user/me', authenticated: true);
    return _map(response, 'user');
  }

  Future<Map<String, dynamic>> updateUser({
    required String fullName,
    required String email,
    required String phone,
  }) async {
    final response = await _apiClient.patch('/api/user/me', {
      'fullName': fullName.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
    }, authenticated: true);

    return _map(response, 'user');
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _apiClient.post('/api/auth/change-password', {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    }, authenticated: true);
  }

  Future<Map<String, dynamic>> getSecurity() async {
    final response = await _apiClient.get(
      '/api/user/security',
      authenticated: true,
    );
    return _map(response, 'security');
  }

  Future<Map<String, dynamic>> getWallet() async {
    final response = await _apiClient.get('/api/wallet', authenticated: true);
    return _map(response, 'wallet');
  }

  Future<List<Map<String, dynamic>>> getFundingAccounts() async {
    final response = await _apiClient.get(
      '/api/wallet/funding-accounts',
      authenticated: true,
    );
    return _list(response, 'fundingAccounts');
  }

  Future<Map<String, dynamic>> transfer({
    required String receiverTranzgoId,
    required String amount,
    String note = '',
  }) async {
    final response = await _apiClient.post('/api/wallet/transfer', {
      'receiverTranzgoId': receiverTranzgoId.trim(),
      'amount': amount.trim(),
      'note': note.trim(),
    }, authenticated: true);

    return _data(response);
  }

  Future<Map<String, dynamic>> lookupUser(String tranzgoId) async {
    final response = await _apiClient.get(
      '/api/users/lookup/${Uri.encodeComponent(tranzgoId.trim())}',
      authenticated: true,
    );
    return _map(response, 'user');
  }

  Future<List<Map<String, dynamic>>> getTransactions({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      '/api/transactions?page=$page&limit=$limit',
      authenticated: true,
    );
    return _list(response, 'transactions');
  }

  Future<Map<String, dynamic>> getTransaction(String id) async {
    final response = await _apiClient.get(
      '/api/transactions/${Uri.encodeComponent(id)}',
      authenticated: true,
    );
    return _map(response, 'transaction');
  }

  Future<List<Map<String, dynamic>>> getServices() async {
    final response = await _apiClient.get('/api/services', authenticated: true);
    return _list(response, 'services');
  }

  Future<List<Map<String, dynamic>>> getAirtimeNetworks() async {
    final response = await _apiClient.get(
      '/api/services/airtime/networks',
      authenticated: true,
    );
    return _list(response, 'networks');
  }

  Future<Map<String, dynamic>> buyAirtime({
    required String network,
    required String phone,
    required String amount,
  }) async {
    final response = await _apiClient.post('/api/services/airtime/purchase', {
      'network': network,
      'phone': phone.trim(),
      'amount': amount.trim(),
    }, authenticated: true);

    return _data(response);
  }

  Future<List<Map<String, dynamic>>> getDataNetworks() async {
    final response = await _apiClient.get(
      '/api/services/data/networks',
      authenticated: true,
    );
    return _list(response, 'networks');
  }

  Future<List<Map<String, dynamic>>> getDataPlans({String? network}) async {
    final query = network == null || network.isEmpty
        ? ''
        : '?network=${Uri.encodeComponent(network)}';
    final response = await _apiClient.get(
      '/api/services/data/plans$query',
      authenticated: true,
    );
    return _list(response, 'plans');
  }

  Future<Map<String, dynamic>> buyData({
    required String planId,
    required String phone,
  }) async {
    final response = await _apiClient.post('/api/services/data/purchase', {
      'planId': planId,
      'phone': phone.trim(),
    }, authenticated: true);

    return _data(response);
  }

  Future<List<Map<String, dynamic>>> getCableProviders() async {
    final response = await _apiClient.get(
      '/api/services/cable/providers',
      authenticated: true,
    );
    return _list(response, 'providers');
  }

  Future<List<Map<String, dynamic>>> getCablePackages({
    String? provider,
  }) async {
    final query = provider == null || provider.isEmpty
        ? ''
        : '?provider=${Uri.encodeComponent(provider)}';
    final response = await _apiClient.get(
      '/api/services/cable/packages$query',
      authenticated: true,
    );
    return _list(response, 'packages');
  }

  Future<Map<String, dynamic>> validateCable({
    required String provider,
    required String smartCardNumber,
  }) async {
    final response = await _apiClient.post('/api/services/cable/validate', {
      'provider': provider,
      'smartCardNumber': smartCardNumber.trim(),
    }, authenticated: true);

    return _map(response, 'customer');
  }

  Future<Map<String, dynamic>> buyCable({
    required String packageId,
    required String smartCardNumber,
  }) async {
    final response = await _apiClient.post('/api/services/cable/purchase', {
      'packageId': packageId,
      'smartCardNumber': smartCardNumber.trim(),
    }, authenticated: true);

    return _data(response);
  }

  Future<List<Map<String, dynamic>>> getElectricityProviders() async {
    final response = await _apiClient.get(
      '/api/services/electricity/providers',
      authenticated: true,
    );
    return _list(response, 'providers');
  }

  Future<Map<String, dynamic>> validateMeter({
    required String provider,
    required String meterNumber,
  }) async {
    final response = await _apiClient.post(
      '/api/services/electricity/validate-meter',
      {'provider': provider, 'meterNumber': meterNumber.trim()},
      authenticated: true,
    );

    return _map(response, 'customer');
  }

  Future<Map<String, dynamic>> buyElectricity({
    required String provider,
    required String meterNumber,
    required String meterType,
    required String amount,
  }) async {
    final response = await _apiClient
        .post('/api/services/electricity/purchase', {
          'provider': provider,
          'meterNumber': meterNumber.trim(),
          'meterType': meterType,
          'amount': amount.trim(),
        }, authenticated: true);

    return _data(response);
  }

  Future<List<Map<String, dynamic>>> getEducationProducts() async {
    final response = await _apiClient.get(
      '/api/services/education/products',
      authenticated: true,
    );
    return _list(response, 'products');
  }

  Future<Map<String, dynamic>> buyEducationProduct(String productId) async {
    final response = await _apiClient.post('/api/services/education/purchase', {
      'productId': productId,
    }, authenticated: true);

    return _data(response);
  }

  Future<Map<String, dynamic>> getAirtimeToCashQuote(String amount) async {
    final response = await _apiClient.post(
      '/api/services/airtime-to-cash/quote',
      {'amount': amount.trim()},
      authenticated: true,
    );

    return _map(response, 'quote');
  }

  Future<Map<String, dynamic>> submitAirtimeToCash({
    required String network,
    required String phone,
    required String amount,
  }) async {
    final response = await _apiClient.post(
      '/api/services/airtime-to-cash/submit',
      {'network': network, 'phone': phone.trim(), 'amount': amount.trim()},
      authenticated: true,
    );

    return _data(response);
  }

  Future<Map<String, dynamic>> getAirtimeToCashRequest(String id) async {
    final response = await _apiClient.get(
      '/api/services/airtime-to-cash/${Uri.encodeComponent(id)}',
      authenticated: true,
    );
    return _map(response, 'request');
  }

  Future<List<Map<String, dynamic>>> getNotifications() async {
    final response = await _apiClient.get(
      '/api/notifications',
      authenticated: true,
    );
    return _list(response, 'notifications');
  }

  Future<void> markNotificationRead(String id) async {
    await _apiClient.patch(
      '/api/notifications/${Uri.encodeComponent(id)}/read',
      {},
      authenticated: true,
    );
  }

  Future<Map<String, dynamic>> getNotificationPreferences() async {
    final response = await _apiClient.get(
      '/api/notifications/preferences',
      authenticated: true,
    );
    return _map(response, 'preferences');
  }

  Future<Map<String, dynamic>> updateNotificationPreferences(
    Map<String, bool> preferences,
  ) async {
    final response = await _apiClient.patch(
      '/api/notifications/preferences',
      preferences,
      authenticated: true,
    );
    return _map(response, 'preferences');
  }

  Future<Map<String, dynamic>> getReferrals() async {
    final response = await _apiClient.get(
      '/api/referrals',
      authenticated: true,
    );
    return _data(response);
  }

  Future<Map<String, dynamic>> sendReferralInvite(String recipient) async {
    final response = await _apiClient.post('/api/referrals/invite', {
      'recipient': recipient.trim(),
    }, authenticated: true);

    return _data(response);
  }

  Future<List<Map<String, dynamic>>> getSupportTickets() async {
    final response = await _apiClient.get(
      '/api/support/tickets',
      authenticated: true,
    );
    return _list(response, 'tickets');
  }

  Future<Map<String, dynamic>> createSupportTicket({
    required String subject,
    required String message,
  }) async {
    final response = await _apiClient.post('/api/support/tickets', {
      'subject': subject.trim(),
      'message': message.trim(),
    }, authenticated: true);

    return _map(response, 'ticket');
  }

  Future<List<Map<String, dynamic>>> getLegalDocuments() async {
    final response = await _apiClient.get('/api/legal');
    return _list(response, 'documents');
  }

  Map<String, dynamic> _data(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is Map<String, dynamic>) {
      return data;
    }

    return <String, dynamic>{};
  }

  Map<String, dynamic> _map(Map<String, dynamic> response, String key) {
    final data = _data(response);
    final value = data[key];

    if (value is Map<String, dynamic>) {
      return value;
    }

    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> _list(Map<String, dynamic> response, String key) {
    final data = _data(response);
    final value = data[key];

    if (value is List) {
      return value
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    return <Map<String, dynamic>>[];
  }
}
