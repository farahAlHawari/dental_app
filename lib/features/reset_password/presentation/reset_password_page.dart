import 'dart:async';

import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/widgets/app_text_field.dart';
import 'package:dental_app/core/widgets/dialog.dart';
import 'package:dental_app/features/register/presentation/pages/patient_type.dart';
import 'package:dental_app/features/register/presentation/pages/signup_page.dart';
import 'package:dental_app/features/register/presentation/pages/verify_otp_page.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}




class _ResetPasswordPageState extends State<ResetPasswordPage> with SingleTickerProviderStateMixin {
final _password = TextEditingController();
final _confirmpassword = TextEditingController();

    late AnimationController _toothController;



void _startTimer() {
 
}
    @override
  void initState() {
    super.initState();
   
    _toothController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // بتتحرك رايح جاي بشكل مستمر
  }

  @override
  void dispose() {
 
    _toothController.dispose(); // لازم تعمليها dispose
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      body: SizedBox.expand(
        child: Stack(        
          children: [
            Positioned.fill(
              child: Image.asset('assets/backgrounds/background1.png',color:Theme.of(context).colorScheme.primary,
               fit: BoxFit.cover,),
            ),
            SafeArea(
              child:LayoutBuilder(
    builder: (context, constraints){
      return SingleChildScrollView(
                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child:  ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight, 
          ),
                    child: Column(
                     mainAxisAlignment: MainAxisAlignment.center, 
                      children: [
                        Container(
                          width: double.infinity,
                          
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface,
                     borderRadius: BorderRadius.circular(28),
                                    
                                boxShadow: [
                                    
                                  BoxShadow(
                                    
                                    color: Theme.of(context).colorScheme.shadow,
                                    
                                    blurRadius: 20,
                                    
                                    offset: const Offset(0, 8),
                                    
                                  ),
                                    
                                ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  
                                  width: 60,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),

                              Center(
  child: SizedBox(
    width: 100,
    height: 100,
    child: Stack(
      alignment: Alignment.center,
      children: [
        // الدائرة الخلفية
        Image.asset(
          "assets/images/1.png",
          color: AppColors.primary,
          width: 100,
        ),
       
        AnimatedBuilder(
          animation: _toothController,
          builder: (context, child) {
            final scale = 1 + (_toothController.value * 0.15); 
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Image.asset(
            "assets/images/password.png", // مسار صورة السن عندك
            width: 45,
            color: Colors.white, // لو الصورة أبيض/أسود وبدك تلونيها
          ),
        ),
      ],
    ),
  ),
),
                              Center(
                                child: Text("Enter New Password",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                 fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontSize: 20,
                                  
                                ),),
                              ),
                              SizedBox(height: 5,),
                              Center(
                                child: Text("your new password must be different from previously used password.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
                                  fontSize: 10,
                                  
                                ),),

                              ),
                                                            const SizedBox(height: 20),

                
                             
          Text("New Password",textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 13,
                                
                              ),
                              ),
                              const SizedBox(height: 8),
                          
                                                     AppTextField(
  controller: _password,
  hint: "••••••••",
  isPassword: true,
  prefixIcon: Icons.lock_outline,
),

SizedBox(height: 20,),
 Text("Confirm Password",textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 13,
                                
                              ),
                              ),
                              const SizedBox(height: 8),
                          
                                                     AppTextField(
  controller: _confirmpassword,
  hint: "••••••••",
  isPassword: true,
  prefixIcon: Icons.lock_outline,
),
const SizedBox(height: 35),
SizedBox(
  width: double.infinity,
  height: 54,
  child: ElevatedButton(
    onPressed: () {
     CustomStatusDialog.show(
  context,
  title: "Password Changed Successfully",
  description: "Your password has been updated. Please use your new password to log in.",
   // ضع مسار صورتك هنا
  confirmButtonText: "Log In",
  onConfirm: () {
    Navigator.pop(context); // إغلاق الديالوغ
    // ثم الانتقال لصفحة تسجيل الدخول
  },);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       
        Text(
          "Save and change password",
          style: TextStyle(
            color: AppColors.background,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
),
const SizedBox(height: 10),




                             
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
    }
    
              ),
            )
          ],
        
        ),
      ),
    );
  }
}