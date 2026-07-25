// import 'package:flutter/material.dart';

// class InvoiceCard extends StatelessWidget {
//   final String invoiceNumber;
//   final String treatmentName;
//   final String sessionInfo;
//   final String date;
//   final double total;
//   final double paid;
//   final double remaining;
//   final String status; 
//   final VoidCallback? onPayPressed;
// final VoidCallback? onTap;
//   const InvoiceCard({
//     super.key,
//     required this.invoiceNumber,
//     required this.treatmentName,
//     required this.sessionInfo,
//     required this.date,
//     required this.total,
//     required this.paid,
//     required this.remaining,
//     required this.status,
//     this.onPayPressed,
//      this.onTap,
//   });

//   Color get _statusColor {
//     switch (status) {
//       case 'fullyPaid':
//         return const Color(0xFF2ECC71);
//       case 'partiallyPaid':
//         return const Color(0xFFF5A623);
//       default:
//         return const Color(0xFFE74C3C);
//     }
//   }

//   String get _statusLabel {
//     switch (status) {
//       case 'fullyPaid':
//         return 'Fully Paid';
//       case 'partiallyPaid':
//         return 'Partially Paid';
//       default:
//         return 'Unpaid';
//     }
//   }

//   Widget _amountBox(String label, String value, {Color? bg, Color? valueColor}) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         margin: const EdgeInsets.symmetric(horizontal: 4),
//         decoration: BoxDecoration(
//           color: bg ?? Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           children: [
//             Text(
//               label,
//               style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               '$value S.P',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.bold,
//                 color: valueColor ?? const Color(0xFF1B2B4B),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool showPayButton = status != 'fullyPaid';

//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(18),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Invoice #$invoiceNumber',
//                   style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: _statusColor.withOpacity(0.12),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         width: 6,
//                         height: 6,
//                         decoration: BoxDecoration(color: _statusColor, shape: BoxShape.circle),
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         _statusLabel,
//                         style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _statusColor),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               treatmentName,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B2B4B)),
//             ),
//             const SizedBox(height: 2),
//             Text(sessionInfo, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 Icon(Icons.calendar_today_outlined, size: 13, color: Colors.grey.shade400),
//                 const SizedBox(width: 6),
//                 Text(date, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
//               ],
//             ),
//             const Divider(height: 24),
//             Row(
//               children: [
//                 _amountBox('TOTAL', total.toStringAsFixed(0)),
//                 _amountBox(
//                   'PAID',
//                   paid.toStringAsFixed(0),
//                   bg: const Color(0xFF2ECC71).withOpacity(0.12),
//                   valueColor: const Color(0xFF2ECC71),
//                 ),
//                 if (remaining > 0)
//                   _amountBox(
//                     'REMAINING',
//                     remaining.toStringAsFixed(0),
//                     bg: const Color(0xFFE74C3C).withOpacity(0.10),
//                     valueColor: const Color(0xFFE74C3C),
//                   )
//                 else
//                   _amountBox('DUE', '0'),
//               ],
//             ),
            
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class InvoiceCard extends StatelessWidget {
  final String invoiceNumber;
  final String treatmentName;
  final String sessionInfo;
  final String date;
  final double total;
  final double paid;
  final double remaining;
  final String status;
  final VoidCallback? onPayPressed;
  final VoidCallback? onTap;

  const InvoiceCard({
    super.key,
    required this.invoiceNumber,
    required this.treatmentName,
    required this.sessionInfo,
    required this.date,
    required this.total,
    required this.paid,
    required this.remaining,
    required this.status,
    this.onPayPressed,
    this.onTap,
  });

  Color get _statusColor {
    switch (status) {
      case 'fullyPaid':
        return const Color(0xFF2ECC71);
      case 'partiallyPaid':
        return const Color(0xFFF5A623);
      default:
        return const Color(0xFFE74C3C);
    }
  }

  String get _statusLabel {
    switch (status) {
      case 'fullyPaid':
        return 'Fully Paid';
      case 'partiallyPaid':
        return 'Partially Paid';
      default:
        return 'Unpaid';
    }
  }

  Widget _amountBox(String label, String value, {Color? bg, Color? valueColor}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: bg ?? Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              '$value S.P',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: valueColor ?? const Color(0xFF1B2B4B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool showPayButton = status != 'fullyPaid' && onPayPressed != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color:  Theme.of(context).colorScheme.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Invoice #$invoiceNumber',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(color: _statusColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _statusLabel,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _statusColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              treatmentName,
              style:  TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(height: 2),
            Text(sessionInfo, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 13, color: Colors.grey.shade400),
                const SizedBox(width: 6),
                Text(date, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                _amountBox('TOTAL', total.toStringAsFixed(0)),
                _amountBox(
                  'PAID',
                  paid.toStringAsFixed(0),
                  bg: const Color(0xFF2ECC71).withOpacity(0.12),
                  valueColor: const Color(0xFF2ECC71),
                ),
                if (remaining > 0)
                  _amountBox(
                    'REMAINING',
                    remaining.toStringAsFixed(0),
                    bg: const Color(0xFFE74C3C).withOpacity(0.10),
                    valueColor: const Color(0xFFE74C3C),
                  )
                else
                  _amountBox('DUE', '0'),
              ],
            ),
            if (showPayButton) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onPayPressed,
                  child: const Text('Pay Now'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}