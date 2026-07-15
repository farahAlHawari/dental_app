import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/theme/bloc/theme_bloc_bloc.dart';
import 'package:dental_app/core/theme/bloc/theme_bloc_event.dart';
import 'package:dental_app/core/widgets/app_text_field.dart';
import 'package:dental_app/features/register/presentation/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();

  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

    late AnimationController _toothController;

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
    _phoneController.dispose();
    _passwordController.dispose();
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
          color: Theme.of(context).colorScheme.primary,
          width: 100,
        ),
       
        AnimatedBuilder(
          animation: _toothController,
          builder: (context, child) {
            final scale = 1.5 + (_toothController.value * 0.15); 
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Image.asset(
            "assets/images/2.png", // مسار صورة السن عندك
            width: 45,
            color: Colors.white, // لو الصورة أبيض/أسود وبدك تلونيها
          ),
        ),
      ],
    ),
  ),
),
                              Center(
                                child: Text("welcome Back",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                 fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontSize: 20,
                                  
                                ),),
                              ),
                              SizedBox(height: 5,),
                              Center(
                                child: Text("log in to your account",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                  fontSize: 10,
                                  
                                ),),
                              ),
                          
                              SizedBox(height: 20,),
                              Text("Phone number",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 13,
                                
                              ),
                              ),
                              const SizedBox(height: 8),
                          
                              AppTextField(
  controller: _phoneController,
  hint: "09xxxxxxxx",
  prefixIcon: Icons.phone_outlined,
),
                              SizedBox(height: 20,),
                          
                          
                          
                               Text("Password",textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 13,
                                
                              ),
                              ),
                              const SizedBox(height: 8),
                          
                                                     AppTextField(
  controller: _passwordController,
  hint: "••••••••",
  isPassword: true,
  prefixIcon: Icons.lock_outline,
),
                          
                            SizedBox(height: 40,),
                                SizedBox(
                          
                                  height: 54,
                          
                                  child: ElevatedButton(
                          
                                    onPressed: () {
                          context.read<ThemeBloc>().add(ToggleTheme());
                                     
                          
                                    },
                          
                                    style: ElevatedButton.styleFrom(
                          
                                      backgroundColor: Theme.of(context).colorScheme.primary,
                          
                                      shape: RoundedRectangleBorder(
                          
                                        borderRadius: BorderRadius.circular(16),
                          
                                      ),
                          
                                      elevation: 0,
                          
                                    ),
                          
                                    child: Row(
                          
                                      mainAxisAlignment: MainAxisAlignment.center,
                          
                                      children: [
                          
                                        const Icon(Icons.arrow_back, color: Colors.white),
                          
                                        const SizedBox(width: 8),
                          
                                        Text(
                          
                                          'LogIn',
                          
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
                          
                          
                                 const SizedBox(height: 20),
                          
                          
                          
                                Divider(color: Theme.of(context).colorScheme.primary,),
                          
                                const SizedBox(height: 16),
                          
                          
                          
                                Text(
                          
                                  "You Don't Have an Account?",
                          
                                  textAlign: TextAlign.center,
                          
                                  style: TextStyle(
                          
                                    fontSize: 14,
                          
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          
                                  ),
                          
                                ),
                          
                                const SizedBox(height: 6),
                          
                                Center(
                          
                                  child: TextButton(
                          
                                    onPressed: () {
                          
                                        Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignupPage()
                                     ));
                          
                                    },
                          
                                    child: Text(
                          
                                      "create an account",
                          
                                      style: TextStyle(
                          
                                        color: Theme.of(context).colorScheme.primary,
                          
                                        fontWeight: FontWeight.bold,
                          
                                        fontSize: 15,
                          
                                      ),
                          
                                    ),))
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




