import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomStatusDialog extends StatelessWidget {
  final String title;
  final String description;
  final String confirmButtonText;
  final VoidCallback onConfirm;
  final String? cancelButtonText; // اختياري (إذا كان الديالوغ يحتاج زر إلغاء)
  final VoidCallback? onCancel;

  const CustomStatusDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirmButtonText,
    required this.onConfirm,
    this.cancelButtonText,
    this.onCancel,
  });

  
  static void show(
    BuildContext context, {
    required String title,
    required String description,
    required String confirmButtonText,
    required VoidCallback onConfirm,
    String? cancelButtonText,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false, // لمنع إغلاق الديالوغ بالضغط خارجه إلا عند التفاعل
      builder: (context) => CustomStatusDialog(
        title: title,
        description: description,
        confirmButtonText: confirmButtonText,
        onConfirm: onConfirm,
        cancelButtonText: cancelButtonText,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24), // حواف ناعمة متناسقة مع تطبيقك
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ليأخذ حجم المحتوى فقط ولا يملأ الشاشة
          children: [
            
           LottieBuilder.asset("assets/animations/ss.json",width: 120,
              height: 120,repeat: true,),
            // Image.asset(
            //   imagePath,
            //   width: 120,
            //   height: 120,
            //   fit: BoxFit.contain,
            // ),
            

            // 2. العنوان الرئيسي
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),

            // 3. النص الوصفي
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // 4. أزرار التحكم
            Row(
              children: [
                // زر الإلغاء (يظهر فقط إذا تم تمرير نص له)
                if (cancelButtonText != null) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel ?? () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Theme.of(context).colorScheme.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        cancelButtonText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],

                // زر التأكيد الرئيسي
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      confirmButtonText,
                      style: TextStyle(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}