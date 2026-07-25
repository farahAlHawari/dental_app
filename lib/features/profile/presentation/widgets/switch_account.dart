import 'package:flutter/material.dart';

class SwitchAccountBottomSheet extends StatelessWidget {
  const SwitchAccountBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Switch Account",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            _accountTile(
              context,
              "فرح الحواري",
              "Male",
              "assets/images/profile1.jpg",
            ),

            _accountTile(
              context,
              "محمد الحواري",
              "Male",
              "assets/images/profile1.jpg",
            ),

            _accountTile(
              context,
              "ريم الحواري",
              "Male",
              "assets/images/profile1.jpg",
            ),

            const SizedBox(height: 12),

            

          ],
        ),
      ),
    );
  }

  Widget _accountTile(
    BuildContext context,
    String name,
    String file,
    String image,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(image),
      ),
      title: Text(name),
      subtitle: Text("$file"),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: () {
        Navigator.pop(context);

        /// هون لاحقاً مع Bloc
        /// switch patient
      },
    );
  }
}