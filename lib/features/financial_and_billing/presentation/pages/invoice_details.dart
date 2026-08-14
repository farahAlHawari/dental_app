import 'package:dental_app/core/utils/patient_profile_image.dart';
import 'package:dental_app/core/widgets/empty_list_state.dart';
import 'package:dental_app/core/widgets/shimmer/app_shimmer.dart';
import 'package:dental_app/features/financial_and_billing/domain/financial_helper.dart';
import 'package:dental_app/features/financial_and_billing/presentation/bloc/financial_bloc.dart';
import 'package:dental_app/features/financial_and_billing/presentation/widgets/invoice_card.dart';
import 'package:dental_app/features/financial_and_billing/presentation/widgets/payment_timeline.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoiceDetails extends StatelessWidget {
  final String invoiceId;
  /// Show patient name/avatar (family statement only).
  final bool showPatient;

  const InvoiceDetails({
    super.key,
    required this.invoiceId,
    this.showPatient = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FinancialBloc(),
      child: _InvoiceDetailsView(
        invoiceId: invoiceId,
        showPatient: showPatient,
      ),
    );
  }
}

class _InvoiceDetailsView extends StatefulWidget {
  final String invoiceId;
  final bool showPatient;

  const _InvoiceDetailsView({
    required this.invoiceId,
    required this.showPatient,
  });

  @override
  State<_InvoiceDetailsView> createState() => _InvoiceDetailsViewState();
}

class _InvoiceDetailsViewState extends State<_InvoiceDetailsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    await ShimmerPreview.wait();
    if (!mounted) return;
    context.read<FinancialBloc>().add(
          LoadInvoiceDetailsRequested(invoiceId: widget.invoiceId),
        );
  }

  List<Map<String, dynamic>> _paymentsOf(Map<String, dynamic> data) {
    final raw = data['payments'];
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Invoice Details'.tr(),
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
              child: Image.asset(
                'assets/backgrounds/background5.png',
                fit: BoxFit.cover,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            BlocBuilder<FinancialBloc, FinancialState>(
              builder: (context, state) {
                if (state is InvoiceDetailsLoading ||
                    state is FinancialInitial) {
                  return InvoiceDetailsShimmer(
                    showPatient: widget.showPatient,
                  );
                }

                if (state is InvoiceDetailsFailure) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(state.errMessage, textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _load,
                            child: Text('Retry'.tr()),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is! InvoiceDetailsSuccess) {
                  return const SizedBox.shrink();
                }

                final invoice = state.data;
                final payments = _paymentsOf(invoice);
                final patientRaw = invoice['patient'];
                final patient = patientRaw is Map
                    ? Map<String, dynamic>.from(patientRaw)
                    : null;
                final patientName = (patient?['fullName'] ?? '').toString();

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        InvoiceCard(
                          invoiceNumber:
                              (invoice['invoiceNumber'] ?? '').toString(),
                          treatmentName:
                              FinancialHelper.treatmentPlanName(invoice),
                          sessionInfo:
                              '${payments.length} ${'Payments'.tr()}',
                          date: FinancialHelper.formatIssuedDate(
                            invoice['issuedAt']?.toString(),
                          ),
                          total: FinancialHelper.parseAmount(
                            invoice['totalAmount'],
                          ),
                          paid: FinancialHelper.parseAmount(
                            invoice['paidAmount'],
                          ),
                          remaining: FinancialHelper.parseAmount(
                            invoice['remainingAmount'],
                          ),
                          status: (invoice['status'] ?? '').toString(),
                          patientName: widget.showPatient &&
                                  patientName.isNotEmpty
                              ? patientName
                              : null,
                          patientImageUrl: widget.showPatient
                              ? PatientProfileImage.urlOf(patient)
                              : null,
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'Record of partial payments received'.tr(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (payments.isEmpty)
                          EmptyListState(
                            message: 'No payments'.tr(),
                            animationSize: 140,
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: payments.length,
                            itemBuilder: (context, index) {
                              return PaymentTimelineTile(
                                payment: payments[index],
                                paymentIndex: index + 1,
                                isLast: index == payments.length - 1,
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
