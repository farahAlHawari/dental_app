// import 'package:dental_app/features/financial_and_billing/presentation/widgets/invoice_card.dart';
// import 'package:dental_app/features/financial_and_billing/presentation/widgets/payment_timeline.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// class InvoiceDetails extends StatefulWidget {
//    final Map<String, dynamic> invoice;

//   const InvoiceDetails({
//     super.key,
//     required this.invoice,
//   });

//   @override
//   State<InvoiceDetails> createState() => _InvoiceDetailsState();
// }

// class _InvoiceDetailsState extends State<InvoiceDetails> {
//   final List<Map<String,dynamic>> payments = [
//   {
//     "title":"First Payment",
//     "amount":1500,
//     "date":"12 Jan 2026",
//     "method":"Cash",
//     "received":true,
//   },
//   {
//     "title":"Second Payment",
//     "amount":2000,
//     "date":"2 Feb 2026",
//     "method":"Card",
//     "received":true,
//   },
// ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//       title: Text(
//         "Invoice Details",
//         style: TextStyle(
//           color: Theme.of(context).colorScheme.primary,
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     ),
//       backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
//       body: SizedBox.expand(
//         child: Stack(
//           children: [
//              Positioned.fill(
//             child: Image.asset(
//               "assets/backgrounds/background5.png",
//               color: Theme.of(context).colorScheme.primary,
//               fit: BoxFit.cover,
//             ),
//           ),
//           SingleChildScrollView(
//   child: Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Column(

//       children: [
    
//         InvoiceCard(
//     invoiceNumber: widget.invoice["invoiceNumber"],
//     treatmentName: widget.invoice["treatmentName"],
//     sessionInfo: widget.invoice["sessionInfo"],
//     date: widget.invoice["date"],
//     total: widget.invoice["total"],
//     paid: widget.invoice["paid"],
//     remaining: widget.invoice["remaining"],
//     status: widget.invoice["status"],
//     ),

//     SizedBox(height: 6,),
//     Padding(
//       padding: const EdgeInsets.all(2),
//       child: Row(
//         children: [
//           Lottie.asset(
//   "assets/animations/8.json",
//   width: 60,
//   height: 60,
// ),
//           Text("Record of partial payments received",style: TextStyle(color: Theme.of(context).colorScheme.primary,
//           fontSize: 15,fontWeight: FontWeight.w500),),
//         ],
//       ),
//     ),
//      SizedBox(height: 10,),
//         ListView.builder(
//     shrinkWrap: true,
//     physics: NeverScrollableScrollPhysics(),
//     itemCount: payments.length,
//     itemBuilder: (context,index){
    
//       final payment = payments[index];
    
//       return PaymentTimelineTile(
//         payment: payment,
//         isLast: index == payments.length - 1,
//       );
    
//     },
//     )
    
        
    
//       ],
//     ),
//   ),
// )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:dental_app/features/financial_and_billing/presentation/widgets/invoice_card.dart';
import 'package:dental_app/features/financial_and_billing/presentation/widgets/payment_timeline.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class InvoiceDetails extends StatefulWidget {
  final Map<String, dynamic> invoice;

  const InvoiceDetails({super.key, required this.invoice});

  @override
  State<InvoiceDetails> createState() => _InvoiceDetailsState();
}

class _InvoiceDetailsState extends State<InvoiceDetails> {
  // TODO: لما يجهز الـ API، هاد الليستة رح تنجاب حسب invoiceNumber من الباك اند
  final List<Map<String, dynamic>> payments = [
    {
      "title": "First Payment",
      "amount": 1500,
      "date": "12 Jan 2026",
      "method": "Cash",
      "received": true,
    },
    {
      "title": "Second Payment",
      "amount": 2000,
      "date": "2 Feb 2026",
      "method": "Card",
      "received": true,
    },
  ];

  Widget _buildPaymentsHeader() {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Row(
        children: [
          // Lottie.asset("assets/animations/8.json", width: 60, height: 60),
          Padding(
            padding: const EdgeInsets.only(left: 10,right: 10),
            child: Text(
              "Record of partial payments received",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return PaymentTimelineTile(
          payment: payment,
          isLast: index == payments.length - 1,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Invoice Details",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset("assets/backgrounds/background5.png", fit: BoxFit.cover,color: Theme.of(context).colorScheme.primary,),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    InvoiceCard(
                      invoiceNumber: widget.invoice["invoiceNumber"],
                      treatmentName: widget.invoice["treatmentName"],
                      sessionInfo: widget.invoice["sessionInfo"],
                      date: widget.invoice["date"],
                      total: widget.invoice["total"],
                      paid: widget.invoice["paid"],
                      remaining: widget.invoice["remaining"],
                      status: widget.invoice["status"],
                    ),
                    const SizedBox(height: 6),
                    _buildPaymentsHeader(),
                    const SizedBox(height: 10),
                    _buildPaymentsList(),
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