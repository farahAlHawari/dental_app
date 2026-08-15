import 'package:dental_app/core/utils/patient_profile_image.dart';
import 'package:dental_app/core/widgets/empty_list_state.dart';
import 'package:dental_app/core/widgets/shimmer/app_shimmer.dart';
import 'package:dental_app/features/financial_and_billing/domain/financial_helper.dart';
import 'package:dental_app/features/financial_and_billing/presentation/bloc/financial_bloc.dart';
import 'package:dental_app/features/financial_and_billing/presentation/pages/invoice_details.dart';
import 'package:dental_app/features/financial_and_billing/presentation/widgets/financial_summary_card.dart';
import 'package:dental_app/features/financial_and_billing/presentation/widgets/invoice_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Family-scope financial statement — same UI as patient billing,
/// calls financial-summary without patientId.
class FamilyFinancialPage extends StatelessWidget {
  const FamilyFinancialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FinancialBloc(),
      child: const _FamilyFinancialView(),
    );
  }
}

class _FamilyFinancialView extends StatefulWidget {
  const _FamilyFinancialView();

  @override
  State<_FamilyFinancialView> createState() => _FamilyFinancialViewState();
}

class _FamilyFinancialViewState extends State<_FamilyFinancialView> {
  String _selectedStatus = 'all';
  Map<String, dynamic>? _summary;
  List<Map<String, dynamic>> _invoices = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  String? get _apiStatus =>
      _selectedStatus == 'all' ? null : _selectedStatus;

  Future<void> _load() async {
    await ShimmerPreview.wait();
    if (!mounted) return;
    context.read<FinancialBloc>().add(
          LoadFinancialSummaryRequested(
            patientId: null,
            status: _apiStatus,
          ),
        );
  }

  void _onFilterSelected(String value) {
    setState(() => _selectedStatus = value);
    _load();
  }

  Widget _buildFilterHeader() {
    final labels = <String, String>{
      'all': 'All'.tr(),
      FinancialHelper.statusPaid: 'Paid'.tr(),
      FinancialHelper.statusPartiallyPaid: 'Partially Paid'.tr(),
      FinancialHelper.statusUnpaid: 'Unpaid'.tr(),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Invoices'.tr(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          PopupMenuButton<String>(
            onSelected: _onFilterSelected,
            itemBuilder: (context) => [
              PopupMenuItem(value: 'all', child: Text('All'.tr())),
              PopupMenuItem(
                value: FinancialHelper.statusPaid,
                child: Text('Paid'.tr()),
              ),
              PopupMenuItem(
                value: FinancialHelper.statusPartiallyPaid,
                child: Text('Partially Paid'.tr()),
              ),
              PopupMenuItem(
                value: FinancialHelper.statusUnpaid,
                child: Text('Unpaid'.tr()),
              ),
            ],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  labels[_selectedStatus] ?? 'All'.tr(),
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

  Widget _buildBody(FinancialState state) {
    if (state is FinancialSummaryFailure && _summary == null) {
      return Expanded(
        child: Center(
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
        ),
      );
    }

    return Expanded(
      child: _invoices.isEmpty
          ? EmptyListState(message: 'No invoices'.tr())
          : RefreshIndicator(
              onRefresh: () async => _load(),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: _invoices.length,
                itemBuilder: (context, index) {
                  final invoice = _invoices[index];
                  final id = (invoice['id'] ?? '').toString();
                  final patient =
                      invoice['_patient'] as Map<String, dynamic>?;
                  return InvoiceCard(
                    invoiceNumber:
                        (invoice['invoiceNumber'] ?? '').toString(),
                    treatmentName: FinancialHelper.treatmentPlanName(invoice),
                    date: FinancialHelper.formatIssuedDate(
                      invoice['issuedAt']?.toString(),
                    ),
                    total: FinancialHelper.parseAmount(
                      invoice['totalAmount'],
                    ),
                    paid: FinancialHelper.parseAmount(invoice['paidAmount']),
                    remaining: FinancialHelper.parseAmount(
                      invoice['remainingAmount'],
                    ),
                    status: (invoice['status'] ?? '').toString(),
                    patientName:
                        (invoice['_patientName'] ?? '').toString(),
                    patientImageUrl: PatientProfileImage.urlOf(patient),
                    onTap: id.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InvoiceDetails(
                                  invoiceId: id,
                                  showPatient: true,
                                ),
                              ),
                            );
                          },
                  );
                },
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Family Financial Statement'.tr(),
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
              child: Image.asset(
                'assets/backgrounds/background5.png',
                color: Theme.of(context).colorScheme.primary,
                fit: BoxFit.cover,
              ),
            ),
            BlocConsumer<FinancialBloc, FinancialState>(
              listener: (context, state) {
                if (state is FinancialSummarySuccess) {
                  setState(() {
                    _summary = state.data;
                    _invoices = FinancialHelper.flattenInvoices(state.data);
                  });
                } else if (state is FinancialSummaryFailure &&
                    _summary != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errMessage)),
                  );
                }
              },
              builder: (context, state) {
                if (state is FinancialSummaryLoading ||
                    (state is FinancialInitial && _summary == null)) {
                  return const FinancialPageShimmer(showPatientOnCards: true);
                }

                if (state is FinancialSummaryFailure && _summary == null) {
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

                return Column(
                  children: [
                    FinancialSummaryCard(
                      totalBilled: FinancialHelper.parseAmount(
                        _summary?['totalBilled'],
                      ),
                      totalPaid: FinancialHelper.parseAmount(
                        _summary?['totalPaid'],
                      ),
                      totalRemaining: FinancialHelper.parseAmount(
                        _summary?['totalRemaining'],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildFilterHeader(),
                    const SizedBox(height: 12),
                    _buildBody(state),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
