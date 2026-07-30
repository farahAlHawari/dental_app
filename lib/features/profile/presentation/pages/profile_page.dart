// import 'package:dental_app/core/services/whatsapp_service.dart';
// import 'package:dental_app/core/theme/app_colors.dart';
// import 'package:dental_app/features/account_settings/presentation/pages/account_settings.dart';
// import 'package:dental_app/features/archived_visits/presentation/pages/archived_visits_page.dart';
// import 'package:dental_app/features/family_account/presentation/pages/family_account.dart';
// import 'package:dental_app/features/financial_and_billing/presentation/pages/financial_page.dart';
// import 'package:dental_app/features/login/presentation/pages/login_page.dart';
// import 'package:dental_app/features/logout/presentation/bloc/logout_bloc.dart';
// import 'package:dental_app/features/medical_archive/presentation/pages/medical_archive_page.dart';
// import 'package:dental_app/features/profile/presentation/pages/medical_show_update.dart';
// import 'package:dental_app/features/profile/presentation/widgets/profile_card.dart';
// import 'package:dental_app/features/profile/presentation/widgets/profile_menue_card.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => LogoutBloc(),
//       child: BlocListener<LogoutBloc, LogoutState>(
//         listener: (context, state) {
//           if (state is LogoutSuccess) {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (_) => LoginPage()),
//               (route) => false, 
//             );
//           } else if (state is LogoutFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.errMessage)),
//             );
//           }
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text(
//               'Profile'.tr(),
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//             ),
//           ),
//           backgroundColor: Theme.of(
//             context,
//           ).colorScheme.surfaceContainerHighest,
//           body: SizedBox.expand(
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: Image.asset(
//                     'assets/backgrounds/1.png',
//                     fit: BoxFit.cover,
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                 ),
//                 SafeArea(
//                   child: Column(
//                     children: [
//                       // الجزء القابل للسكرول
//                       Expanded(
//                         child: SingleChildScrollView(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 24,
//                           ),
//                           child: Column(
//                             children: [
//                               // ProfileCard(
//                               //   name: "mohammad Ahmad",
//                               //   gender: "Male",
//                               //   imagePath: "assets/images/profile1.jpg",
//                               //   onEdit: () {},
//                               //   onSwitchAccount: () {},
//                               // ),
//                               GestureDetector(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => MedicalInfo(
//                                         patientData: {
//                                           "name": "mohammad Ahmad",
//                                           "dob": "1998-05-12",
//                                           "gender": "Male",
//                                           "diseases": <String>[],
//                                           "allergies": "",
//                                           "image": "assets/images/profile1.jpg",
//                                         },
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 child: ProfileCard(
//                                   name: "mohammad Ahmad",
//                                   gender: "Male",
//                                   imagePath: "assets/images/profile1.jpg",
//                                   onEdit: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => AccountSettings(),
//                                       ),
//                                     );
//                                   },
//                                   onSwitchAccount: () {},
//                                 ),
//                               ),

//                               const SizedBox(height: 20),

//                               ProfileMenuCard(
//                                 title: "Account & Security Settings".tr(),
//                                 icon: Icon(
//                                   Icons.settings_outlined,
//                                   size: 20,
//                                   color: Theme.of(context).colorScheme.primary,
//                                 ),
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => AccountSettings(),
//                                     ),
//                                   );
//                                 },
//                               ),

//                               const SizedBox(height: 12),

//                               ProfileMenuCard(
//                                 title: "Digital Medical Records".tr(),
//                                 icon: Icon(
//                                   Icons.medical_services_outlined,
//                                   size: 20,
//                                   color: Theme.of(context).colorScheme.primary,
//                                 ),
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           MedicalArchivePage(),
//                                     ),
//                                   );
//                                 },
//                               ),

//                               const SizedBox(height: 12),

//                               ProfileMenuCard(
//                                 title: "Billing & Payments".tr(),
//                                 icon: Icon(
//                                   Icons.monetization_on,
//                                   size: 20,
//                                   color: Theme.of(context).colorScheme.primary,
//                                 ),
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => FinancialPage(),
//                                     ),
//                                   );
//                                 },
//                               ),

//                               const SizedBox(height: 12),

//                               ProfileMenuCard(
//                                 title: "Visit History".tr(),
//                                 icon: Icon(
//                                   Icons.calendar_today_outlined,
//                                   size: 20,
//                                   color: Theme.of(context).colorScheme.primary,
//                                 ),
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           ArchivedVisitsPage(),
//                                     ),
//                                   );
//                                 },
//                               ),

//                               const SizedBox(height: 12),

//                               ProfileMenuCard(
//                                 title: "Family Accounts".tr(),
//                                 icon: Icon(
//                                   Icons.family_restroom,
//                                   size: 20,
//                                   color: Theme.of(context).colorScheme.primary,
//                                 ),
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => FamilyAccount(),
//                                     ),
//                                   );
//                                 },
//                               ),

//                               const SizedBox(height: 12),

//                               ProfileMenuCard(
//                                 title: "Contact Us on WhatsApp".tr(),
//                                 icon: Icon(
//                                   Icons.chat_outlined,
//                                   color: Theme.of(context).colorScheme.surface,
//                                 ),
//                                 backgroundColor: Theme.of(
//                                   context,
//                                 ).colorScheme.primary,
//                                 textColor: Theme.of(
//                                   context,
//                                 ).colorScheme.surface,
//                                 showArrow: false,
//                                 onTap: () {
//                                   WhatsAppService.openWhatsApp(
//                                     phone: "963959296517",
//                                     message: "مرحبا، أريد الاستفسار عن موعد",
//                                   );
//                                 },
//                               ),
//                               const SizedBox(height: 12),
//                               ProfileMenuCard(
//                                 title: "Log Out".tr(),
//                                 icon: Icon(
//                                   Icons.logout,
//                                   color: Theme.of(context).colorScheme.error,
//                                 ),

//                                 textColor: Theme.of(context).colorScheme.error,
//                                 showArrow: false,
//                                 onTap: () => context.read<LogoutBloc>().add(
//                                   LogoutRequested(),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:dental_app/core/services/whatsapp_service.dart';
import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/features/account_settings/presentation/pages/account_settings.dart';
import 'package:dental_app/features/archived_visits/presentation/pages/archived_visits_page.dart';
import 'package:dental_app/features/family_account/presentation/pages/family_account.dart';
import 'package:dental_app/features/financial_and_billing/presentation/pages/financial_page.dart';
import 'package:dental_app/features/login/presentation/pages/login_page.dart';
import 'package:dental_app/features/logout/presentation/bloc/logout_bloc.dart';
import 'package:dental_app/features/medical_archive/presentation/pages/medical_archive_page.dart';
import 'package:dental_app/features/profile/presentation/pages/medical_show_update.dart';
import 'package:dental_app/features/profile/presentation/widgets/profile_card.dart';
import 'package:dental_app/features/profile/presentation/widgets/profile_menue_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Log Out".tr()),
        content: Text("Are you sure you want to log out?".tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text("Cancel".tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              "Log Out".tr(),
              style: TextStyle(color: Theme.of(ctx).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<LogoutBloc>().add(LogoutRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogoutBloc(),
      child: Builder(
        builder: (context) {
          return BlocListener<LogoutBloc, LogoutState>(
            listener: (context, state) {
              if (state is LogoutSuccess) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (route) => false,
                );
              } else if (state is LogoutFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errMessage)),
                );
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'Profile'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
              body: SizedBox.expand(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/backgrounds/1.png',
                        fit: BoxFit.cover,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SafeArea(
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 24,
                              ),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MedicalInfo(
                                            patientData: {
                                              "name": "mohammad Ahmad",
                                              "dob": "1998-05-12",
                                              "gender": "Male",
                                              "diseases": <String>[],
                                              "allergies": "",
                                              "image":
                                                  "assets/images/profile1.jpg",
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    child: ProfileCard(
                                      name: "mohammad Ahmad",
                                      gender: "Male",
                                      imagePath: "assets/images/profile1.jpg",
                                      onEdit: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AccountSettings(),
                                          ),
                                        );
                                      },
                                      onSwitchAccount: () {},
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  ProfileMenuCard(
                                    title: "Account & Security Settings".tr(),
                                    icon: Icon(
                                      Icons.settings_outlined,
                                      size: 20,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AccountSettings(),
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 12),

                                  ProfileMenuCard(
                                    title: "Digital Medical Records".tr(),
                                    icon: Icon(
                                      Icons.medical_services_outlined,
                                      size: 20,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MedicalArchivePage(),
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 12),

                                  ProfileMenuCard(
                                    title: "Billing & Payments".tr(),
                                    icon: Icon(
                                      Icons.monetization_on,
                                      size: 20,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FinancialPage(),
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 12),

                                  ProfileMenuCard(
                                    title: "Visit History".tr(),
                                    icon: Icon(
                                      Icons.calendar_today_outlined,
                                      size: 20,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ArchivedVisitsPage(),
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 12),

                                  ProfileMenuCard(
                                    title: "Family Accounts".tr(),
                                    icon: Icon(
                                      Icons.family_restroom,
                                      size: 20,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FamilyAccount(),
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 12),

                                  ProfileMenuCard(
                                    title: "Contact Us on WhatsApp".tr(),
                                    icon: Icon(
                                      Icons.chat_outlined,
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    textColor: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                    showArrow: false,
                                    onTap: () {
                                      WhatsAppService.openWhatsApp(
                                        phone: "963959296517",
                                        message: "مرحبا، أريد الاستفسار عن موعد",
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  ProfileMenuCard(
                                    title: "Log Out".tr(),
                                    icon: Icon(
                                      Icons.logout,
                                      color: Theme.of(context).colorScheme.error,
                                    ),
                                    textColor:
                                        Theme.of(context).colorScheme.error,
                                    showArrow: false,
                                    onTap: () => _confirmLogout(context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}