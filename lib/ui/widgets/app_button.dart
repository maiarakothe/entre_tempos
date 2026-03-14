import 'package:flutter/material.dart';

import '../../core/Colors.dart';
import '../../core/utils.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.fullWidth = true,
    this.iconAlignment = IconAlignment.start,
  });

  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool fullWidth;
  final IconAlignment iconAlignment;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hovered = false;

  final ButtonStyle style = ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
    shape: RoundedRectangleBorder(borderRadius: DefaultBorders.button),
  );

  static const TextStyle textStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    final Text child = Text(widget.text, style: textStyle);

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hovered = false;
        });
      },
      child: AnimatedScale(
        scale: _hovered ? 1.01 : 1.0,
        duration: Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: widget.fullWidth ? double.infinity : null,
          height: widget.fullWidth ? 44 : 38,
          decoration: BoxDecoration(
            gradient: _hovered
                ? DefaultColors.colorTeste
                : DefaultColors.colorTest,
            borderRadius: DefaultBorders.button,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: DefaultColors.text.withValues(alpha: 0.2),
                blurRadius: 9,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: widget.icon != null
              ? ElevatedButton.icon(
                  icon: Icon(widget.icon, color: Colors.white),
                  iconAlignment: widget.iconAlignment,
                  label: child,
                  style: style,
                  onPressed: widget.onPressed,
                )
              : ElevatedButton(
                  style: style,
                  onPressed: widget.onPressed,
                  child: child,
                ),
        ),
      ),
    );
  }
}
