import 'package:flutter/material.dart';

class ContactInfoSection extends StatefulWidget {
  final bool isEditMode;
  final String email;
  final String phone;

  const ContactInfoSection({
    super.key,
    required this.isEditMode,
    required this.email,
    required this.phone,
  });

  @override
  State<ContactInfoSection> createState() => _ContactInfoSectionState();
}

class _ContactInfoSectionState extends State<ContactInfoSection> {
  bool _hideEmail = false;
  bool _hidePhone = false;

  @override
  Widget build(BuildContext context) {
    Widget buildContactRow({
      required IconData icon,
      required String text,
      required bool hidden,
      required VoidCallback onToggle,
    }) {
      // Skip entirely in view mode if hidden
      if (!widget.isEditMode && hidden) return const SizedBox.shrink();

      return Padding(
        padding: EdgeInsets.symmetric(vertical: widget.isEditMode ? 0.0 : 2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: const Color(0xFF805832)),
            const SizedBox(width: 6),

            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 12,
                  color: Color(0xFF805832),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            SizedBox(
              width: 24,
              child:
                  widget.isEditMode
                      ? IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          hidden ? Icons.visibility_off : Icons.visibility,
                          size: 16,
                          color: const Color(0xFF805832),
                        ),
                        tooltip: hidden ? "Show" : "Hide",
                        onPressed: onToggle,
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildContactRow(
          icon: Icons.phone,
          text: widget.phone,
          hidden: _hidePhone,
          onToggle: () => setState(() => _hidePhone = !_hidePhone),
        ),
        buildContactRow(
          icon: Icons.mail_outline,
          text: widget.email,
          hidden: _hideEmail,
          onToggle: () => setState(() => _hideEmail = !_hideEmail),
        ),
      ],
    );
  }
}
