// // import 'package:dental_app/core/theme/app_colors.dart';
// // import 'package:flutter/material.dart';

// // class FinancialPage extends StatefulWidget {
// //   const FinancialPage({super.key});

// //   @override
// //   State<FinancialPage> createState() => _FinancialPageState();
// // }

// // class _FinancialPageState extends State<FinancialPage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColors.tertiary,
// //       body: SizedBox.expand(
// //         child: Stack(
// //           children: [
// //              Positioned.fill(
// //               child: Image.asset('assets/backgrounds/background1.jpg', 
// //                fit: BoxFit.cover,),
// //             ),
// //             Column(
// //               children: [
// //                 Container(
// //                   height: 70,
// //                   width: double.infinity,
// //                   decoration: BoxDecoration(
// //                     borderRadius: BorderRadius.circular(20),
// //                     color: AppColors.primary
// //                   ),child: Row(
// //                     children: [
// //                       Text("paid"),
// //                       Text("200 S.P"),
// //                       Text("Un paid"),
// //                       Text("200 S.P"),
// //                     ],
// //                   ),
// //                 )
// //               ],
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:dental_app/core/theme/app_colors.dart';
// import 'package:dental_app/features/financial_and_billing/presentation/pages/invoice_details.dart';
// import 'package:dental_app/features/financial_and_billing/presentation/widgets/invoice_card.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// class FinancialPage extends StatefulWidget {
//   const FinancialPage({super.key});

//   @override
//   State<FinancialPage> createState() => _FinancialPageState();
// }
// class _FinancialPageState extends State<FinancialPage> {

//   /// الحالة المختارة للفلترة
//   String selectedStatus = "all";

//   /// بيانات تجريبية
//   final List<Map<String, dynamic>> invoices = [
//     {
//       "invoiceNumber": "12345",
//       "treatmentName": "Metal Braces Treatment",
//       "sessionInfo": "2 Payments",
//       "date": "January 12, 2026",
//       "total": 3500.0,
//       "paid": 3500.0,
//       "remaining": 0.0,
//       "status": "fullyPaid",
//     },
//     {
//       "invoiceNumber": "12346",
//       "treatmentName": "Wire Adjustment & Cleaning",
//       "sessionInfo": "1 Payment",
//       "date": "February 02, 2026",
//       "total": 5000.0,
//       "paid": 3500.0,
//       "remaining": 1500.0,
//       "status": "partiallyPaid",
//     },
//     {
//       "invoiceNumber": "12347",
//       "treatmentName": "Root Canal Treatment",
//       "sessionInfo": "4 Payments",
//       "date": "March 10, 2026",
//       "total": 4200.0,
//       "paid": 0.0,
//       "remaining": 4200.0,
//       "status": "unpaid",
//     },
//   ];

//   /// الفواتير بعد الفلترة
//   List<Map<String, dynamic>> get filteredInvoices {
//     if (selectedStatus == "all") {
//       return invoices;
//     }

//     return invoices.where((invoice) {
//       return invoice["status"] == selectedStatus;
//     }).toList();
//   }

//   /// مجموع قيمة جميع الفواتير
//   double get totalAmount {
//     return invoices.fold(
//       0.0,
//       (sum, invoice) => sum + invoice["total"],
//     );
//   }

//   /// مجموع المدفوع
//   double get totalPaid {
//     return invoices.fold(
//       0.0,
//       (sum, invoice) => sum + invoice["paid"],
//     );
//   }

//   /// مجموع المتبقي
//   double get totalRemaining {
//     return invoices.fold(
//       0.0,
//       (sum, invoice) => sum + invoice["remaining"],
//     );
//   }

//   /// عنصر صغير داخل الكارد العلوي
// Widget buildSummaryItem({
//   required String title,
//   required double amount,
// }) {
//   return Expanded(
//     child: Container(
//       margin: const EdgeInsets.symmetric(horizontal: 4),
//       padding: const EdgeInsets.symmetric(vertical: 14),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.primary.withAlpha(150),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             amount.toStringAsFixed(0),
//             style:  TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Theme.of(context).colorScheme.onSurface
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             title,
//             style: TextStyle(
//               color:  Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
//               fontSize: 13,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
//   @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text(
//         "Financial & Billing",
//         style: TextStyle(
//           color: Theme.of(context).colorScheme.primary,
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     ),
//     backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
//     body: SafeArea(
//       child: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.asset(
//               "assets/backgrounds/1.png",
//               fit: BoxFit.cover,
//             ),
//           ),

//           Column(
//             children: [

//               /// Summary Card
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
//                 child: Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: const Color.fromARGB(255, 138, 194, 214),
//                     borderRadius: BorderRadius.circular(24),
//                   ),
//                   child: Row(
//                     children: [

//                       /// المعلومات
//                    Expanded(
//   child: Row(
//     children: [

//       buildSummaryItem(
//         title: "Total",
//         amount: totalAmount,
//       ),

//       buildSummaryItem(
//         title: "Paid",
//         amount: totalPaid,
//       ),

//       buildSummaryItem(
//         title: "Remaining",
//         amount: totalRemaining,
//       ),
//     ],
//   ),
// ),

// const SizedBox(width: 15),

// // Lottie.asset(
// //   "assets/animations/m.json",
// //   width: 90,
// //   height: 90,
// // ),

                     

                    
//                     ],
//                   ),
//                 ),
//               ),

//               /// Filter Chips
//               SizedBox(
//                 height: 45,
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   children: [

//                    Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 16),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [

//       const Text(
//         "Invoices",
//         style: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
// SizedBox(width: 120,),
//       PopupMenuButton<String>(
//         onSelected: (value) {
//           setState(() {
//             selectedStatus = value;
//           });
//         },

//         itemBuilder: (context) => [

//           const PopupMenuItem(
//             value: "all",
//             child: Text("All"),
//           ),

//           const PopupMenuItem(
//             value: "fullyPaid",
//             child: Text("Paid"),
//           ),

//           const PopupMenuItem(
//             value: "partiallyPaid",
//             child: Text("Partially Paid"),
//           ),

//           const PopupMenuItem(
//             value: "unpaid",
//             child: Text("Unpaid"),
//           ),
//         ],

//         child: Row(
//           children: [

           

//             const SizedBox(width: 6),

//             Text(
//               selectedStatus == "all"
//                   ? "All"
//                   : selectedStatus == "fullyPaid"
//                       ? "Paid"
//                       : selectedStatus == "partiallyPaid"
//                           ? "Partially Paid"
//                           : "Unpaid",
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//               ),
//             ),

//             const Icon(Icons.keyboard_arrow_down),
//           ],
//         ),
//       ),
//     ],
//   ),
// ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 12),

//               Expanded(
//   child: ListView.builder(
//     padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
//     itemCount: filteredInvoices.length,
//     itemBuilder: (context, index) {

//       final invoice = filteredInvoices[index];

//       return InvoiceCard(
//         invoiceNumber: invoice["invoiceNumber"],
//         treatmentName: invoice["treatmentName"],
//         sessionInfo: invoice["sessionInfo"],
//         date: invoice["date"],
//         total: invoice["total"],
//         paid: invoice["paid"],
//         remaining: invoice["remaining"],
//         status: invoice["status"],
//         onTap: () {

//           Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => InvoiceDetails(invoice: invoice),
//       ),
//     );
//         },
//       );
//     },
//   ),
// ),            ],
//           ),
//         ],
//       ),
//     ),
//   );
// }
// // class _FinancialPageState extends State<FinancialPage> {

// //   final List<Map<String, dynamic>> invoices = [
// //     {
// //       'invoiceNumber': '12345',
// //       'treatmentName': 'Metal Braces Treatment',
// //       'sessionInfo': '2 payment',
// //       'date': 'January 12, 2026',
// //       'total': 3500.0,
// //       'paid': 3500.0,
// //       'remaining': 0.0,
// //       'status': 'fullyPaid',
// //     },
// //     {
// //       'invoiceNumber': '12346',
// //       'treatmentName': 'Wire Adjustment & Cleaning',
// //       'sessionInfo': '1 payment',
// //       'date': 'February 02, 2026',
// //       'total': 5000.0,
// //       'paid': 3500.0,
// //       'remaining': 1500.0,
// //       'status': 'partiallyPaid',
// //     },
// //     {
// //       'invoiceNumber': '12347',
// //       'treatmentName': 'Root Canal Treatment',
// //       'sessionInfo': '4 payment',
// //       'date': 'March 10, 2026',
// //       'total': 4200.0,
// //       'paid': 0.0,
// //       'remaining': 4200.0,
// //       'status': 'unpaid',
// //     },
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     final totalPaidCount = invoices.where((i) => i['status'] == 'fullyPaid').length;
// //     final totalUnpaidCount = invoices.where((i) => i['status'] != 'fullyPaid').length;

// //     return Scaffold(
// //       appBar: AppBar(

// //         title:  Text("Medical Archive",style: TextStyle(
// //           color: Theme.of(context).colorScheme.primary,
// //           fontSize: 20,
// //           fontWeight: FontWeight.w600
// //         ),),
// //       ),
// //       backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
// //       body: SafeArea(
// //         child: SizedBox.expand(
// //           child: Stack(
// //             children: [
// //               Positioned.fill(
// //                 child: Image.asset(
// //                   'assets/backgrounds/1.png',
// //                   fit: BoxFit.cover,
// //                 ),
// //               ),
// //               Column(
                
// //                 crossAxisAlignment: CrossAxisAlignment.stretch,
// //                 children: [
// //                    Padding(
// //                      padding: const EdgeInsets.fromLTRB(16, 15, 16, 0),
// //                      child: Container(
// //                         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
// //                         width: double.infinity,
// //                         height: 200
// //                         ,
// //                         decoration: BoxDecoration(
// //                           color: const Color.fromARGB(255, 138, 194, 214),
// //                           borderRadius: BorderRadius.circular(24),
// //                           boxShadow: [
// //                             BoxShadow(
// //                               color: AppColors.primary.withOpacity(0.35),
// //                               blurRadius: 16,
// //                               offset: const Offset(0, 8),
// //                             ),
// //                           ],
// //                         ),
// //                         child: Row(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           crossAxisAlignment: CrossAxisAlignment.center,
// //                           children: [
                            
// //                           Expanded(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         children: [
// //         LottieBuilder.asset(("assets/animations/m.json"),),
// //           Text(
// //             '200 S.P',
// //             style: TextStyle(
// //               fontSize: 15,
// //               fontWeight: FontWeight.bold,
// //               color: AppColors.surface
// //             ),
// //           ),
// //            const SizedBox(height: 4),
// //             Text(
// //             "Total",
// //             style: TextStyle(fontSize: 15, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
// //           ),
         
// //         ],
// //       ),) ,


// //              Expanded(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         children: [
        
// //           Text(
// //             '200 S.P',
// //             style: TextStyle(
// //               fontSize: 15,
// //               fontWeight: FontWeight.bold,
// //               color: AppColors.surface
// //             ),
// //           ),
// //            const SizedBox(height: 4),
// //             Text(
// //             "Un Paid",
// //             style: TextStyle(fontSize: 15, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
// //           ),
         
// //         ],
// //       ),) ,

// //        Expanded(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         children: [
        
// //           Text(
// //             '200 S.P',
// //             style: TextStyle(
// //               fontSize: 15,
// //               fontWeight: FontWeight.bold,
// //               color: AppColors.surface
// //             ),
// //           ),
// //            const SizedBox(height: 4),
// //             Text(
// //             "Due",
// //             style: TextStyle(fontSize: 15, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
// //           ),
         
// //         ],
// //       ),) ,               
// //                           ],
// //                         ),
// //                         ),
// //                    ),



// //                 SizedBox(height: 20,),
// //                  Expanded(
// //                     child: ListView.builder(
// //                       padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
// //                       itemCount: invoices.length,
// //                       itemBuilder: (context, index) {
// //                         final invoice = invoices[index];
// //                         return InvoiceCard(
// //                           invoiceNumber: invoice['invoiceNumber'],
// //                           treatmentName: invoice['treatmentName'],
// //                           sessionInfo: invoice['sessionInfo'],
// //                           date: invoice['date'],
// //                           total: invoice['total'],
// //                           paid: invoice['paid'],
// //                           remaining: invoice['remaining'],
// //                           status: invoice['status'],
// //                           onPayPressed: () {
                            
// //                           },
// //                         );
// //                       },
// //                     ),
// //                   ),


            
                  
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }


//  }

import 'package:dental_app/features/financial_and_billing/presentation/pages/invoice_details.dart';
import 'package:dental_app/features/financial_and_billing/presentation/widgets/invoice_card.dart';
import 'package:flutter/material.dart';

class FinancialPage extends StatefulWidget {
  const FinancialPage({super.key});

  @override
  State<FinancialPage> createState() => _FinancialPageState();
}

class _FinancialPageState extends State<FinancialPage> {
  String selectedStatus = "all";

  // TODO: لما يجهز الـ API، هاد الليستة رح تجي من Repository/Cubit بدل ما تكون Hardcoded
  final List<Map<String, dynamic>> invoices = [
    {
      "invoiceNumber": "12345",
      "treatmentName": "Metal Braces Treatment",
      "sessionInfo": "2 Payments",
      "date": "January 12, 2026",
      "total": 3500.0,
      "paid": 3500.0,
      "remaining": 0.0,
      "status": "fullyPaid",
    },
    {
      "invoiceNumber": "12346",
      "treatmentName": "Wire Adjustment & Cleaning",
      "sessionInfo": "1 Payment",
      "date": "February 02, 2026",
      "total": 5000.0,
      "paid": 3500.0,
      "remaining": 1500.0,
      "status": "partiallyPaid",
    },
    {
      "invoiceNumber": "12347",
      "treatmentName": "Root Canal Treatment",
      "sessionInfo": "4 Payments",
      "date": "March 10, 2026",
      "total": 4200.0,
      "paid": 0.0,
      "remaining": 4200.0,
      "status": "unpaid",
    },
  ];

  static const Map<String, String> _statusLabels = {
    "all": "All",
    "fullyPaid": "Paid",
    "partiallyPaid": "Partially Paid",
    "unpaid": "Unpaid",
  };

  List<Map<String, dynamic>> get filteredInvoices {
    if (selectedStatus == "all") return invoices;
    return invoices.where((invoice) => invoice["status"] == selectedStatus).toList();
  }

  double get totalAmount =>
      invoices.fold(0.0, (sum, invoice) => sum + invoice["total"]);
  double get totalPaid =>
      invoices.fold(0.0, (sum, invoice) => sum + invoice["paid"]);
  double get totalRemaining =>
      invoices.fold(0.0, (sum, invoice) => sum + invoice["remaining"]);
Widget _buildSummaryItem({
  required IconData icon,
  required String title,
  required double amount,
}) {
  return Expanded(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 18,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        const SizedBox(height: 6),
        Text(
          amount.toStringAsFixed(0),
          style:  TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 11,
          ),
        ),
      ],
    ),
  );
}

Widget _buildVerticalDivider() {
  return Container(
    height: 40,
    width: 1,
    color: Colors.white.withOpacity(0.25),
  );
}

Widget _buildSummaryCard() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(200),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                _buildSummaryItem(
                  icon: Icons.account_balance_wallet_outlined,
                  title: "Total",
                  amount: totalAmount,
                ),
                _buildVerticalDivider(),
                _buildSummaryItem(
                  icon: Icons.check_circle_outline,
                  title: "Paid",
                  amount: totalPaid,
                ),
                _buildVerticalDivider(),
                _buildSummaryItem(
                  icon: Icons.hourglass_empty_rounded,
                  title: "Remaining",
                  amount: totalRemaining,
                ),
              ],
            ),
          ),

          // ديكور صورة الكوينز - أسفل يمين الكارد
          Positioned(
            bottom: -10,
            right: -8,
            child: Opacity(
              opacity: 0.7,
              child: Image.asset(
                "assets/images/123.png", // TODO: غيّري الاسم إذا مختلف
                width: 90,
                height: 90,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
  // Widget _buildSummaryItem({required String title, required double amount}) {
  //   return Expanded(
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(horizontal: 4),
  //       padding: const EdgeInsets.symmetric(vertical: 14),
  //       decoration: BoxDecoration(
  //         color: Theme.of(context).colorScheme.primary.withAlpha(150),
  //         borderRadius: BorderRadius.circular(14),
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Text(
  //             amount.toStringAsFixed(0),
  //             style: TextStyle(
  //               fontSize: 18,
  //               fontWeight: FontWeight.bold,
  //               color: Theme.of(context).colorScheme.onSurface,
  //             ),
  //           ),
  //           const SizedBox(height: 6),
  //           Text(
  //             title,
  //             style: TextStyle(
  //               color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
  //               fontSize: 13,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildSummaryCard() {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
  //     child: Container(
  //       padding: const EdgeInsets.all(20),
  //       decoration: BoxDecoration(
  //         color: const Color.fromARGB(255, 138, 194, 214),
  //         borderRadius: BorderRadius.circular(24),
  //       ),
  //       child: Row(
  //         children: [
  //           _buildSummaryItem(title: "Total", amount: totalAmount),
  //           _buildSummaryItem(title: "Paid", amount: totalPaid),
  //           _buildSummaryItem(title: "Remaining", amount: totalRemaining),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildFilterHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Invoices",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => setState(() => selectedStatus = value),
            itemBuilder: (context) => const [
              PopupMenuItem(value: "all", child: Text("All")),
              PopupMenuItem(value: "fullyPaid", child: Text("Paid")),
              PopupMenuItem(value: "partiallyPaid", child: Text("Partially Paid")),
              PopupMenuItem(value: "unpaid", child: Text("Unpaid")),
            ],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _statusLabels[selectedStatus] ?? "All",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoicesList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: filteredInvoices.length,
        itemBuilder: (context, index) {
          final invoice = filteredInvoices[index];
          return InvoiceCard(
            invoiceNumber: invoice["invoiceNumber"],
            treatmentName: invoice["treatmentName"],
            sessionInfo: invoice["sessionInfo"],
            date: invoice["date"],
            total: invoice["total"],
            paid: invoice["paid"],
            remaining: invoice["remaining"],
            status: invoice["status"],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => InvoiceDetails(invoice: invoice)),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Financial & Billing",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset("assets/backgrounds/1.png",color: Theme.of(context).colorScheme.primary, fit: BoxFit.cover),
            ),
            Column(
              children: [
                _buildSummaryCard(),
                const SizedBox(height: 8),
                _buildFilterHeader(),
                const SizedBox(height: 12),
                _buildInvoicesList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}