import 'package:dental_app/features/treatment_plans/data/models/invoice_status.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PlanInvoiceStatusBadge extends StatelessWidget {
  final InvoiceStatus status;

  const PlanInvoiceStatusBadge({super.key, required this.status});

  Color get _color {
    switch (status) {
      case InvoiceStatus.paid:
        return const Color(0xFF2ECC71);
      case InvoiceStatus.partiallyPaid:
        return const Color(0xFFF5A623);
      case InvoiceStatus.unpaid:
        return const Color(0xFFE74C3C);
      case InvoiceStatus.voided:
        return const Color(0xFF9AA3AF);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            status.labelKey.tr(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
