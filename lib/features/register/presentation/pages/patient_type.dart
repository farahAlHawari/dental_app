import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/theme/bloc/theme_bloc_bloc.dart';
import 'package:dental_app/core/theme/bloc/theme_bloc_event.dart';
import 'package:dental_app/features/register/presentation/pages/medical_info.dart';
import 'package:dental_app/features/register/presentation/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientType extends StatefulWidget {
  const PatientType({super.key});

  @override
  State<PatientType> createState() => _PatientTypeState();
}




class _PatientTypeState extends State<PatientType> with SingleTickerProviderStateMixin {


int _selectedIndex = -1;
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
              child: Image.asset('assets/backgrounds/background1.png', 
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
            final scale = 1.2 + (_toothController.value * 0.15); 
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Image.asset(
            "assets/images/5.png", // مسار صورة السن عندك
            width: 45,
            color: Colors.white, // لو الصورة أبيض/أسود وبدك تلونيها
          ),
        ),
      ],
    ),
  ),
),
                              Center(
                                child: Text("Select the Primary Patient",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                 fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontSize: 20,
                                  
                                ),),
                              ),
                              SizedBox(height: 5,),
                              Center(
                                child: Text("This helps us personalize appointments and medical records.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                  fontSize: 10,
                                  
                                ),),
                              ),
                          SizedBox(height: 20,),
                        GestureDetector(
  onTap: () {
    setState(() {
      _selectedIndex = 0;
    });
  },
  child: AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeInOut,
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: _selectedIndex == 0
          ? Theme.of(context).colorScheme.primaryContainer
    : Theme.of(context).brightness == Brightness.light
        ? AppColors.CardLight
        : AppColors.CardDark,

      borderRadius: BorderRadius.circular(18),

      border: Border.all(
        color: _selectedIndex == 0
            ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
        width: 2,
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Myself",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "This account is for my own dental care.",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),

        Icon(
          _selectedIndex == 0
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          color: AppColors.primary,
        ),
      ],
    ),
  ),
),
SizedBox(height: 10,),
GestureDetector(
  onTap: () {
    setState(() {
      _selectedIndex = 1;
    });
  },
  child: AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeInOut,
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _selectedIndex == 1
          ? Theme.of(context).colorScheme.primaryContainer
    : Theme.of(context).brightness == Brightness.light
        ? AppColors.CardLight
        : AppColors.CardDark,

      borderRadius: BorderRadius.circular(18),

      border: Border.all(
        color: _selectedIndex == 1
             ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
        width: 2,
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.family_restroom_rounded,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Family Member",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Manage appointments for your family.",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),

        Icon(
          _selectedIndex == 1
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          color: AppColors.primary,
        ),
      ],
    ),
  ),
),


                 SizedBox(height: 40,),
                                SizedBox(
                          
                                  height: 54,
                          
                                  child: ElevatedButton(
                          
                                    onPressed: () {
                                                  // context.read<ThemeBloc>().add(ToggleTheme());

                                      Navigator.push(context, MaterialPageRoute(builder: (context) => MedicalInfo(), ));
                          
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
                          
                                        const Icon(Icons.arrow_right, color: Colors.white),
                          
                                        const SizedBox(width: 8),
                          
                                        Text(
                          
                                          'Next',
                          
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



