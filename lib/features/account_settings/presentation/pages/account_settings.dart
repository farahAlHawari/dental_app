// // // // import 'package:dental_app/core/theme/app_colors.dart';
// // // // import 'package:dental_app/core/theme/bloc/theme_bloc_bloc.dart';
// // // // import 'package:dental_app/core/theme/bloc/theme_bloc_event.dart';
// // // // import 'package:dental_app/core/theme/bloc/theme_bloc_state.dart';
// // // // import 'package:dental_app/features/change_language/presentation/widgets/change_language.dart';
// // // // import 'package:dental_app/features/change_passwors/presentation/pages/change_password_page.dart';
// // // // import 'package:dental_app/features/change_phone_number/presentation/pages/change_phone_number.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_bloc/flutter_bloc.dart';

// // // // class AccountSettings extends StatefulWidget {
// // // //   const AccountSettings({super.key});

// // // //   @override
// // // //   State<AccountSettings> createState() => _AccountSettingsState();
// // // // }

// // // // class _AccountSettingsState extends State<AccountSettings> {
// // // //   bool _biometricsEnabled = true;
// // // //   bool _pushEnabled = true;
// // // //   bool _smsEnabled = false;

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Directionality(
// // // //       textDirection: TextDirection.ltr,
// // // //       child: Scaffold(
// // // //         appBar: AppBar(
// // // //           title: Text(
// // // //             'App and Security Settings',
// // // //             textAlign: TextAlign.center,
// // // //             style: TextStyle(
// // // //               fontSize: 18,
// // // //               fontWeight: FontWeight.bold,
// // // //               color: Theme.of(context).colorScheme.primary,
// // // //             ),
// // // //           ),
// // // //         ),
// // // //         backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
// // // //         body: SizedBox.expand(
// // // //           child: Stack(
// // // //             children: [
// // // //               Positioned.fill(
// // // //                 child: Image.asset(
// // // //                   'assets/backgrounds/background5.png',
// // // //                   fit: BoxFit.cover,
// // // //                   color: Theme.of(context).colorScheme.onSurface,
// // // //                 ),
// // // //               ),
// // // //               SafeArea(
// // // //                 child: Column(
// // // //                   children: [
// // // //                     Expanded(
// // // //                       child: ListView(
// // // //                         padding: const EdgeInsets.symmetric(horizontal: 20),
// // // //                         children: [
// // // //                           const SizedBox(height: 8),
// // // //                           const _SectionTitle(title: "Security Settings"),
// // // //                           const SizedBox(height: 8),
// // // //                           _SettingsCard(
// // // //                             children: [
// // // //                               _SettingsTile(
// // // //                                 title: 'Change phone number',
// // // //                                 icon: Icons.phone,
// // // //                                 trailing: const Icon(
// // // //                                   Icons.chevron_right,
// // // //                                   color: Colors.black45,
// // // //                                 ),
// // // //                                 onTap: () {
// // // //                                   Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePhonenumberPage(),));
// // // //                                 },
// // // //                               ),
// // // //                               const _TileDivider(),
// // // //                               _SettingsTile(
// // // //                                 title: 'Change password',
// // // //                                 icon: Icons.lock_outline,
// // // //                                 trailing: const Icon(
// // // //                                   Icons.chevron_right,
// // // //                                   color: Colors.black45,
// // // //                                 ),
// // // //                                 onTap: () {
// // // //                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordPage()));
// // // //                                 },
// // // //                               ),
// // // //                               const _TileDivider(),
// // // //                               _SettingsTile(
// // // //                                 title: 'Enable fingerprint login\n(Biometrics)',
// // // //                                 icon: Icons.fingerprint,
// // // //                                 trailing: Switch(
// // // //                                   value: _biometricsEnabled,
// // // //                                   activeColor: AppColors.primary,
// // // //                                   onChanged: (value) {
// // // //                                     setState(() => _biometricsEnabled = value);
// // // //                                   },
// // // //                                 ),
// // // //                               ),
// // // //                             ],
// // // //                           ),
// // // //                           const SizedBox(height: 24),

// // // // const _SectionTitle(title: 'Appearance'),
// // // //                           const SizedBox(height: 8),
// // // //                           _SettingsCard(
// // // //                             children: [
// // // //                               _SettingsTile(
// // // //   title: "Theme",
// // // //   icon: Icons.dark_mode_outlined,
// // // //   trailing: BlocBuilder<ThemeBloc, ThemeState>(
// // // //     builder: (context, state) {
// // // //       return Switch(
// // // //         value: state.themeMode == ThemeMode.dark,
// // // //         activeColor: AppColors.primary,
// // // //         onChanged: (_) {
// // // //           context.read<ThemeBloc>().add(ToggleTheme());
// // // //         },
// // // //       );
// // // //     },
// // // //   ),
// // // // ),

// // // // const _TileDivider(),
// // // //                              _SettingsTile(
// // // //       title: "Application Language",
// // // //       icon: Icons.language,
// // // //       trailing: const Icon(
// // // //         Icons.chevron_right,
// // // //         color: Colors.black45,
// // // //       ),
// // // //       onTap: () {
// // // //   showDialog(
// // // //     context: context,
// // // //     builder: (_) => const ChangeLanguageDialog(),
// // // //   );
// // // // }
// // // //     ),

// // // //                             ],
// // // //                           ),

// // // // const SizedBox(height: 24),

// // // //                           const _SectionTitle(title: 'Notification Preferences'),
// // // //                           const SizedBox(height: 8),
// // // //                           _SettingsCard(
// // // //                             children: [
// // // //                               _SettingsTile(
// // // //                                 title: 'Instant push notifications\n(Notifications)',
// // // //                                 icon: Icons.notifications_none_rounded,
// // // //                                 trailing: Switch(
// // // //                                   value: _pushEnabled,
// // // //                                   activeColor: AppColors.primary,
// // // //                                   onChanged: (value) {
// // // //                                     setState(() => _pushEnabled = value);
// // // //                                   },
// // // //                                 ),
// // // //                               ),
// // // //                               const _TileDivider(),
// // // //                               _SettingsTile(
// // // //                                 title: 'SMS text reminders\n(Alerts)',
// // // //                                 icon: Icons.chat_bubble_outline_rounded,
// // // //                                 trailing: Switch(
// // // //                                   value: _smsEnabled,
// // // //                                   activeColor: AppColors.primary,
// // // //                                   onChanged: (value) {
// // // //                                     setState(() => _smsEnabled = value);
// // // //                                   },
// // // //                                 ),
// // // //                               ),
// // // //                             ],
// // // //                           ),
// // // //                           const SizedBox(height: 24),
// // // //                           const SizedBox(height: 20),
// // // //                         ],
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // class _SectionTitle extends StatelessWidget {
// // // //   final String title;

// // // //   const _SectionTitle({required this.title});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Text(
// // // //       title,
// // // //       textAlign: TextAlign.left,
// // // //       style: const TextStyle(
// // // //         fontSize: 14,
// // // //         fontWeight: FontWeight.w600,
// // // //         color: Colors.black87,
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // class _SettingsCard extends StatelessWidget {
// // // //   final List<Widget> children;

// // // //   const _SettingsCard({required this.children});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Container(
// // // //       decoration: BoxDecoration(
// // // //         color: Theme.of(context).colorScheme.surface,
// // // //         borderRadius: BorderRadius.circular(16),
// // // //         boxShadow: [
// // // //           BoxShadow(
// // // //             color: Theme.of(context).colorScheme.shadow,
// // // //             blurRadius: 8,
// // // //             offset: const Offset(0, 2),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       child: Column(children: children),
// // // //     );
// // // //   }
// // // // }

// // // // class _TileDivider extends StatelessWidget {
// // // //   const _TileDivider();

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Divider(
// // // //       height: 1,
// // // //       indent: 16,
// // // //       endIndent: 16,
// // // //       color: Colors.grey.shade200,
// // // //     );
// // // //   }
// // // // }

// // // // class _SettingsTile extends StatelessWidget {
// // // //   final String title;
// // // //   final IconData icon;
// // // //   final Widget trailing;
// // // //   final VoidCallback? onTap;

// // // //   const _SettingsTile({
// // // //     required this.title,
// // // //     required this.icon,
// // // //     required this.trailing,
// // // //     this.onTap,
// // // //   });

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return InkWell(
// // // //       onTap: onTap,
// // // //       borderRadius: BorderRadius.circular(16),
// // // //       child: Padding(
// // // //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// // // //         child: Row(
// // // //           children: [
// // // //             Container(
// // // //               padding: const EdgeInsets.all(8),
// // // //               decoration: BoxDecoration(
// // // //                 color: Colors.grey.shade100,
// // // //                 borderRadius: BorderRadius.circular(10),
// // // //               ),
// // // //               child: Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurface),
// // // //             ),
// // // //             const SizedBox(width: 12),
// // // //             Expanded(
// // // //               child: Text(
// // // //                 title,
// // // //                 textAlign: TextAlign.left,
// // // //                 style: const TextStyle(fontSize: 14),
// // // //               ),
// // // //             ),
// // // //             const SizedBox(width: 8),
// // // //             trailing,
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // import 'package:dental_app/core/theme/app_colors.dart';
// // // import 'package:dental_app/core/theme/bloc/theme_bloc_bloc.dart';
// // // import 'package:dental_app/core/theme/bloc/theme_bloc_event.dart';
// // // import 'package:dental_app/core/theme/bloc/theme_bloc_state.dart';
// // // import 'package:dental_app/features/change_language/presentation/widgets/change_language.dart';
// // // import 'package:dental_app/features/change_passwors/presentation/pages/change_password_page.dart';
// // // import 'package:dental_app/features/change_phone_number/presentation/pages/change_phone_number.dart';
// // // import 'package:easy_localization/easy_localization.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_bloc/flutter_bloc.dart';

// // // class AccountSettings extends StatefulWidget {
// // //   const AccountSettings({super.key});

// // //   @override
// // //   State<AccountSettings> createState() => _AccountSettingsState();
// // // }

// // // class _AccountSettingsState extends State<AccountSettings> {
// // //   bool _biometricsEnabled = true;
// // //   bool _pushEnabled = true;
// // //   bool _smsEnabled = false;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text(
// // //           'Account & Security Settings'.tr(),
// // //           textAlign: TextAlign.center,
// // //           style: TextStyle(
// // //             fontSize: 18,
// // //             fontWeight: FontWeight.bold,
// // //             color: Theme.of(context).colorScheme.primary,
// // //           ),
// // //         ),
// // //       ),
// // //       backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
// // //       body: SizedBox.expand(
// // //         child: Stack(
// // //           children: [
// // //             Positioned.fill(
// // //               child: Image.asset(
// // //                 'assets/backgrounds/background5.png',
// // //                 color:Theme.of(context).colorScheme.primary,
// // //                 fit: BoxFit.cover,
// // //               ),
// // //             ),
// // //             SafeArea(
// // //               child: Column(
// // //                 children: [
// // //                   Expanded(
// // //                     child: ListView(
// // //                       padding: const EdgeInsets.symmetric(horizontal: 20),
// // //                       children: [
// // //                         const SizedBox(height: 8),
// // //                          _SectionTitle(title: "Security Settings".tr()),
// // //                         const SizedBox(height: 8),
// // //                         _SettingsCard(
// // //                           children: [
// // //                             _SettingsTile(
// // //                               title: 'Change phone number'.tr(),
// // //                               icon: Icons.phone,
// // //                               trailing: Icon(
// // //                                 Icons.chevron_right,
// // //                                 color: Theme.of(context)
// // //                                     .colorScheme
// // //                                     .onSurfaceVariant,
// // //                               ),
// // //                               onTap: () {
// // //                                 Navigator.push(
// // //                                   context,
// // //                                   MaterialPageRoute(
// // //                                     builder: (context) =>
// // //                                         ChangePhonenumberPage(),
// // //                                   ),
// // //                                 );
// // //                               },
// // //                             ),
// // //                             const _TileDivider(),
// // //                             _SettingsTile(
// // //                               title: 'Change password'.tr(),
// // //                               icon: Icons.lock_outline,
// // //                               trailing: Icon(
// // //                                 Icons.chevron_right,
// // //                                 color: Theme.of(context)
// // //                                     .colorScheme
// // //                                     .onSurfaceVariant,
// // //                               ),
// // //                               onTap: () {
// // //                                 Navigator.push(
// // //                                   context,
// // //                                   MaterialPageRoute(
// // //                                     builder: (context) =>
// // //                                         ChangePasswordPage(),
// // //                                   ),
// // //                                 );
// // //                               },
// // //                             ),
// // //                             const _TileDivider(),
// // //                             _SettingsTile(
// // //                               title: 'Biometric Login'.tr(),
// // //                               icon: Icons.fingerprint,
// // //                               trailing: Switch(
// // //                                 value: _biometricsEnabled,
// // //                                 activeColor: AppColors.primary,
// // //                                 onChanged: (value) {
// // //                                   setState(() => _biometricsEnabled = value);
// // //                                 },
// // //                               ),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                         const SizedBox(height: 24),

// // //                          _SectionTitle(title: 'Appearance'.tr()),
// // //                         const SizedBox(height: 8),
// // //                         _SettingsCard(
// // //                           children: [
// // //                             _SettingsTile(
// // //                               title: "Theme".tr(),
// // //                               icon: Icons.dark_mode_outlined,
// // //                               trailing: BlocBuilder<ThemeBloc, ThemeState>(
// // //                                 builder: (context, state) {
// // //                                   return Switch(
// // //                                     value: state.themeMode == ThemeMode.dark,
// // //                                     activeColor: AppColors.primary,
// // //                                     onChanged: (_) {
// // //                                       context
// // //                                           .read<ThemeBloc>()
// // //                                           .add(ToggleTheme());
// // //                                     },
// // //                                   );
// // //                                 },
// // //                               ),
// // //                             ),
// // //                             const _TileDivider(),
// // //                             _SettingsTile(
// // //                               title: 'App Language'.tr(),
// // //                               icon: Icons.language,
// // //                               trailing: Icon(
// // //                                 Icons.chevron_right,
// // //                                 color: Theme.of(context)
// // //                                     .colorScheme
// // //                                     .onSurfaceVariant,
// // //                               ),
// // //                               onTap: () {
// // //                                 showDialog(
// // //                                   context: context,
// // //                                   builder: (_) => const ChangeLanguageDialog(),
// // //                                 );
// // //                               },
// // //                             ),
// // //                           ],
// // //                         ),
// // //                         const SizedBox(height: 24),

// // //                          _SectionTitle(title: 'Notification Preferences'.tr()),
// // //                         const SizedBox(height: 8),
// // //                         _SettingsCard(
// // //                           children: [
// // //                             _SettingsTile(
// // //                               title: 'Push Notifications'.tr(),
// // //                               icon: Icons.notifications_none_rounded,
// // //                               trailing: Switch(
// // //                                 value: _pushEnabled,
// // //                                 activeColor: AppColors.primary,
// // //                                 onChanged: (value) {
// // //                                   setState(() => _pushEnabled = value);
// // //                                 },
// // //                               ),
// // //                             ),
// // //                             const _TileDivider(),
// // //                             _SettingsTile(
// // //                               title: 'SMS Reminders'.tr(),
// // //                               icon: Icons.chat_bubble_outline_rounded,
// // //                               trailing: Switch(
// // //                                 value: _smsEnabled,
// // //                                 activeColor: AppColors.primary,
// // //                                 onChanged: (value) {
// // //                                   setState(() => _smsEnabled = value);
// // //                                 },
// // //                               ),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                         const SizedBox(height: 24),
// // //                         const SizedBox(height: 20),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _SectionTitle extends StatelessWidget {
// // //   final String title;

// // //   const _SectionTitle({required this.title});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Text(
// // //       title,
// // //       textAlign: TextAlign.left,
// // //       style: TextStyle(
// // //         fontSize: 14,
// // //         fontWeight: FontWeight.w600,
// // //         color: Theme.of(context).colorScheme.onSurface,
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _SettingsCard extends StatelessWidget {
// // //   final List<Widget> children;

// // //   const _SettingsCard({required this.children});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       decoration: BoxDecoration(
// // //         color: Theme.of(context).colorScheme.surface,
// // //         borderRadius: BorderRadius.circular(16),
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: Theme.of(context).colorScheme.shadow,
// // //             blurRadius: 8,
// // //             offset: const Offset(0, 2),
// // //           ),
// // //         ],
// // //       ),
// // //       child: Column(children: children),
// // //     );
// // //   }
// // // }

// // // class _TileDivider extends StatelessWidget {
// // //   const _TileDivider();

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Divider(
// // //       height: 1,
// // //       indent: 16,
// // //       endIndent: 16,
// // //       color: Theme.of(context).colorScheme.outlineVariant,
// // //     );
// // //   }
// // // }

// // // class _SettingsTile extends StatelessWidget {
// // //   final String title;
// // //   final IconData icon;
// // //   final Widget trailing;
// // //   final VoidCallback? onTap;

// // //   const _SettingsTile({
// // //     required this.title,
// // //     required this.icon,
// // //     required this.trailing,
// // //     this.onTap,
// // //   });

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return InkWell(
// // //       onTap: onTap,
// // //       borderRadius: BorderRadius.circular(16),
// // //       child: Padding(
// // //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// // //         child: Row(
// // //           children: [
// // //             Container(
// // //               padding: const EdgeInsets.all(8),
// // //               decoration: BoxDecoration(
// // //                 color: Theme.of(context).colorScheme.surfaceContainerHighest,
// // //                 borderRadius: BorderRadius.circular(10),
// // //               ),
// // //               child: Icon(
// // //                 icon,
// // //                 size: 20,
// // //                 color: Theme.of(context).colorScheme.primary,
// // //               ),
// // //             ),
// // //             const SizedBox(width: 12),
// // //             Expanded(
// // //               child: Text(
// // //                 title,
// // //                 textAlign: TextAlign.left,
// // //                 style: TextStyle(
// // //                   fontSize: 14,
// // //                   color: Theme.of(context).colorScheme.onSurface,
// // //                 ),
// // //               ),
// // //             ),
// // //             const SizedBox(width: 8),
// // //             trailing,
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:dental_app/core/theme/app_colors.dart';
// // import 'package:dental_app/core/theme/bloc/theme_bloc_bloc.dart';
// // import 'package:dental_app/core/theme/bloc/theme_bloc_event.dart';
// // import 'package:dental_app/core/theme/bloc/theme_bloc_state.dart';
// // import 'package:dental_app/features/change_language/presentation/widgets/change_language.dart';
// // import 'package:dental_app/features/change_passwors/presentation/pages/change_password_page.dart';
// // import 'package:dental_app/features/change_phone_number/presentation/pages/change_phone_number.dart';
// // import 'package:easy_localization/easy_localization.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';

// // class AccountSettings extends StatefulWidget {
// //   const AccountSettings({super.key});

// //   @override
// //   State<AccountSettings> createState() => _AccountSettingsState();
// // }

// // class _AccountSettingsState extends State<AccountSettings> {
// //   bool _biometricsEnabled = true;
// //   bool _pushEnabled = true;
// //   bool _smsEnabled = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(
// //           'Account & Security Settings'.tr(),
// //           textAlign: TextAlign.center,
// //           style: TextStyle(
// //             fontSize: 18,
// //             fontWeight: FontWeight.bold,
// //             color: Theme.of(context).colorScheme.primary,
// //           ),
// //         ),
// //       ),
// //       backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
// //       body: SizedBox.expand(
// //         child: Stack(
// //           children: [
// //             Positioned.fill(
// //               child: Image.asset(
// //                 'assets/backgrounds/background5.png',
// //                 color: Theme.of(context).colorScheme.primary,
// //                 fit: BoxFit.cover,
// //               ),
// //             ),
// //             SafeArea(
// //               child: Column(
// //                 children: [
// //                   Expanded(
// //                     child: ListView(
// //                       padding: const EdgeInsets.symmetric(horizontal: 20),
// //                       children: [
// //                         const SizedBox(height: 8),
// //                         _SectionTitle(title: "Security Settings".tr()),
// //                         const SizedBox(height: 8),
// //                         _SettingsCard(
// //                           children: [
// //                             _SettingsTile(
// //                               title: 'Change phone number'.tr(),
// //                               icon: Icons.phone,
// //                               trailing: _TrailingChevron(
// //                                 color: Theme.of(context)
// //                                     .colorScheme
// //                                     .onSurfaceVariant,
// //                               ),
// //                               onTap: () {
// //                                 Navigator.push(
// //                                   context,
// //                                   MaterialPageRoute(
// //                                     builder: (context) =>
// //                                         ChangePhonenumberPage(),
// //                                   ),
// //                                 );
// //                               },
// //                             ),
// //                             const _TileDivider(),
// //                             _SettingsTile(
// //                               title: 'Change password'.tr(),
// //                               icon: Icons.lock_outline,
// //                               trailing: _TrailingChevron(
// //                                 color: Theme.of(context)
// //                                     .colorScheme
// //                                     .onSurfaceVariant,
// //                               ),
// //                               onTap: () {
// //                                 Navigator.push(
// //                                   context,
// //                                   MaterialPageRoute(
// //                                     builder: (context) =>
// //                                         ChangePasswordPage(),
// //                                   ),
// //                                 );
// //                               },
// //                             ),
// //                             const _TileDivider(),
// //                             _SettingsTile(
// //                               title: 'Biometric Login'.tr(),
// //                               icon: Icons.fingerprint,
// //                               trailing: Switch(
// //                                 value: _biometricsEnabled,
// //                                 activeColor: AppColors.primary,
// //                                 onChanged: (value) {
// //                                   setState(() => _biometricsEnabled = value);
// //                                 },
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         const SizedBox(height: 24),

// //                         _SectionTitle(title: 'Appearance'.tr()),
// //                         const SizedBox(height: 8),
// //                         _SettingsCard(
// //                           children: [
// //                             _SettingsTile(
// //                               title: "Theme".tr(),
// //                               icon: Icons.dark_mode_outlined,
// //                               trailing: BlocBuilder<ThemeBloc, ThemeState>(
// //                                 builder: (context, state) {
// //                                   return Switch(
// //                                     value: state.themeMode == ThemeMode.dark,
// //                                     activeColor: AppColors.primary,
// //                                     onChanged: (_) {
// //                                       context
// //                                           .read<ThemeBloc>()
// //                                           .add(ToggleTheme());
// //                                     },
// //                                   );
// //                                 },
// //                               ),
// //                             ),
// //                             const _TileDivider(),
// //                             _SettingsTile(
// //                               title: 'App Language'.tr(),
// //                               icon: Icons.language,
// //                               trailing: _TrailingChevron(
// //                                 color: Theme.of(context)
// //                                     .colorScheme
// //                                     .onSurfaceVariant,
// //                               ),
// //                               onTap: () {
// //                                 showDialog(
// //                                   context: context,
// //                                   builder: (_) => const ChangeLanguageDialog(),
// //                                 );
// //                               },
// //                             ),
// //                           ],
// //                         ),
// //                         const SizedBox(height: 24),

// //                         _SectionTitle(title: 'Notification Preferences'.tr()),
// //                         const SizedBox(height: 8),
// //                         _SettingsCard(
// //                           children: [
// //                             _SettingsTile(
// //                               title: 'Push Notifications'.tr(),
// //                               icon: Icons.notifications_none_rounded,
// //                               trailing: Switch(
// //                                 value: _pushEnabled,
// //                                 activeColor: AppColors.primary,
// //                                 onChanged: (value) {
// //                                   setState(() => _pushEnabled = value);
// //                                 },
// //                               ),
// //                             ),
// //                             const _TileDivider(),
// //                             _SettingsTile(
// //                               title: 'SMS Reminders'.tr(),
// //                               icon: Icons.chat_bubble_outline_rounded,
// //                               trailing: Switch(
// //                                 value: _smsEnabled,
// //                                 activeColor: AppColors.primary,
// //                                 onChanged: (value) {
// //                                   setState(() => _smsEnabled = value);
// //                                 },
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         const SizedBox(height: 24),
// //                         const SizedBox(height: 20),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // /// سهم يتبع اتجاه اللغة تلقائياً:
// // /// يشاور يمين بالإنجليزي (LTR) ويسار بالعربي (RTL)
// // class _TrailingChevron extends StatelessWidget {
// //   final Color color;

// //   const _TrailingChevron({required this.color});

// //   @override
// //   Widget build(BuildContext context) {
// //     final isRtl = Directionality.of(context) == TextDirection.RTL;
// //     return Icon(
// //       isRtl ? Icons.chevron_left : Icons.chevron_right,
// //       color: color,
// //     );
// //   }
// // }

// // class _SectionTitle extends StatelessWidget {
// //   final String title;

// //   const _SectionTitle({required this.title});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Text(
// //       title,
// //       textAlign: TextAlign.start,
// //       style: TextStyle(
// //         fontSize: 14,
// //         fontWeight: FontWeight.w600,
// //         color: Theme.of(context).colorScheme.onSurface,
// //       ),
// //     );
// //   }
// // }

// // class _SettingsCard extends StatelessWidget {
// //   final List<Widget> children;

// //   const _SettingsCard({required this.children});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Theme.of(context).colorScheme.surface,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Theme.of(context).colorScheme.shadow,
// //             blurRadius: 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Column(children: children),
// //     );
// //   }
// // }

// // class _TileDivider extends StatelessWidget {
// //   const _TileDivider();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Divider(
// //       height: 1,
// //       indent: 16,
// //       endIndent: 16,
// //       color: Theme.of(context).colorScheme.outlineVariant,
// //     );
// //   }
// // }

// // class _SettingsTile extends StatelessWidget {
// //   final String title;
// //   final IconData icon;
// //   final Widget trailing;
// //   final VoidCallback? onTap;

// //   const _SettingsTile({
// //     required this.title,
// //     required this.icon,
// //     required this.trailing,
// //     this.onTap,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return InkWell(
// //       onTap: onTap,
// //       borderRadius: BorderRadius.circular(16),
// //       child: Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// //         child: Row(
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.all(8),
// //               decoration: BoxDecoration(
// //                 color: Theme.of(context).colorScheme.surfaceContainerHighest,
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //               child: Icon(
// //                 icon,
// //                 size: 20,
// //                 color: Theme.of(context).colorScheme.primary,
// //               ),
// //             ),
// //             const SizedBox(width: 12),
// //             Expanded(
// //               child: Text(
// //                 title,
// //                 textAlign: TextAlign.start,
// //                 style: TextStyle(
// //                   fontSize: 14,
// //                   color: Theme.of(context).colorScheme.onSurface,
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(width: 8),
// //             trailing,
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:dental_app/core/theme/app_colors.dart';
// import 'package:dental_app/core/theme/bloc/theme_bloc_bloc.dart';
// import 'package:dental_app/core/theme/bloc/theme_bloc_event.dart';
// import 'package:dental_app/core/theme/bloc/theme_bloc_state.dart';
// import 'package:dental_app/core/utils/shared_prefs.dart';
// import 'package:dental_app/core/widgets/app_text_field.dart';
// import 'package:dental_app/core/widgets/dialog.dart';
// import 'package:dental_app/features/biometric_auth/presentation/bloc/biometric_bloc.dart';
// import 'package:dental_app/features/change_language/presentation/widgets/change_language.dart';
// import 'package:dental_app/features/change_passwors/presentation/pages/change_password_page.dart';
// import 'package:dental_app/features/change_phone_number/presentation/pages/change_phone_number.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class AccountSettings extends StatefulWidget {
//   const AccountSettings({super.key});

//   @override
//   State<AccountSettings> createState() => _AccountSettingsState();
// }

// class _AccountSettingsState extends State<AccountSettings> {
//   bool _biometricsEnabled = false; // القيمة الأولية، رح نحمّلها من التخزين
//   bool _pushEnabled = true;
//   bool _smsEnabled = false;
//   bool _biometricsLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadBiometricPreference();
//   }

//   Future<void> _loadBiometricPreference() async {
//     final enabled = await SharedPrefs.isBiometricEnabled();
//     if (!mounted) return;
//     setState(() {
//       _biometricsEnabled = enabled;
//       _biometricsLoading = false;
//     });
//   }

//   /// Same visual language as [CustomStatusDialog], with a password field.
//   Future<String?> _askPasswordToEnableBiometric() {
//     return showDialog<String>(
//       context: context,
//       barrierDismissible: false,
//       builder: (dialogContext) => const _BiometricPasswordDialog(),
//     );
//   }

//   Future<void> _onBiometricSwitchChanged(
//     BuildContext context,
//     bool value,
//   ) async {
//     if (!value) {
//       context.read<BiometricBloc>().add(
//             ToggleBiometricRequested(enabled: false),
//           );
//       return;
//     }

//     final phone = await SharedPrefs.getPhone();
//     if (!context.mounted) return;

//     if (phone == null || phone.isEmpty) {
//       await CustomStatusDialog.show(
//         context,
//         type: StatusDialogType.biometricFailed,
//         customDescription:
//             'Sign in with your password once to finish biometric setup'.tr(),
//         onConfirm: () {},
//       );
//       return;
//     }

//     final password = await _askPasswordToEnableBiometric();
//     if (!context.mounted || password == null || password.isEmpty) return;

//     context.read<BiometricBloc>().add(
//           ToggleBiometricRequested(
//             enabled: true,
//             phone: phone,
//             password: password,
//           ),
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => BiometricBloc(),
//       child: BlocConsumer<BiometricBloc, BiometricState>(
//         listener: (context, state) {
//           if (state is BiometricToggleSuccess) {
//             setState(() => _biometricsEnabled = state.enabled);
//             if (state.enabled) {
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 if (!context.mounted) return;
//                 CustomStatusDialog.show(
//                   context,
//                   type: StatusDialogType.biometricEnabled,
//                   onConfirm: () {},
//                 );
//               });
//             }
//           } else if (state is BiometricToggleFailure) {
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               if (!context.mounted) return;
//               CustomStatusDialog.show(
//                 context,
//                 type: StatusDialogType.biometricFailed,
//                 customDescription: state.errMessage.tr(),
//                 onConfirm: () {},
//               );
//             });
//           }
//         },
//         builder: (context, state) {
//           final isToggling = state is BiometricToggleLoading;

//           return Scaffold(
//             appBar: AppBar(
//               title: Text(
//                 'Account & Security Settings'.tr(),
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//               ),
//             ),
//             backgroundColor:
//                 Theme.of(context).colorScheme.surfaceContainerHighest,
//             body: SizedBox.expand(
//               child: Stack(
//                 children: [
//                   Positioned.fill(
//                     child: Image.asset(
//                       'assets/backgrounds/background5.png',
//                       color: Theme.of(context).colorScheme.primary,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   SafeArea(
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: ListView(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 20),
//                             children: [
//                               const SizedBox(height: 8),
//                               _SectionTitle(title: "Security Settings".tr()),
//                               const SizedBox(height: 8),
//                               _SettingsCard(
//                                 children: [
//                                   _SettingsTile(
//                                     title: 'Change phone number'.tr(),
//                                     icon: Icons.phone,
//                                     trailing: _TrailingChevron(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSurfaceVariant,
//                                     ),
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               ChangePhonenumberPage(),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                   const _TileDivider(),
//                                   _SettingsTile(
//                                     title: 'Change password'.tr(),
//                                     icon: Icons.lock_outline,
//                                     trailing: _TrailingChevron(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSurfaceVariant,
//                                     ),
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               ChangePasswordPage(),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                   const _TileDivider(),
//                                   _SettingsTile(
//                                     title: 'Biometric Login'.tr(),
//                                     icon: Icons.fingerprint,
//                                     trailing: _biometricsLoading
//                                         ? const SizedBox(
//                                             width: 20,
//                                             height: 20,
//                                             child: CircularProgressIndicator(
//                                                 strokeWidth: 2),
//                                           )
//                                         : Switch(
//                                             value: _biometricsEnabled,
//                                             activeColor: AppColors.primary,
//                                             onChanged: isToggling
//                                                 ? null
//                                                 : (value) =>
//                                                     _onBiometricSwitchChanged(
//                                                       context,
//                                                       value,
//                                                     ),
//                                           ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 24),

//                               _SectionTitle(title: 'Appearance'.tr()),
//                               const SizedBox(height: 8),
//                               _SettingsCard(
//                                 children: [
//                                   _SettingsTile(
//                                     title: "Theme".tr(),
//                                     icon: Icons.dark_mode_outlined,
//                                     trailing:
//                                         BlocBuilder<ThemeBloc, ThemeState>(
//                                       builder: (context, state) {
//                                         return Switch(
//                                           value:
//                                               state.themeMode == ThemeMode.dark,
//                                           activeColor: AppColors.primary,
//                                           onChanged: (_) {
//                                             context
//                                                 .read<ThemeBloc>()
//                                                 .add(ToggleTheme());
//                                           },
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                   const _TileDivider(),
//                                   _SettingsTile(
//                                     title: 'App Language'.tr(),
//                                     icon: Icons.language,
//                                     trailing: _TrailingChevron(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .onSurfaceVariant,
//                                     ),
//                                     onTap: () {
//                                       showDialog(
//                                         context: context,
//                                         builder: (_) =>
//                                             const ChangeLanguageDialog(),
//                                       );
//                                     },
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 24),

//                               _SectionTitle(
//                                   title: 'Notification Preferences'.tr()),
//                               const SizedBox(height: 8),
//                               _SettingsCard(
//                                 children: [
//                                   _SettingsTile(
//                                     title: 'Push Notifications'.tr(),
//                                     icon: Icons.notifications_none_rounded,
//                                     trailing: Switch(
//                                       value: _pushEnabled,
//                                       activeColor: AppColors.primary,
//                                       onChanged: (value) {
//                                         setState(() => _pushEnabled = value);
//                                       },
//                                     ),
//                                   ),
//                                   const _TileDivider(),
//                                   _SettingsTile(
//                                     title: 'SMS Reminders'.tr(),
//                                     icon: Icons.chat_bubble_outline_rounded,
//                                     trailing: Switch(
//                                       value: _smsEnabled,
//                                       activeColor: AppColors.primary,
//                                       onChanged: (value) {
//                                         setState(() => _smsEnabled = value);
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 24),
//                               const SizedBox(height: 20),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// /// سهم يتبع اتجاه اللغة تلقائياً
// class _TrailingChevron extends StatelessWidget {
//   final Color color;

//   const _TrailingChevron({required this.color});

//   @override
//   Widget build(BuildContext context) {
//     final isRtl = Directionality.of(context) == TextDirection.RTL;
//     return Icon(
//       isRtl ? Icons.chevron_left : Icons.chevron_right,
//       color: color,
//     );
//   }
// }

// class _SectionTitle extends StatelessWidget {
//   final String title;

//   const _SectionTitle({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       title,
//       textAlign: TextAlign.start,
//       style: TextStyle(
//         fontSize: 14,
//         fontWeight: FontWeight.w600,
//         color: Theme.of(context).colorScheme.onSurface,
//       ),
//     );
//   }
// }

// /// Owns its [TextEditingController] so it is disposed with the route,
// /// not while the dialog exit animation is still running.
// class _BiometricPasswordDialog extends StatefulWidget {
//   const _BiometricPasswordDialog();

//   @override
//   State<_BiometricPasswordDialog> createState() =>
//       _BiometricPasswordDialogState();
// }

// class _BiometricPasswordDialogState extends State<_BiometricPasswordDialog> {
//   final _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(24),
//       ),
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 Icons.fingerprint,
//                 size: 56,
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 'Enable Biometric Login'.tr(),
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 'Enter your password to enable biometric login'.tr(),
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Theme.of(context)
//                       .colorScheme
//                       .onSurface
//                       .withOpacity(0.7),
//                   height: 1.4,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               AppTextField(
//                 controller: _passwordController,
//                 hint: 'Password'.tr(),
//                 isPassword: true,
//                 prefixIcon: Icons.lock_outline,
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return 'Password is required'.tr();
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.pop(context),
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         side: BorderSide(
//                           color: Theme.of(context).colorScheme.primary,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                       ),
//                       child: Text(
//                         'Cancel'.tr(),
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.primary,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (!(_formKey.currentState?.validate() ?? false)) {
//                           return;
//                         }
//                         Navigator.pop(context, _passwordController.text);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             Theme.of(context).colorScheme.primary,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                       ),
//                       child: Text(
//                         'Enable'.tr(),
//                         style: TextStyle(
//                           color:
//                               Theme.of(context).scaffoldBackgroundColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _SettingsCard extends StatelessWidget {
//   final List<Widget> children;

//   const _SettingsCard({required this.children});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surface,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Theme.of(context).colorScheme.shadow,
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(children: children),
//     );
//   }
// }

// class _TileDivider extends StatelessWidget {
//   const _TileDivider();

//   @override
//   Widget build(BuildContext context) {
//     return Divider(
//       height: 1,
//       indent: 16,
//       endIndent: 16,
//       color: Theme.of(context).colorScheme.outlineVariant,
//     );
//   }
// }

// class _SettingsTile extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final Widget trailing;
//   final VoidCallback? onTap;

//   const _SettingsTile({
//     required this.title,
//     required this.icon,
//     required this.trailing,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.surfaceContainerHighest,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(
//                 icon,
//                 size: 20,
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 title,
//                 textAlign: TextAlign.start,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             trailing,
//           ],
//         ),
//       ),
//     );
//   }
// }
// // // import 'package:dental_app/core/theme/app_colors.dart';
// // // import 'package:dental_app/core/theme/bloc/theme_bloc_bloc.dart';
// // // import 'package:dental_app/core/theme/bloc/theme_bloc_event.dart';
// // // import 'package:dental_app/core/theme/bloc/theme_bloc_state.dart';
// // // import 'package:dental_app/features/change_language/presentation/widgets/change_language.dart';
// // // import 'package:dental_app/features/change_passwors/presentation/pages/change_password_page.dart';
// // // import 'package:dental_app/features/change_phone_number/presentation/pages/change_phone_number.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_bloc/flutter_bloc.dart';

// // // class AccountSettings extends StatefulWidget {
// // //   const AccountSettings({super.key});

// // //   @override
// // //   State<AccountSettings> createState() => _AccountSettingsState();
// // // }

// // // class _AccountSettingsState extends State<AccountSettings> {
// // //   bool _biometricsEnabled = true;
// // //   bool _pushEnabled = true;
// // //   bool _smsEnabled = false;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Directionality(
// // //       textDirection: TextDirection.ltr,
// // //       child: Scaffold(
// // //         appBar: AppBar(
// // //           title: Text(
// // //             'App and Security Settings',
// // //             textAlign: TextAlign.center,
// // //             style: TextStyle(
// // //               fontSize: 18,
// // //               fontWeight: FontWeight.bold,
// // //               color: Theme.of(context).colorScheme.primary,
// // //             ),
// // //           ),
// // //         ),
// // //         backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
// // //         body: SizedBox.expand(
// // //           child: Stack(
// // //             children: [
// // //               Positioned.fill(
// // //                 child: Image.asset(
// // //                   'assets/backgrounds/background5.png',
// // //                   fit: BoxFit.cover,
// // //                   color: Theme.of(context).colorScheme.onSurface,
// // //                 ),
// // //               ),
// // //               SafeArea(
// // //                 child: Column(
// // //                   children: [
// // //                     Expanded(
// // //                       child: ListView(
// // //                         padding: const EdgeInsets.symmetric(horizontal: 20),
// // //                         children: [
// // //                           const SizedBox(height: 8),
// // //                           const _SectionTitle(title: "Security Settings"),
// // //                           const SizedBox(height: 8),
// // //                           _SettingsCard(
// // //                             children: [
// // //                               _SettingsTile(
// // //                                 title: 'Change phone number',
// // //                                 icon: Icons.phone,
// // //                                 trailing: const Icon(
// // //                                   Icons.chevron_right,
// // //                                   color: Colors.black45,
// // //                                 ),
// // //                                 onTap: () {
// // //                                   Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePhonenumberPage(),));
// // //                                 },
// // //                               ),
// // //                               const _TileDivider(),
// // //                               _SettingsTile(
// // //                                 title: 'Change password',
// // //                                 icon: Icons.lock_outline,
// // //                                 trailing: const Icon(
// // //                                   Icons.chevron_right,
// // //                                   color: Colors.black45,
// // //                                 ),
// // //                                 onTap: () {
// // //                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordPage()));
// // //                                 },
// // //                               ),
// // //                               const _TileDivider(),
// // //                               _SettingsTile(
// // //                                 title: 'Enable fingerprint login\n(Biometrics)',
// // //                                 icon: Icons.fingerprint,
// // //                                 trailing: Switch(
// // //                                   value: _biometricsEnabled,
// // //                                   activeColor: AppColors.primary,
// // //                                   onChanged: (value) {
// // //                                     setState(() => _biometricsEnabled = value);
// // //                                   },
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                           const SizedBox(height: 24),

// // // const _SectionTitle(title: 'Appearance'),
// // //                           const SizedBox(height: 8),
// // //                           _SettingsCard(
// // //                             children: [
// // //                               _SettingsTile(
// // //   title: "Theme",
// // //   icon: Icons.dark_mode_outlined,
// // //   trailing: BlocBuilder<ThemeBloc, ThemeState>(
// // //     builder: (context, state) {
// // //       return Switch(
// // //         value: state.themeMode == ThemeMode.dark,
// // //         activeColor: AppColors.primary,
// // //         onChanged: (_) {
// // //           context.read<ThemeBloc>().add(ToggleTheme());
// // //         },
// // //       );
// // //     },
// // //   ),
// // // ),

// // // const _TileDivider(),
// // //                              _SettingsTile(
// // //       title: "Application Language",
// // //       icon: Icons.language,
// // //       trailing: const Icon(
// // //         Icons.chevron_right,
// // //         color: Colors.black45,
// // //       ),
// // //       onTap: () {
// // //   showDialog(
// // //     context: context,
// // //     builder: (_) => const ChangeLanguageDialog(),
// // //   );
// // // }
// // //     ),

// // //                             ],
// // //                           ),

// // // const SizedBox(height: 24),

// // //                           const _SectionTitle(title: 'Notification Preferences'),
// // //                           const SizedBox(height: 8),
// // //                           _SettingsCard(
// // //                             children: [
// // //                               _SettingsTile(
// // //                                 title: 'Instant push notifications\n(Notifications)',
// // //                                 icon: Icons.notifications_none_rounded,
// // //                                 trailing: Switch(
// // //                                   value: _pushEnabled,
// // //                                   activeColor: AppColors.primary,
// // //                                   onChanged: (value) {
// // //                                     setState(() => _pushEnabled = value);
// // //                                   },
// // //                                 ),
// // //                               ),
// // //                               const _TileDivider(),
// // //                               _SettingsTile(
// // //                                 title: 'SMS text reminders\n(Alerts)',
// // //                                 icon: Icons.chat_bubble_outline_rounded,
// // //                                 trailing: Switch(
// // //                                   value: _smsEnabled,
// // //                                   activeColor: AppColors.primary,
// // //                                   onChanged: (value) {
// // //                                     setState(() => _smsEnabled = value);
// // //                                   },
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                           const SizedBox(height: 24),
// // //                           const SizedBox(height: 20),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _SectionTitle extends StatelessWidget {
// // //   final String title;

// // //   const _SectionTitle({required this.title});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Text(
// // //       title,
// // //       textAlign: TextAlign.left,
// // //       style: const TextStyle(
// // //         fontSize: 14,
// // //         fontWeight: FontWeight.w600,
// // //         color: Colors.black87,
// // //       ),
// // //     );
// // //   }
// // // }

// // // class _SettingsCard extends StatelessWidget {
// // //   final List<Widget> children;

// // //   const _SettingsCard({required this.children});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       decoration: BoxDecoration(
// // //         color: Theme.of(context).colorScheme.surface,
// // //         borderRadius: BorderRadius.circular(16),
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: Theme.of(context).colorScheme.shadow,
// // //             blurRadius: 8,
// // //             offset: const Offset(0, 2),
// // //           ),
// // //         ],
// // //       ),
// // //       child: Column(children: children),
// // //     );
// // //   }
// // // }

// // // class _TileDivider extends StatelessWidget {
// // //   const _TileDivider();

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Divider(
// // //       height: 1,
// // //       indent: 16,
// // //       endIndent: 16,
// // //       color: Colors.grey.shade200,
// // //     );
// // //   }
// // // }

// // // class _SettingsTile extends StatelessWidget {
// // //   final String title;
// // //   final IconData icon;
// // //   final Widget trailing;
// // //   final VoidCallback? onTap;

// // //   const _SettingsTile({
// // //     required this.title,
// // //     required this.icon,
// // //     required this.trailing,
// // //     this.onTap,
// // //   });

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return InkWell(
// // //       onTap: onTap,
// // //       borderRadius: BorderRadius.circular(16),
// // //       child: Padding(
// // //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// // //         child: Row(
// // //           children: [
// // //             Container(
// // //               padding: const EdgeInsets.all(8),
// // //               decoration: BoxDecoration(
// // //                 color: Colors.grey.shade100,
// // //                 borderRadius: BorderRadius.circular(10),
// // //               ),
// // //               child: Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurface),
// // //             ),
// // //             const SizedBox(width: 12),
// // //             Expanded(
// // //               child: Text(
// // //                 title,
// // //                 textAlign: TextAlign.left,
// // //                 style: const TextStyle(fontSize: 14),
// // //               ),
// // //             ),
// // //             const SizedBox(width: 8),
// // //             trailing,
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:dental_app/core/theme/app_colors.dart';
// // import 'package:dental_app/core/theme/bloc/theme_bloc_bloc.dart';
// // import 'package:dental_app/core/theme/bloc/theme_bloc_event.dart';
// // import 'package:dental_app/core/theme/bloc/theme_bloc_state.dart';
// // import 'package:dental_app/features/change_language/presentation/widgets/change_language.dart';
// // import 'package:dental_app/features/change_passwors/presentation/pages/change_password_page.dart';
// // import 'package:dental_app/features/change_phone_number/presentation/pages/change_phone_number.dart';
// // import 'package:easy_localization/easy_localization.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';

// // class AccountSettings extends StatefulWidget {
// //   const AccountSettings({super.key});

// //   @override
// //   State<AccountSettings> createState() => _AccountSettingsState();
// // }

// // class _AccountSettingsState extends State<AccountSettings> {
// //   bool _biometricsEnabled = true;
// //   bool _pushEnabled = true;
// //   bool _smsEnabled = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(
// //           'Account & Security Settings'.tr(),
// //           textAlign: TextAlign.center,
// //           style: TextStyle(
// //             fontSize: 18,
// //             fontWeight: FontWeight.bold,
// //             color: Theme.of(context).colorScheme.primary,
// //           ),
// //         ),
// //       ),
// //       backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
// //       body: SizedBox.expand(
// //         child: Stack(
// //           children: [
// //             Positioned.fill(
// //               child: Image.asset(
// //                 'assets/backgrounds/background5.png',
// //                 color:Theme.of(context).colorScheme.primary,
// //                 fit: BoxFit.cover,
// //               ),
// //             ),
// //             SafeArea(
// //               child: Column(
// //                 children: [
// //                   Expanded(
// //                     child: ListView(
// //                       padding: const EdgeInsets.symmetric(horizontal: 20),
// //                       children: [
// //                         const SizedBox(height: 8),
// //                          _SectionTitle(title: "Security Settings".tr()),
// //                         const SizedBox(height: 8),
// //                         _SettingsCard(
// //                           children: [
// //                             _SettingsTile(
// //                               title: 'Change phone number'.tr(),
// //                               icon: Icons.phone,
// //                               trailing: Icon(
// //                                 Icons.chevron_right,
// //                                 color: Theme.of(context)
// //                                     .colorScheme
// //                                     .onSurfaceVariant,
// //                               ),
// //                               onTap: () {
// //                                 Navigator.push(
// //                                   context,
// //                                   MaterialPageRoute(
// //                                     builder: (context) =>
// //                                         ChangePhonenumberPage(),
// //                                   ),
// //                                 );
// //                               },
// //                             ),
// //                             const _TileDivider(),
// //                             _SettingsTile(
// //                               title: 'Change password'.tr(),
// //                               icon: Icons.lock_outline,
// //                               trailing: Icon(
// //                                 Icons.chevron_right,
// //                                 color: Theme.of(context)
// //                                     .colorScheme
// //                                     .onSurfaceVariant,
// //                               ),
// //                               onTap: () {
// //                                 Navigator.push(
// //                                   context,
// //                                   MaterialPageRoute(
// //                                     builder: (context) =>
// //                                         ChangePasswordPage(),
// //                                   ),
// //                                 );
// //                               },
// //                             ),
// //                             const _TileDivider(),
// //                             _SettingsTile(
// //                               title: 'Biometric Login'.tr(),
// //                               icon: Icons.fingerprint,
// //                               trailing: Switch(
// //                                 value: _biometricsEnabled,
// //                                 activeColor: AppColors.primary,
// //                                 onChanged: (value) {
// //                                   setState(() => _biometricsEnabled = value);
// //                                 },
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         const SizedBox(height: 24),

// //                          _SectionTitle(title: 'Appearance'.tr()),
// //                         const SizedBox(height: 8),
// //                         _SettingsCard(
// //                           children: [
// //                             _SettingsTile(
// //                               title: "Theme".tr(),
// //                               icon: Icons.dark_mode_outlined,
// //                               trailing: BlocBuilder<ThemeBloc, ThemeState>(
// //                                 builder: (context, state) {
// //                                   return Switch(
// //                                     value: state.themeMode == ThemeMode.dark,
// //                                     activeColor: AppColors.primary,
// //                                     onChanged: (_) {
// //                                       context
// //                                           .read<ThemeBloc>()
// //                                           .add(ToggleTheme());
// //                                     },
// //                                   );
// //                                 },
// //                               ),
// //                             ),
// //                             const _TileDivider(),
// //                             _SettingsTile(
// //                               title: 'App Language'.tr(),
// //                               icon: Icons.language,
// //                               trailing: Icon(
// //                                 Icons.chevron_right,
// //                                 color: Theme.of(context)
// //                                     .colorScheme
// //                                     .onSurfaceVariant,
// //                               ),
// //                               onTap: () {
// //                                 showDialog(
// //                                   context: context,
// //                                   builder: (_) => const ChangeLanguageDialog(),
// //                                 );
// //                               },
// //                             ),
// //                           ],
// //                         ),
// //                         const SizedBox(height: 24),

// //                          _SectionTitle(title: 'Notification Preferences'.tr()),
// //                         const SizedBox(height: 8),
// //                         _SettingsCard(
// //                           children: [
// //                             _SettingsTile(
// //                               title: 'Push Notifications'.tr(),
// //                               icon: Icons.notifications_none_rounded,
// //                               trailing: Switch(
// //                                 value: _pushEnabled,
// //                                 activeColor: AppColors.primary,
// //                                 onChanged: (value) {
// //                                   setState(() => _pushEnabled = value);
// //                                 },
// //                               ),
// //                             ),
// //                             const _TileDivider(),
// //                             _SettingsTile(
// //                               title: 'SMS Reminders'.tr(),
// //                               icon: Icons.chat_bubble_outline_rounded,
// //                               trailing: Switch(
// //                                 value: _smsEnabled,
// //                                 activeColor: AppColors.primary,
// //                                 onChanged: (value) {
// //                                   setState(() => _smsEnabled = value);
// //                                 },
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         const SizedBox(height: 24),
// //                         const SizedBox(height: 20),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _SectionTitle extends StatelessWidget {
// //   final String title;

// //   const _SectionTitle({required this.title});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Text(
// //       title,
// //       textAlign: TextAlign.left,
// //       style: TextStyle(
// //         fontSize: 14,
// //         fontWeight: FontWeight.w600,
// //         color: Theme.of(context).colorScheme.onSurface,
// //       ),
// //     );
// //   }
// // }

// // class _SettingsCard extends StatelessWidget {
// //   final List<Widget> children;

// //   const _SettingsCard({required this.children});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Theme.of(context).colorScheme.surface,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Theme.of(context).colorScheme.shadow,
// //             blurRadius: 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Column(children: children),
// //     );
// //   }
// // }

// // class _TileDivider extends StatelessWidget {
// //   const _TileDivider();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Divider(
// //       height: 1,
// //       indent: 16,
// //       endIndent: 16,
// //       color: Theme.of(context).colorScheme.outlineVariant,
// //     );
// //   }
// // }

// // class _SettingsTile extends StatelessWidget {
// //   final String title;
// //   final IconData icon;
// //   final Widget trailing;
// //   final VoidCallback? onTap;

// //   const _SettingsTile({
// //     required this.title,
// //     required this.icon,
// //     required this.trailing,
// //     this.onTap,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return InkWell(
// //       onTap: onTap,
// //       borderRadius: BorderRadius.circular(16),
// //       child: Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// //         child: Row(
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.all(8),
// //               decoration: BoxDecoration(
// //                 color: Theme.of(context).colorScheme.surfaceContainerHighest,
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //               child: Icon(
// //                 icon,
// //                 size: 20,
// //                 color: Theme.of(context).colorScheme.primary,
// //               ),
// //             ),
// //             const SizedBox(width: 12),
// //             Expanded(
// //               child: Text(
// //                 title,
// //                 textAlign: TextAlign.left,
// //                 style: TextStyle(
// //                   fontSize: 14,
// //                   color: Theme.of(context).colorScheme.onSurface,
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(width: 8),
// //             trailing,
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:dental_app/core/theme/app_colors.dart';
// import 'package:dental_app/core/theme/bloc/theme_bloc_bloc.dart';
// import 'package:dental_app/core/theme/bloc/theme_bloc_event.dart';
// import 'package:dental_app/core/theme/bloc/theme_bloc_state.dart';
// import 'package:dental_app/features/change_language/presentation/widgets/change_language.dart';
// import 'package:dental_app/features/change_passwors/presentation/pages/change_password_page.dart';
// import 'package:dental_app/features/change_phone_number/presentation/pages/change_phone_number.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class AccountSettings extends StatefulWidget {
//   const AccountSettings({super.key});

//   @override
//   State<AccountSettings> createState() => _AccountSettingsState();
// }

// class _AccountSettingsState extends State<AccountSettings> {
//   bool _biometricsEnabled = true;
//   bool _pushEnabled = true;
//   bool _smsEnabled = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Account & Security Settings'.tr(),
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Theme.of(context).colorScheme.primary,
//           ),
//         ),
//       ),
//       backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
//       body: SizedBox.expand(
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: Image.asset(
//                 'assets/backgrounds/background5.png',
//                 color: Theme.of(context).colorScheme.primary,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             SafeArea(
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: ListView(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       children: [
//                         const SizedBox(height: 8),
//                         _SectionTitle(title: "Security Settings".tr()),
//                         const SizedBox(height: 8),
//                         _SettingsCard(
//                           children: [
//                             _SettingsTile(
//                               title: 'Change phone number'.tr(),
//                               icon: Icons.phone,
//                               trailing: _TrailingChevron(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onSurfaceVariant,
//                               ),
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         ChangePhonenumberPage(),
//                                   ),
//                                 );
//                               },
//                             ),
//                             const _TileDivider(),
//                             _SettingsTile(
//                               title: 'Change password'.tr(),
//                               icon: Icons.lock_outline,
//                               trailing: _TrailingChevron(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onSurfaceVariant,
//                               ),
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         ChangePasswordPage(),
//                                   ),
//                                 );
//                               },
//                             ),
//                             const _TileDivider(),
//                             _SettingsTile(
//                               title: 'Biometric Login'.tr(),
//                               icon: Icons.fingerprint,
//                               trailing: Switch(
//                                 value: _biometricsEnabled,
//                                 activeColor: AppColors.primary,
//                                 onChanged: (value) {
//                                   setState(() => _biometricsEnabled = value);
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 24),

//                         _SectionTitle(title: 'Appearance'.tr()),
//                         const SizedBox(height: 8),
//                         _SettingsCard(
//                           children: [
//                             _SettingsTile(
//                               title: "Theme".tr(),
//                               icon: Icons.dark_mode_outlined,
//                               trailing: BlocBuilder<ThemeBloc, ThemeState>(
//                                 builder: (context, state) {
//                                   return Switch(
//                                     value: state.themeMode == ThemeMode.dark,
//                                     activeColor: AppColors.primary,
//                                     onChanged: (_) {
//                                       context
//                                           .read<ThemeBloc>()
//                                           .add(ToggleTheme());
//                                     },
//                                   );
//                                 },
//                               ),
//                             ),
//                             const _TileDivider(),
//                             _SettingsTile(
//                               title: 'App Language'.tr(),
//                               icon: Icons.language,
//                               trailing: _TrailingChevron(
//                                 color: Theme.of(context)
//                                     .colorScheme
//                                     .onSurfaceVariant,
//                               ),
//                               onTap: () {
//                                 showDialog(
//                                   context: context,
//                                   builder: (_) => const ChangeLanguageDialog(),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 24),

//                         _SectionTitle(title: 'Notification Preferences'.tr()),
//                         const SizedBox(height: 8),
//                         _SettingsCard(
//                           children: [
//                             _SettingsTile(
//                               title: 'Push Notifications'.tr(),
//                               icon: Icons.notifications_none_rounded,
//                               trailing: Switch(
//                                 value: _pushEnabled,
//                                 activeColor: AppColors.primary,
//                                 onChanged: (value) {
//                                   setState(() => _pushEnabled = value);
//                                 },
//                               ),
//                             ),
//                             const _TileDivider(),
//                             _SettingsTile(
//                               title: 'SMS Reminders'.tr(),
//                               icon: Icons.chat_bubble_outline_rounded,
//                               trailing: Switch(
//                                 value: _smsEnabled,
//                                 activeColor: AppColors.primary,
//                                 onChanged: (value) {
//                                   setState(() => _smsEnabled = value);
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 24),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// سهم يتبع اتجاه اللغة تلقائياً:
// /// يشاور يمين بالإنجليزي (LTR) ويسار بالعربي (RTL)
// class _TrailingChevron extends StatelessWidget {
//   final Color color;

//   const _TrailingChevron({required this.color});

//   @override
//   Widget build(BuildContext context) {
//     final isRtl = Directionality.of(context) == TextDirection.RTL;
//     return Icon(
//       isRtl ? Icons.chevron_left : Icons.chevron_right,
//       color: color,
//     );
//   }
// }

// class _SectionTitle extends StatelessWidget {
//   final String title;

//   const _SectionTitle({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       title,
//       textAlign: TextAlign.start,
//       style: TextStyle(
//         fontSize: 14,
//         fontWeight: FontWeight.w600,
//         color: Theme.of(context).colorScheme.onSurface,
//       ),
//     );
//   }
// }

// class _SettingsCard extends StatelessWidget {
//   final List<Widget> children;

//   const _SettingsCard({required this.children});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surface,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Theme.of(context).colorScheme.shadow,
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(children: children),
//     );
//   }
// }

// class _TileDivider extends StatelessWidget {
//   const _TileDivider();

//   @override
//   Widget build(BuildContext context) {
//     return Divider(
//       height: 1,
//       indent: 16,
//       endIndent: 16,
//       color: Theme.of(context).colorScheme.outlineVariant,
//     );
//   }
// }

// class _SettingsTile extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final Widget trailing;
//   final VoidCallback? onTap;

//   const _SettingsTile({
//     required this.title,
//     required this.icon,
//     required this.trailing,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.surfaceContainerHighest,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(
//                 icon,
//                 size: 20,
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 title,
//                 textAlign: TextAlign.start,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             trailing,
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/theme/bloc/theme_bloc_bloc.dart';
import 'package:dental_app/core/theme/bloc/theme_bloc_event.dart';
import 'package:dental_app/core/theme/bloc/theme_bloc_state.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/core/widgets/app_text_field.dart';
import 'package:dental_app/core/widgets/dialog.dart';
import 'package:dental_app/features/biometric_auth/presentation/bloc/biometric_bloc.dart';
import 'package:dental_app/features/change_language/presentation/widgets/change_language.dart';
import 'package:dental_app/features/change_passwors/presentation/pages/change_password_page.dart';
import 'package:dental_app/features/change_phone_number/presentation/pages/change_phone_number.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  bool _biometricsEnabled = false; // القيمة الأولية، رح نحمّلها من التخزين
  bool _biometricsLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBiometricPreference();
  }

  Future<void> _loadBiometricPreference() async {
    final enabled = await SharedPrefs.isBiometricEnabled();
    if (!mounted) return;
    setState(() {
      _biometricsEnabled = enabled;
      _biometricsLoading = false;
    });
  }

  /// Same visual language as [CustomStatusDialog], with a password field.
  Future<String?> _askPasswordToEnableBiometric() {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const _BiometricPasswordDialog(),
    );
  }

  Future<void> _onBiometricSwitchChanged(
    BuildContext context,
    bool value,
  ) async {
    if (!value) {
      context.read<BiometricBloc>().add(
        ToggleBiometricRequested(enabled: false),
      );
      return;
    }

    final phone = await SharedPrefs.getPhone();
    if (!context.mounted) return;

    if (phone == null || phone.isEmpty) {
      await CustomStatusDialog.show(
        context,
        type: StatusDialogType.biometricFailed,
        customDescription:
            'Sign in with your password once to finish biometric setup'.tr(),
        onConfirm: () {},
      );
      return;
    }

    final password = await _askPasswordToEnableBiometric();
    if (!context.mounted || password == null || password.isEmpty) return;

    context.read<BiometricBloc>().add(
      ToggleBiometricRequested(enabled: true, phone: phone, password: password),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BiometricBloc(),
      child: BlocConsumer<BiometricBloc, BiometricState>(
        listener: (context, state) {
          if (state is BiometricToggleSuccess) {
            setState(() => _biometricsEnabled = state.enabled);
            if (state.enabled) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!context.mounted) return;
                CustomStatusDialog.show(
                  context,
                  type: StatusDialogType.biometricEnabled,
                  onConfirm: () {},
                );
              });
            }
          } else if (state is BiometricToggleFailure) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              CustomStatusDialog.show(
                context,
                type: StatusDialogType.biometricFailed,
                customDescription: state.errMessage.tr(),
                onConfirm: () {},
              );
            });
          }
        },
        builder: (context, state) {
          final isToggling = state is BiometricToggleLoading;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Account & Security Settings'.tr(),
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
                      'assets/backgrounds/background5.png',
                      color: Theme.of(context).colorScheme.primary,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            children: [
                              const SizedBox(height: 8),
                              _SectionTitle(title: "Security Settings".tr()),
                              const SizedBox(height: 8),
                              _SettingsCard(
                                children: [
                                  _SettingsTile(
                                    title: 'Change phone number'.tr(),
                                    icon: Icons.phone,
                                    trailing: _TrailingChevron(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangePhonenumberPage(),
                                        ),
                                      );
                                    },
                                  ),
                                  const _TileDivider(),
                                  _SettingsTile(
                                    title: 'Change password'.tr(),
                                    icon: Icons.lock_outline,
                                    trailing: _TrailingChevron(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangePasswordPage(),
                                        ),
                                      );
                                    },
                                  ),
                                  const _TileDivider(),
                                  _SettingsTile(
                                    title: 'Biometric Login'.tr(),
                                    icon: Icons.fingerprint,
                                    trailing: _biometricsLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Switch(
                                            value: _biometricsEnabled,
                                            activeColor: AppColors.primary,
                                            onChanged: isToggling
                                                ? null
                                                : (value) =>
                                                      _onBiometricSwitchChanged(
                                                        context,
                                                        value,
                                                      ),
                                          ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              _SectionTitle(title: 'Appearance'.tr()),
                              const SizedBox(height: 8),
                              _SettingsCard(
                                children: [
                                  _SettingsTile(
                                    title: "Theme".tr(),
                                    icon: Icons.dark_mode_outlined,
                                    trailing:
                                        BlocBuilder<ThemeBloc, ThemeState>(
                                          builder: (context, state) {
                                            return Switch(
                                              value:
                                                  state.themeMode ==
                                                  ThemeMode.dark,
                                              activeColor: AppColors.primary,
                                              onChanged: (_) {
                                                context.read<ThemeBloc>().add(
                                                  ToggleTheme(),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                  ),
                                  const _TileDivider(),
                                  _SettingsTile(
                                    title: 'App Language'.tr(),
                                    icon: Icons.language,
                                    trailing: _TrailingChevron(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) =>
                                            const ChangeLanguageDialog(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ],
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
}

/// سهم يتبع اتجاه اللغة تلقائياً
class _TrailingChevron extends StatelessWidget {
  final Color color;

  const _TrailingChevron({required this.color});

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.RTL;
    return Icon(isRtl ? Icons.chevron_left : Icons.chevron_right, color: color);
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

/// Owns its [TextEditingController] so it is disposed with the route,
/// not while the dialog exit animation is still running.
class _BiometricPasswordDialog extends StatefulWidget {
  const _BiometricPasswordDialog();

  @override
  State<_BiometricPasswordDialog> createState() =>
      _BiometricPasswordDialogState();
}

class _BiometricPasswordDialogState extends State<_BiometricPasswordDialog> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.fingerprint,
                size: 56,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                'Enable Biometric Login'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Enter your password to enable biometric login'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _passwordController,
                hint: 'Password'.tr(),
                isPassword: true,
                prefixIcon: Icons.lock_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Password is required'.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Cancel'.tr(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (!(_formKey.currentState?.validate() ?? false)) {
                          return;
                        }
                        Navigator.pop(context, _passwordController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Enable'.tr(),
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
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _TileDivider extends StatelessWidget {
  const _TileDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.title,
    required this.icon,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 8),
            trailing,
          ],
        ),
      ),
    );
  }
}
