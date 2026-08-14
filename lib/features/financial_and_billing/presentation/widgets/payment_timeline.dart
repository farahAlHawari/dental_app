// import 'package:dental_app/core/theme/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'payment_card.dart';

// class PaymentTimelineTile extends StatelessWidget {
//   final Map<String, dynamic> payment;
//   final bool isLast;

//   const PaymentTimelineTile({
//     super.key,
//     required this.payment,
//     required this.isLast,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return IntrinsicHeight(
//       child: Row(
//   crossAxisAlignment: CrossAxisAlignment.start,
//   children: [

//     Padding(
//       padding: const EdgeInsets.only(top: 4),
//       child: Column(
//         children: [
//           Container(
//             width: 10,
//             height: 10,
//             decoration: const BoxDecoration(
//               color: AppColors.primary,
//               shape: BoxShape.circle,
//             ),
//           ),

          
//             Expanded(
//               child: Container(
//                 width: 2,
//                 margin: const EdgeInsets.symmetric(vertical: 4),
//                 color: AppColors.primary.withAlpha(200),
//               ),
//             ),
//         ],
//       ),
//     ),

//     const SizedBox(width: 12),

//     Expanded(
//       child: PaymentCard(
//         payment: payment,
//       ),
//     ),
//   ],
// )
//     );
//   }
// }
import 'package:dental_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'payment_card.dart';

class PaymentTimelineTile extends StatelessWidget {
  final Map<String, dynamic> payment;
  final bool isLast;
  final int paymentIndex;

  const PaymentTimelineTile({
    super.key,
    required this.payment,
    required this.isLast,
    required this.paymentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              children: [
                Lottie.asset("assets/animations/saa.json", width: 30, height: 30),
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: AppColors.primary.withAlpha(200),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PaymentCard(
              payment: payment,
              paymentIndex: paymentIndex,
            ),
          ),
        ],
      ),
    );
  }
}