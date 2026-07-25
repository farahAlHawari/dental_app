// import 'package:dental_app/core/theme/app_colors.dart';
// import 'package:dental_app/features/family_account/presentation/widgets/family_financial_card.dart';
// import 'package:dental_app/features/family_account/presentation/widgets/profile_card.dart';
// import 'package:flutter/material.dart';

// class FamilyAccount extends StatefulWidget {
//   const FamilyAccount({super.key});

//   @override
//   State<FamilyAccount> createState() => _FamilyAccountState();
// }

// class _FamilyAccountState extends State<FamilyAccount> {
//    final List<Map<String,dynamic>> familyMembers = [
//     {
//       "name":"Ahmad Mohammad",
//       "gender":"Male",
//       "image":"assets/images/profile1.jpg"
//     },
//     {
//       "name":"Sara Mohammad",
//       "gender":"Female",
//       "image":"assets/images/profile1.jpg"
//     },
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//        appBar: AppBar(title: Text(
//             'Family Account Management',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: AppColors.primary,
//             ),
//           )),
//       backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
//       body: SizedBox.expand(
//         child: Stack(
//           children: [Positioned.fill(
//               child: Image.asset(
//                 'assets/backgrounds/1.png',
                
//                 fit: BoxFit.cover,
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//             ),
//            SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20),

//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,

//             children: [


//               /// العنوان
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   "Family Members",
//                   style: TextStyle(
//                     fontSize: 18,color: Theme.of(context).colorScheme.onSurface,
//                     fontWeight: FontWeight.w500
//                   )
//                 ),
//               ),


//               const SizedBox(height:20),



//               /// قائمة أفراد العائلة
//               Expanded(
//                 child: ListView.builder(

//                   itemCount: familyMembers.length + 1,

//                   itemBuilder: (context,index){


//                     // آخر عنصر = كشف الحساب
//                     if(index == familyMembers.length){

//                       return const Padding(
//                         padding: EdgeInsets.only(top:20),
//                         child: FamilyFinancialCard(),
//                       );

//                     }



//                     final member =
//                     familyMembers[index];


//                     return Padding(
//                       padding:
//                       const EdgeInsets.only(bottom:16),

//                       child: ProfileCard(
//                         name: member["name"],
//                         gender: member["gender"],
//                         imagePath: member["image"],

//                         onEdit: (){
                          
//                         },

//                         onSwitchAccount: (){
//                           // Switch Account
//                         },
//                       ),
//                     );
//                   },

//                 ),
//               ),


//             ],
//           ),
//         ),
//       ),
            
//             ],
//         ),
//       ),
//     );
//   }
// }


import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/features/family_account/presentation/widgets/Add_member_card.dart';
import 'package:dental_app/features/family_account/presentation/widgets/add_member_card.dart' hide AddMemberCard;
import 'package:dental_app/features/family_account/presentation/widgets/family_financial_card.dart';
import 'package:dental_app/features/family_account/presentation/widgets/profile_card.dart';// عدّل المسار حسب مكان الملف عندك
import 'package:flutter/material.dart';
import 'package:dental_app/features/register/presentation/pages/medical_info.dart';

class FamilyAccount extends StatefulWidget {
  const FamilyAccount({super.key});

  @override
  State<FamilyAccount> createState() => _FamilyAccountState();
}

class _FamilyAccountState extends State<FamilyAccount> {
  final List<Map<String, dynamic>> familyMembers = [
    {
      "name": "Ahmad Mohammad",
      "gender": "Male",
      "image": "assets/images/profile1.jpg",
      "dob": "1995-04-12",
      "diseases": <String>["Asthma"],
      "allergies": "Penicillin",
    },
    {
      "name": "Sara Mohammad",
      "gender": "Female",
      "image": "assets/images/profile1.jpg",
      "dob": "1998-09-02",
      "diseases": <String>[],
      "allergies": "",
    },
  ];

  Future<void> _openMember(int index) async {
    // final updated = await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => MedicalInfo(patientData: familyMembers[index]),
    //   ),
    // );
    // if (updated != null) {
    //   setState(() {
    //     familyMembers[index] = {...familyMembers[index], ...updated};
    //   });
    // }
  }

  Future<void> _addMember() async {
    final newMember = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MedicalInfo()),
    );
    if (newMember != null) {
      setState(() {
        familyMembers.add({
          "image": "assets/images/profile1.jpg",
          ...newMember,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Family Account Management',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
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
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Family Members",
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: familyMembers.length + 2,
                        itemBuilder: (context, index) {
                          
                          if (index == familyMembers.length) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: AddMemberCard(onTap: _addMember),
                            );
                          }

                          // كشف الحساب المالي
                          if (index == familyMembers.length + 1) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: FamilyFinancialCard(),
                            );
                          }

                          final member = familyMembers[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ProfileCard(
                              name: member["name"],
                              gender: member["gender"],
                              imagePath: member["image"],
                              onEdit: () => _openMember(index),
                              onSwitchAccount: () {
                                // Switch Account
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}