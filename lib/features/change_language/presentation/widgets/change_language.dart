import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/features/change_language/presentation/widgets/language_selector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ChangeLanguageDialog extends StatefulWidget {
  const ChangeLanguageDialog({super.key});

  @override
  State<ChangeLanguageDialog> createState() =>
      _ChangeLanguageDialogState();
}

class _ChangeLanguageDialogState
    extends State<ChangeLanguageDialog> {

  String selectedLanguage = "English";
int _selectedIndex =0;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
        ),
      child:   Column(
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

                            
      Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        "assets/images/1.png",
                        color: Theme.of(context).colorScheme.primary,
                        width: 70,
                      ),
LottieBuilder.asset("assets/animations/44.json",width: 150,repeat: true,fit: BoxFit.fill,)
                    ],
                  ),
                ),
                Text(
                  "Change Language",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "please choose your language to begin".tr(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),

              SizedBox(height: 10,),
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
            color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/images/english.png",width: 10,),
          ),
        ),
  
        const SizedBox(width: 12),
  
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "English",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "الإنجليزية",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
  
        Icon(
          _selectedIndex == 0
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    ),
  ),
),
       SizedBox(height: 12),      
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
            color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child:Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/images/arabic.png",width: 20),
          ),
        ),
  
        const SizedBox(width: 12),
  
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "العربية",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Arabic",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
  
        Icon(
          _selectedIndex == 1
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    ),
  ),
),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
  final locale = _selectedIndex == 0
      ? const Locale('en')
      : const Locale('ar');

  await context.setLocale(locale);
  await SharedPrefs.saveLanguage(locale.languageCode);

  
},
  //                       onPressed: () async {
  // final locale = _selectedIndex == 0
  //     ? const Locale('en', 'US')
  //     : const Locale('ar', 'AR');

  // await context.setLocale(locale);
  // await SharedPrefs.saveLanguage(locale.languageCode);

  // if (context.mounted) {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => OnboardingPage()),
  //   );
  // }

  //                       // context.read<ThemeBloc>().add(ToggleTheme());
  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => OnboardingPage(),));
  //                     },
                      child: const Text(
                        "Apply",
                        style: TextStyle(color: AppColors.background, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),        
                            ],
                          ),
        // child: Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [

        //     CircleAvatar(
        //       radius: 28,
        //       backgroundColor:
        //           AppColors.primary.withOpacity(.1),
        //       child: const Icon(
        //         Icons.language,
        //         color: AppColors.primary,
        //         size: 28,
        //       ),
        //     ),

        //     const SizedBox(height: 16),

        //     const Text(
        //       "Change Language",
        //       style: TextStyle(
        //         fontSize: 20,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),

        //     const SizedBox(height: 6),

        //     Text(
        //       "Choose your preferred language",
        //       style: TextStyle(
        //         color: Colors.grey.shade600,
        //       ),
        //     ),

        //     const SizedBox(height: 24),

        //     LanguageSelector(
        //       selectedlangage: selectedLanguage,
        //       onChanged: (value) {
        //         setState(() {
        //           selectedLanguage = value;
        //         });
        //       },
        //     ),

        //     const SizedBox(height: 24),

        //     Row(
        //       children: [

        //         Expanded(
        //           child: OutlinedButton(
        //             onPressed: () {
        //               Navigator.pop(context);
        //             },
        //             child: const Text("Cancel"),
        //           ),
        //         ),

        //         const SizedBox(width: 12),

        //         Expanded(
        //           child: ElevatedButton(
        //             onPressed: () {

        //               /// change locale

        //               Navigator.pop(context);
        //             },
        //             child: const Text("Apply"),
        //           ),
        //         ),

        //       ],
        //     )

        //   ],
        // ),
      ),
    );
  }
}