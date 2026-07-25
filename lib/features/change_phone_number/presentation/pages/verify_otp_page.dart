import 'dart:async';

import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/features/change_passwors/presentation/pages/change_password_page.dart';
import 'package:dental_app/features/register/presentation/pages/patient_type.dart';
import 'package:dental_app/features/register/presentation/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class VerifyOtpPage2 extends StatefulWidget {
  const VerifyOtpPage2({super.key});

  @override
  State<VerifyOtpPage2> createState() => _VerifyOtpPage2State();
}




class _VerifyOtpPage2State extends State<VerifyOtpPage2> with SingleTickerProviderStateMixin {
final _otpController = TextEditingController();

int _seconds = 60;
Timer? _timer;


    late AnimationController _toothController;

void _startTimer() {
  _seconds = 60;

  _timer?.cancel();

  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (_seconds == 0) {
      timer.cancel();
    } else {
      setState(() {
        _seconds--;
      });
    }
  });
}
    @override
  void initState() {
    super.initState();
    _startTimer();
    _toothController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // بتتحرك رايح جاي بشكل مستمر
  }

  @override
  void dispose() {
 
    _toothController.dispose(); // لازم تعمليها dispose
    super.dispose();
    _otpController.dispose();
_timer?.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SizedBox.expand(
        child: Stack(        
          children: [
            Positioned.fill(
              child: Image.asset('assets/backgrounds/background1.png', color:Theme.of(context).colorScheme.primary,
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
                                    color: AppColors.surface,
                     borderRadius: BorderRadius.circular(28),
                                    
                                boxShadow: [
                                    
                                  BoxShadow(
                                    
                                    color: const Color.fromARGB(255, 112, 112, 112),
                                    
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
                                    color: AppColors.primary,
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
            "assets/images/4.png", // مسار صورة السن عندك
            width: 45,
            color: Colors.white, // لو الصورة أبيض/أسود وبدك تلونيها
          ),
        ),
      ],
    ),
  ),
),
                              Center(
                                child: Text("Verify OTP",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                 fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                  fontSize: 20,
                                  
                                ),),
                              ),
                              SizedBox(height: 5,),
                              Center(
                                child: Text("enter the varefication code we sent to your mobile phone",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                  
                                ),),

                              ),
                      const SizedBox(height: 30),

Center(
  child: Pinput(
    controller: _otpController,
    length: 6,
    defaultPinTheme: PinTheme(
      width: 50,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 225, 236, 240),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textPrimary,
        ),
      ),
    ),
    focusedPinTheme: PinTheme(
      width: 50,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 225, 236, 240),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary,
          width: 2,
        ),
      ),
    ),
  ),
),

const SizedBox(height: 25),

Center(
  child: Text(
    "Didn't receive the code?",
    style: TextStyle(
      color: AppColors.textSecondary,
      fontSize: 13,
    ),
  ),
),

const SizedBox(height: 8),

Center(
  child: _seconds == 0
      ? TextButton(
          onPressed: () {
            _startTimer();

            // أرسل OTP من جديد
          },
          child: Text(
            "Resend Code",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      : Text(
          "Resend in 00:${_seconds.toString().padLeft(2, '0')}",
          style: TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
),

const SizedBox(height: 35),
SizedBox(
  width: double.infinity,
  height: 54,
  child: ElevatedButton(
    onPressed: () {
      // Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordPage(),));
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
          "Verify",
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