import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/features/medical_archive/presentation/pages/medical_archive_page.dart';
import 'package:dental_app/features/profile/presentation/widgets/logout_button.dart';
import 'package:dental_app/features/profile/presentation/widgets/profile_card.dart';
import 'package:dental_app/features/profile/presentation/widgets/profile_menue_card.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
            'Profile',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          )),
      backgroundColor: const Color.fromARGB(255, 236, 242, 245),
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/backgrounds/1.png',
                fit: BoxFit.cover,
                color: AppColors.textPrimary,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  // الجزء القابل للسكرول
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      child: Column(
                        children: [
                          ProfileCard(
                            name: "mohammad Ahmad",
                            gender: "Male",
                            imagePath: "assets/images/profile1.jpg",
                            onEdit: () {},
                            onSwitchAccount: () {},
                          ),

                          const SizedBox(height: 20),

                          ProfileMenuCard(
                            title: "Account & Security Settings",
                            icon: Icon(Icons.settings_outlined,size: 20,color: Theme.of(context).colorScheme.primary,),
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => AccountSettings(),));
                            },
                          ),

                          const SizedBox(height: 12),

                          ProfileMenuCard(
                            title: "Digital Medical Records",
                            icon:  Icon(Icons.medical_services_outlined,size: 20,color: Theme.of(context).colorScheme.primary,),
                            onTap: () {
                               Navigator.push(context, MaterialPageRoute(builder: (context) => MedicalArchivePage(),));
                            },
                          ),

                          const SizedBox(height: 12),

                          ProfileMenuCard(
                            title:"Billing & Financial Statement",
                            icon:  Icon(Icons.monetization_on,size: 20,color: Theme.of(context).colorScheme.primary,),
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => FinancialPage(),));
                            },
                          ),

                          const SizedBox(height: 12),

                          ProfileMenuCard(
                            title: "Visit History",
                            icon:  Icon(Icons.calendar_today_outlined,size: 20,color: Theme.of(context).colorScheme.primary,),
                            onTap: () {
                              //  Navigator.push(context, MaterialPageRoute(builder: (context) => ArchivedVisitsPage(),));
                            },
                          ),

                          const SizedBox(height: 12),


                           ProfileMenuCard(
                            title: "Family Account Management",
                            icon:  Icon(Icons.family_restroom,size: 20,color: Theme.of(context).colorScheme.primary,),
                            onTap: () {
                            
                            },
                          ),

                          const SizedBox(height: 12),

                          ProfileMenuCard(
                            title: "contact us on Whatsapp",
                            icon:  Icon(
                              Icons.chat_outlined,
                              color: Theme.of(context).colorScheme.surface
                            ),
                            backgroundColor:Theme.of(context).colorScheme.primary,
                            textColor: Theme.of(context).colorScheme.surface,
                            showArrow: false,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),

                  
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: LogoutButton(
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}