import 'package:flutter/material.dart';
import 'package:tranzgoo/utils/theme/app_colors.dart';
import 'package:tranzgoo/utils/theme/app_style.dart';
import 'package:tranzgoo/utils/widget/app_state_widgets.dart';

class ServiceDropdown extends StatelessWidget {
  final String hintText;
  final String? value;
  final List<Map<String, dynamic>> items;
  final ValueChanged<String?> onChanged;
  final String Function(Map<String, dynamic> item) itemLabel;

  const ServiceDropdown({
    Key? key,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 17),
      child: DropdownButtonFormField<String>(
        value: value == null || value!.isEmpty ? null : value,
        isExpanded: true,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: AppColors.whiteColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        items: items.map((item) {
          final id = item['id']?.toString() ?? '';
          return DropdownMenuItem<String>(
            value: id,
            child: Text(
              itemLabel(item),
              overflow: TextOverflow.ellipsis,
              style: AppText.mediumStyle.copyWith(letterSpacing: 0.09),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class ServiceResultCard extends StatelessWidget {
  final String title;
  final List<String> lines;

  const ServiceResultCard({
    Key? key,
    required this.title,
    required this.lines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppInfoCard(
      color: AppColors.primaryLightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppText.extraBold.copyWith(
              color: AppColors.primaryColor,
              letterSpacing: 0.09,
            ),
          ),
          const SizedBox(height: 6),
          ...lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                line,
                style: AppText.mediumStyle.copyWith(letterSpacing: 0.09),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceScreenShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const ServiceScreenShell({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(title)),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appSectionTitle(title),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: AppText.mediumStyle.copyWith(letterSpacing: 0.09),
              ),
              const SizedBox(height: 20),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
