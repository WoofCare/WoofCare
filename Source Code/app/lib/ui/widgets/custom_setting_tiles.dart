import 'package:flutter/material.dart';
import 'package:woofcare/config/colors.dart';

// Example color constants — replace with your WoofCareColors
/// Section header tile
class SettingsSectionHeader extends StatelessWidget {
  final String title;
  const SettingsSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: WoofCareColors.primaryTextAndIcons,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Expansion tile with text field + save button
class SettingsExpansionFormTile extends StatelessWidget {
  final String title;
  final String label;
  final VoidCallback onSave;
  final TextEditingController controller;

  const SettingsExpansionFormTile({
    super.key,
    required this.title,
    required this.label,
    required this.onSave,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
          color: WoofCareColors.primaryTextAndIcons,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_drop_down,
        color: WoofCareColors.primaryTextAndIcons,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: label,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: onSave, child: const Text("Save")),
            ],
          ),
        ),
      ],
    );
  }
}

/// Dropdown tile
class SettingsDropdownTile extends StatelessWidget {
  final String title;
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const SettingsDropdownTile({
    super.key,
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: WoofCareColors.primaryTextAndIcons,
          fontSize: 16,
        ),
      ),
      trailing: DropdownButton<String>(
        value: value,
        items:
            options
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

/// Switch tile
class SettingsSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: WoofCareColors.primaryTextAndIcons,
          fontSize: 16,
        ),
      ),
      trailing: Switch(
        trackColor: WidgetStateProperty.all(WoofCareColors.buttonColor),
        thumbColor: WidgetStateProperty.all(WoofCareColors.offWhite),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
