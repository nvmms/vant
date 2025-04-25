import 'package:flutter/material.dart';

class VanCell extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? label;
  final String? value;
  final bool isLink;
  final VoidCallback? onTap;

  const VanCell({
    super.key,
    this.icon,
    required this.title,
    this.label,
    this.value,
    this.isLink = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFEDEDED), width: 0.5),
          ),
        ),
        child: Row(
          crossAxisAlignment: label != null
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Icon(icon, size: 20),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.bodyLarge),
                  if (label != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        label!,
                        style:
                            textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ),
                ],
              ),
            ),
            if (value != null)
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  value!,
                  style:
                      textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ),
            if (isLink)
              const Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Icon(Icons.chevron_right, size: 20, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
