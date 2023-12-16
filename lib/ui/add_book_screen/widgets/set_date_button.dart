import 'package:flutter/material.dart';
import 'package:openreads/core/themes/app_theme.dart';

class SetDateButton extends StatelessWidget {
  const SetDateButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.onClearPressed,
    required this.showClearButton,
  });

  final IconData icon;
  final String text;
  final Function() onPressed;
  final Function() onClearPressed;
  final bool showClearButton;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornerRadius),
          ),
          onTap: onPressed,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(cornerRadius),
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(
                    0.5,
                  ),
              border: Border.all(color: dividerColor),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 15,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 15),
                    FittedBox(
                      child: Text(
                        text,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (showClearButton)
                  ? IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                      ),
                      onPressed: onClearPressed,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
