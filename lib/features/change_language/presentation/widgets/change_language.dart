// import 'package:dental_app/core/theme/app_colors.dart';
// import 'package:dental_app/core/utils/shared_prefs.dart';
// import 'package:dental_app/features/change_language/presentation/bloc/change_language_bloc.dart';
// import 'package:dental_app/features/change_language/presentation/widgets/language_selector.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lottie/lottie.dart';

// class ChangeLanguageDialog extends StatefulWidget {
//   const ChangeLanguageDialog({super.key});

//   @override
//   State<ChangeLanguageDialog> createState() =>
//       _ChangeLanguageDialogState();
// }

// class _ChangeLanguageDialogState
//     extends State<ChangeLanguageDialog> {

//   String selectedLanguage = "English";
// int _selectedIndex =0;
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: Container(
//         padding: const EdgeInsets.all(22),
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.surface,
//           borderRadius: BorderRadius.circular(24),
//         ),
//       child:   Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Center(
//                                 child: Container(
                                  
//                                   width: 60,
//                                   height: 4,
//                                   decoration: BoxDecoration(
//                                     color: Theme.of(context).colorScheme.primary,
//                                     borderRadius: BorderRadius.circular(10)
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 8,
//                               ),

                            
//       Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   width: 100,
//                   height: 100,
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Image.asset(
//                         "assets/images/1.png",
//                         color: Theme.of(context).colorScheme.primary,
//                         width: 70,
//                       ),
// LottieBuilder.asset("assets/animations/44.json",width: 150,repeat: true,fit: BoxFit.fill,)
//                     ],
//                   ),
//                 ),
//                 Text(
//                   "Change Language",
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   "please choose your language to begin".tr(),
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
//                     fontSize: 10,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//               SizedBox(height: 10,),
// GestureDetector(
//   onTap: () {
//     setState(() {
//       _selectedIndex = 0;
//     });
//   },
//   child: AnimatedContainer(
//     duration: const Duration(milliseconds: 250),
//     curve: Curves.easeInOut,
//     width: double.infinity,
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: _selectedIndex == 0
      
          
//   ? Theme.of(context).colorScheme.primaryContainer
//   : Theme.of(context).brightness == Brightness.light
//       ? AppColors.CardLight
//       : AppColors.CardDark,
  
//       borderRadius: BorderRadius.circular(18),
  
//       border: Border.all(
//         color: _selectedIndex == 0
//             ? Theme.of(context).colorScheme.primary
//             : Colors.transparent,
//         width: 2,
//       ),
//     ),
//     child: Row(
//       children: [
//         Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
//             shape: BoxShape.circle,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Image.asset("assets/images/english.png",width: 10,),
//           ),
//         ),
  
//         const SizedBox(width: 12),
  
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const [
//               Text(
//                 "English",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 "الإنجليزية",
//                 style: TextStyle(fontSize: 12),
//               ),
//             ],
//           ),
//         ),
  
//         Icon(
//           _selectedIndex == 0
//               ? Icons.check_circle_rounded
//               : Icons.radio_button_unchecked_rounded,
//           color: Theme.of(context).colorScheme.primary,
//         ),
//       ],
//     ),
//   ),
// ),
//        SizedBox(height: 12),      
// GestureDetector(
//   onTap: () {
//     setState(() {
//       _selectedIndex = 1;
//     });
//   },
//   child: AnimatedContainer(
//     duration: const Duration(milliseconds: 250),
//     curve: Curves.easeInOut,
//     width: double.infinity,
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: _selectedIndex == 1
          
//      ? Theme.of(context).colorScheme.primaryContainer
//   : Theme.of(context).brightness == Brightness.light
//       ? AppColors.CardLight
//       : AppColors.CardDark,
//       borderRadius: BorderRadius.circular(18),
  
//       border: Border.all(
//         color: _selectedIndex == 1
//              ? Theme.of(context).colorScheme.primary
//     : Colors.transparent,
//         width: 2,
//       ),
//     ),
//     child: Row(
//       children: [
//         Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
//             shape: BoxShape.circle,
//           ),
//           child:Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Image.asset("assets/images/arabic.png",width: 20),
//           ),
//         ),
  
//         const SizedBox(width: 12),
  
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const [
//               Text(
//                 "العربية",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 "Arabic",
//                 style: TextStyle(fontSize: 12),
//               ),
//             ],
//           ),
//         ),
  
//         Icon(
//           _selectedIndex == 1
//               ? Icons.check_circle_rounded
//               : Icons.radio_button_unchecked_rounded,
//           color: Theme.of(context).colorScheme.primary,
//         ),
//       ],
//     ),
//   ),
// ),
//                 const SizedBox(height: 30),

//                 SizedBox(
//                   width: double.infinity,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Theme.of(context).colorScheme.primary,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                       ),
//                      onPressed: () async {
//   final locale = _selectedIndex == 0
//       ? const Locale('en')
//       : const Locale('ar');
//   final languageCode = locale.languageCode;

//   await context.read<ChangeLanguageBloc>().add(
//     ChangeLanguageSubmitted(language: languageCode),
//   );
// },
//   //                       onPressed: () async {
//   // final locale = _selectedIndex == 0
//   //     ? const Locale('en', 'US')
//   //     : const Locale('ar', 'AR');

//   // await context.setLocale(locale);
//   // await SharedPrefs.saveLanguage(locale.languageCode);

//   // if (context.mounted) {
//   //   Navigator.pushReplacement(
//   //     context,
//   //     MaterialPageRoute(builder: (context) => OnboardingPage()),
//   //   );
//   // }

//   //                       // context.read<ThemeBloc>().add(ToggleTheme());
//   //                       Navigator.push(context, MaterialPageRoute(builder: (context) => OnboardingPage(),));
//   //                     },
//                       child: const Text(
//                         "Apply",
//                         style: TextStyle(color: AppColors.background, fontSize: 16),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),        
//                             ],
//                           ),
//         // child: Column(
//         //   mainAxisSize: MainAxisSize.min,
//         //   children: [

//         //     CircleAvatar(
//         //       radius: 28,
//         //       backgroundColor:
//         //           AppColors.primary.withOpacity(.1),
//         //       child: const Icon(
//         //         Icons.language,
//         //         color: AppColors.primary,
//         //         size: 28,
//         //       ),
//         //     ),

//         //     const SizedBox(height: 16),

//         //     const Text(
//         //       "Change Language",
//         //       style: TextStyle(
//         //         fontSize: 20,
//         //         fontWeight: FontWeight.bold,
//         //       ),
//         //     ),

//         //     const SizedBox(height: 6),

//         //     Text(
//         //       "Choose your preferred language",
//         //       style: TextStyle(
//         //         color: Colors.grey.shade600,
//         //       ),
//         //     ),

//         //     const SizedBox(height: 24),

//         //     LanguageSelector(
//         //       selectedlangage: selectedLanguage,
//         //       onChanged: (value) {
//         //         setState(() {
//         //           selectedLanguage = value;
//         //         });
//         //       },
//         //     ),

//         //     const SizedBox(height: 24),

//         //     Row(
//         //       children: [

//         //         Expanded(
//         //           child: OutlinedButton(
//         //             onPressed: () {
//         //               Navigator.pop(context);
//         //             },
//         //             child: const Text("Cancel"),
//         //           ),
//         //         ),

//         //         const SizedBox(width: 12),

//         //         Expanded(
//         //           child: ElevatedButton(
//         //             onPressed: () {

//         //               /// change locale

//         //               Navigator.pop(context);
//         //             },
//         //             child: const Text("Apply"),
//         //           ),
//         //         ),

//         //       ],
//         //     )

//         //   ],
//         // ),
//       ),
//     );
//   }
// }
import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/features/change_language/presentation/bloc/change_language_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class ChangeLanguageDialog extends StatefulWidget {
  const ChangeLanguageDialog({super.key});

  @override
  State<ChangeLanguageDialog> createState() => _ChangeLanguageDialogState();
}

class _ChangeLanguageDialogState extends State<ChangeLanguageDialog> {
  int _selectedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ضبط اللغة المحددة افتراضياً حسب لغة التطبيق الحالية
    _selectedIndex = context.locale.languageCode == 'ar' ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (_) => ChangeLanguageBloc(),
      child: BlocConsumer<ChangeLanguageBloc, ChangeLanguageState>(
        listener: (context, state) {
          if (state is ChangeLanguageSuccess) {
            final locale = _selectedIndex == 0
                ? const Locale('en')
                : const Locale('ar');
            context.setLocale(locale);
            SharedPrefs.saveLanguage(locale.languageCode);
            Navigator.pop(context);
          } else if (state is ChangeLanguageFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errMessage)),
            );
          }
        },
        builder: (context, state) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // يمنع وجود مساحات فارغة زائدة من الأسفل
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // مؤشر الممسك العلوي
                  Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // الشعار والأيقونة المتحركة
                  SizedBox(
                    width: 100,
                    height: 90,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          "assets/images/1.png",
                          color: colorScheme.primary,
                          width: 70,
                        ),
                        LottieBuilder.asset(
                          "assets/animations/44.json",
                          width: 140,
                          repeat: true,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // العناوين
                  Text(
                    "Change Language".tr(),
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Please select your preferred language".tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // خيار اللغة الإنجليزية
                  _buildLanguageOption(
                    index: 0,
                    title: "English",
                    subtitle: "الإنجليزية",
                    flagAsset: "assets/images/english.png",
                    context: context,
                  ),
                  const SizedBox(height: 15),

                  // خيار اللغة العربية
                  _buildLanguageOption(
                    index: 1,
                    title: "العربية",
                    subtitle: "Arabic",
                    flagAsset: "assets/images/arabic.png",
                    context: context,
                  ),
                  const SizedBox(height: 24),
SizedBox(height: 20,),
                  // زر التغيير والتأكيد
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: state is ChangeLanguageLoading
                          ? null
                          : () {
                              final locale = _selectedIndex == 0
                                  ? const Locale('en')
                                  : const Locale('ar');
                              context.read<ChangeLanguageBloc>().add(
                                    ChangeLanguageSubmitted(
                                      language: locale.languageCode,
                                    ),
                                  );
                            },
                      child: state is ChangeLanguageLoading
                          ? SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: colorScheme.onPrimary,
                              ),
                            )
                          : Text(
                              "Apply".tr(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguageOption({
    required int index,
    required String title,
    required String subtitle,
    required String flagAsset,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : (theme.brightness == Brightness.light
                  ? AppColors.CardLight
                  : AppColors.CardDark),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Image.asset(flagAsset),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}