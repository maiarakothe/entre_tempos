import 'package:flutter/material.dart';

import '../../core/default_colors.dart';
import '../../core/utils.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.fullWidth = true,
    this.iconAlignment = IconAlignment.start,
    this.backgroundColor,
    this.textColor,
    this.disabled = false,
    this.fontSize,
    this.height,
  });

  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool fullWidth;
  final IconAlignment iconAlignment;
  final Color? backgroundColor;
  final Color? textColor;
  final bool disabled;
  final double? fontSize;
  final double? height;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hovered = false;

  ButtonStyle get style => ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: DefaultBorders.button),
  );

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.disabled;

    final Color textColor =
        widget.textColor ??
        (isDisabled ? DefaultColors.textSecondary : Colors.white);

    final Text child = Text(
      widget.text,
      style: TextStyle(
        fontSize: widget.fontSize ?? 17,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );

    return MouseRegion(
      onEnter: (_) {
        if (!isDisabled) {
          setState(() {
            _hovered = true;
          });
        }
      },
      onExit: (_) {
        if (!isDisabled) {
          setState(() {
            _hovered = false;
          });
        }
      },
      child: AnimatedScale(
        scale: _hovered && !isDisabled ? 1.01 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.fullWidth ? double.infinity : null,
          height: widget.height ?? 43,
          decoration: BoxDecoration(
            color:
                widget.backgroundColor ??
                (isDisabled
                    ? DefaultColors.textSecondary.withValues(alpha: 0.1)
                    : null),
            gradient: widget.backgroundColor == null && !isDisabled
                ? (_hovered
                      ? DefaultColors.colorTeste
                      : DefaultColors.colorTest)
                : null,
            borderRadius: DefaultBorders.button,
            boxShadow: isDisabled
                ? <BoxShadow>[]
                : <BoxShadow>[
                    BoxShadow(
                      color: DefaultColors.text.withValues(alpha: 0.2),
                      blurRadius: 9,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: widget.icon != null
              ? ElevatedButton.icon(
                  icon: Icon(widget.icon, color: textColor),
                  iconAlignment: widget.iconAlignment,
                  label: child,
                  style: style,
                  onPressed: isDisabled ? null : widget.onPressed,
                )
              : ElevatedButton(
                  style: style,
                  onPressed: isDisabled ? null : widget.onPressed,
                  child: child,
                ),
        ),
      ),
    );
  }
}
