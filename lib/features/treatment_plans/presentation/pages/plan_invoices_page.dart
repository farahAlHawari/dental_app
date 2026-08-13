import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/core/widgets/empty_list_state.dart';
import 'package:dental_app/core/widgets/fade_slide_in.dart';
import 'package:dental_app/core/widgets/shimmer/app_shimmer.dart';
import 'package:dental_app/features/treatment_plans/data/models/plan_invoice.dart';
import 'package:dental_app/features/treatment_plans/presentation/bloc/treatment_plans_bloc.dart';
import 'package:dental_app/features/treatment_plans/presentation/pages/plan_invoice_details_page.dart';
import 'package:dental_app/features/treatment_plans/presentation/widgets/plan_invoice_card.dart';
import 'package:dental_app/features/treatment_plans/presentation/widgets/plan_invoice_summary_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlanInvoicesPage extends StatefulWidget {
  final String planId;

  const PlanInvoicesPage({super.key, required this.planId});

  @override
  State<PlanInvoicesPage> createState() => _PlanInvoicesPageState();
}

class _PlanInvoicesPageState extends State<PlanInvoicesPage> {
  List<PlanInvoice> _invoices = [];
  PlanInvoiceSummary _summary = PlanInvoiceSummary.empty;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final patientId = await SharedPrefs.getSelectedPatientId();
    if (!mounted) return;
    if (patientId == null || patientId.isEmpty) {
      setState(() {
        _invoices = [];
        _summary = PlanInvoiceSummary.empty;
        _ready = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No patient selected'.tr())),
      );
      return;
    }

    await ShimmerPreview.wait();
    if (!mounted) return;
    context.read<TreatmentPlansBloc>().add(
          LoadPlanInvoicesRequested(
            patientId: patientId,
            planId: widget.planId,
          ),
        );
  }

  void _openInvoice(PlanInvoice invoice) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TreatmentPlansBloc>(),
          child: PlanInvoiceDetailsPage(
            invoiceId: invoice.id,
            preview: invoice,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Invoices'.tr(),
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
                  if (state is PlanInvoicesSuccess) {
                    setState(() {
                      _invoices = List.from(state.invoices);
                      _summary = state.summary;
                      _ready = true;
                    });
                  } else if (state is PlanInvoicesFailure) {
                    setState(() {
                      _invoices = [];
                      _summary = PlanInvoiceSummary.empty;
                      _ready = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errMessage)),
                    );
                  }
                },
                buildWhen: (previous, current) =>
                    current is PlanInvoicesLoading ||
                    current is PlanInvoicesSuccess ||
                    current is PlanInvoicesFailure,
                builder: (context, state) {
                  if (!_ready) {
                    return const PlanInvoicesShimmer();
                  }

                  return RefreshIndicator(
                    onRefresh: _load,
                    color: colors.primary,
                    child: _invoices.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                            children: [
                              PlanInvoiceSummaryCard(summary: _summary),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                              ),
                              EmptyListState(
                                message: 'No invoices for this plan'.tr(),
                              ),
                            ],
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                            itemCount: _invoices.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: FadeSlideIn(
                                    child: PlanInvoiceSummaryCard(
                                      summary: _summary,
                                    ),
                                  ),
                                );
                              }
                              final invoice = _invoices[index - 1];
                              return FadeSlideIn(
                                delay: Duration(milliseconds: 50 * index),
                                child: PlanInvoiceCard(
                                  invoice: invoice,
                                  onTap: () => _openInvoice(invoice),
                                ),
                              );
                            },
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
