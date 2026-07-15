import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.isPassword = false,
    this.validator,
    this.maxLines = 1,
    this.onChanged,
    this.readOnly = false,
this.onTap,
  });

  final TextEditingController controller;
  final String hint;
  final String? label;
final bool readOnly;
final VoidCallback? onTap;
  final IconData? prefixIcon;
  final Widget? suffixIcon;

  final TextInputType? keyboardType;

  final bool isPassword;

  final int maxLines;

  final String? Function(String?)? validator;

  final ValueChanged<String>? onChanged;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool obscure;

  @override
  void initState() {
    super.initState();
    obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: obscure,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      validator: widget.validator,
      onChanged: widget.onChanged,
readOnly: widget.readOnly,
onTap: widget.onTap,
      style: TextStyle(
        color: colors.onSurface,
        fontSize: 15,
      ),

      cursorColor: colors.primary,

      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,

        hintStyle: TextStyle(
          color: colors.onSurface.withOpacity(.45),
        ),

        filled: true,

        fillColor: Theme.of(context).inputDecorationTheme.fillColor,

        prefixIcon: widget.prefixIcon == null
            ? null
            : Icon(
                widget.prefixIcon,
                color: colors.primary,
              ),

        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    obscure = !obscure;
                  });
                },
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: colors.onSurface.withOpacity(.7),
                ),
              )
            : widget.suffixIcon,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}