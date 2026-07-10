class ReceiptLineItem {
  final String label;
  final String value;

  const ReceiptLineItem({required this.label, required this.value});
}

class TransactionResultArguments {
  final bool isSuccess;
  final String title;
  final String message;
  final List<ReceiptLineItem> details;
  final String? primaryActionLabel;
  final String? primaryActionRoute;
  final Object? primaryActionArguments;

  const TransactionResultArguments({
    required this.isSuccess,
    required this.title,
    required this.message,
    this.details = const [],
    this.primaryActionLabel,
    this.primaryActionRoute,
    this.primaryActionArguments,
  });
}

class PaymentConfirmationArguments {
  final String title;
  final String subtitle;
  final String amountLabel;
  final List<ReceiptLineItem> details;
  final Future<TransactionResultArguments> Function() onConfirm;

  const PaymentConfirmationArguments({
    required this.title,
    required this.subtitle,
    required this.amountLabel,
    required this.details,
    required this.onConfirm,
  });
}
