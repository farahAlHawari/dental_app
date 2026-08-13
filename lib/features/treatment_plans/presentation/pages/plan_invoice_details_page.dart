import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/widgets/empty_list_state.dart';
import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:dental_app/core/widgets/shimmer/app_shimmer.dart';
import 'package:dental_app/features/medical_archive/domain/medical_archive_helper.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_invoice.dart';
import 'package:dental_app/features/treatment_plans/presentation/bloc/treatment_plans_bloc.dart';
import 'package:dental_app/features/treatment_plans/presentation/widgets/plan_invoice_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class PlanInvoiceDetailsPage extends StatefulWidget {
  final String invoiceId;
  final PlanInvoice? preview;

  const PlanInvoiceDetailsPage({
    super.key,
    required this.invoiceId,
    this.preview,
  });

  @override
  State<PlanInvoiceDetailsPage> createState() => _PlanInvoiceDetailsPageState();
}

class _PlanInvoiceDetailsPageState extends State<PlanInvoiceDetailsPage> {
  PlanInvoiceDetail? _invoice;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    await ShimmerPreview.wait();
    if (!mounted) return;
    context.read<TreatmentPlansBloc>().add(
          LoadPlanInvoiceDetailRequested(invoiceId: widget.invoiceId),
        );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final preview = widget.preview;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Invoice details'.tr(),
          style: TextStyle(
            color: colors.primary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: colors.surfaceContainerHighest,
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/backgrounds/background5.png',
                fit: BoxFit.cover,
                color: colors.primary,
              ),
            ),
            SafeArea(
              child: BlocConsumer<TreatmentPlansBloc, TreatmentPlansState>(
                listener: (context, state) {
                  if (state is PlanInvoiceDetailSuccess &&
                      state.invoice.id == widget.invoiceId) {
                    setState(() {
                      _invoice = state.invoice;
                      _ready = true;
                    });
                  } else if (state is PlanInvoiceDetailFailure &&
                      state.invoiceId == widget.invoiceId) {
                    setState(() => _ready = true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errMessage)),
                    );
                  }
                },
                buildWhen: (previous, current) =>
                    (current is PlanInvoiceDetailLoading &&
                        current.invoiceId == widget.invoiceId) ||
                    (current is PlanInvoiceDetailSuccess &&
                        current.invoice.id == widget.invoiceId) ||
                    (current is PlanInvoiceDetailFailure &&
                        current.invoiceId == widget.invoiceId),
                builder: (context, state) {
                  final invoice = _invoice;
                  if (!_ready && invoice == null && preview == null) {
                    return const PlanInvoiceDetailsShimmer();
                  }

                  return RefreshIndicator(
                    onRefresh: _load,
                    color: colors.primary,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      children: [
                        FadeSlideIn(
                          child: PlanInvoiceCard(
                            invoice: invoice ?? preview!,
                          ),
                        ),
                        if (invoice != null) ...[
                          if (invoice.items.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 10),
                              child: Text(
                                'Invoice items'.tr(),
                                style: TextStyle(
                                  color: colors.primary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            ...invoice.items.map(
                              (item) => _InvoiceItemTile(item: item),
                            ),
                          ],
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                            child: Text(
                              'Record of partial payments received'.tr(),
                              style: TextStyle(
                                color: colors.primary,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (invoice.payments.isEmpty)
                            EmptyListState(
                              message: 'No payments yet'.tr(),
                              animationSize: 110,
                            )
                          else
                            ...List.generate(invoice.payments.length, (index) {
                              return _PaymentTimelineTile(
                                payment: invoice.payments[index],
                                index: index,
                                isLast: index == invoice.payments.length - 1,
                              );
                            }),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InvoiceItemTile extends StatelessWidget {
  final PlanInvoiceItem item;

  const _InvoiceItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final title = item.description?.isNotEmpty == true
        ? item.description!
        : 'Invoice item'.tr();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${'Quantity'.tr()}: ${item.quantity}',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
              Text(
                planMoney(item.totalAmount),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentTimelineTile extends StatelessWidget {
  final PlanInvoicePayment payment;
  final int index;
  final bool isLast;

  const _PaymentTimelineTile({
    required this.payment,
    required this.index,
    required this.isLast,
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
                Lottie.asset(
                  'assets/animations/saa.json',
                  width: 30,
                  height: 30,
                ),
                if (!isLast)
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
            child: _PaymentCard(payment: payment, index: index),
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final PlanInvoicePayment payment;
  final int index;

  const _PaymentCard({required this.payment, required this.index});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final date = MedicalArchiveHelper.formatDate(
      payment.paidAt?.toIso8601String(),
    );

    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Payment {order}'.tr(
                      namedArgs: {'order': '${index + 1}'},
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color: colors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    planMoney(payment.amount),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  date,
                  style: const TextStyle(color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Text(
                  payment.methodLabelKey.tr(),
                  style: TextStyle(
                    color: colors.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (payment.notes != null) ...[
              Divider(height: 25, color: colors.shadow),
              Text(
                payment.notes!,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
