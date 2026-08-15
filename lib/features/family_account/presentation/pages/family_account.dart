import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/utils/patient_profile_image.dart';
import 'package:dental_app/core/utils/patient_status_guard.dart';
import 'package:dental_app/core/widgets/shimmer/app_shimmer.dart';
import 'package:dental_app/features/family_account/presentation/widgets/Add_member_card.dart';
import 'package:dental_app/features/family_account/presentation/widgets/family_financial_card.dart';
import 'package:dental_app/features/family_account/presentation/widgets/profile_card.dart';
import 'package:dental_app/features/profile/data/datasources/patient_remote_data_source.dart';
import 'package:dental_app/features/profile/domain/repositories/patient_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dental_app/features/register/presentation/pages/medical_info.dart'
    as register_medical;

class FamilyAccount extends StatefulWidget {
  const FamilyAccount({super.key});

  @override
  State<FamilyAccount> createState() => _FamilyAccountState();
}

class _FamilyAccountState extends State<FamilyAccount> {
  final _repository = PatientRepositoryImpl(
    remoteDataSource: PatientRemoteDataSource(api: DioConsumer(dio: Dio())),
  );

  List<Map<String, dynamic>> familyMembers = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    // TEMP preview delay — remove later if not needed.
    await ShimmerPreview.wait();
    if (!mounted) return;

    final result = await _repository.getMyPatients();
    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _loading = false;
          _error = failure.errMessage;
        });
      },
      (patients) {
        setState(() {
          familyMembers = patients;
          _loading = false;
        });
      },
    );
  }

  Future<void> _addMember() async {
    if (!await PatientStatusGuard.ensureSelectedPatientEditable(context)) {
      return;
    }
    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const register_medical.MedicalInfo(),
      ),
    );
    await _loadMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Family Account Management'.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
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
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Family Members".tr(),
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: _error != null && !_loading
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(_error!),
                                  TextButton(
                                    onPressed: _loadMembers,
                                    child: Text('Retry'.tr()),
                                  ),
                                ],
                              ),
                            )
                          : ListView(
                              children: [
                                if (_loading) ...[
                                  for (var i = 0;
                                      i <
                                          (familyMembers.isEmpty
                                              ? 1
                                              : familyMembers.length);
                                      i++)
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 16),
                                      child: FamilyMemberCardShimmer(),
                                    ),
                                ] else ...[
                                  for (final member in familyMembers)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
                                      child: ProfileCard(
                                        name: (member['fullName'] ??
                                                member['name'] ??
                                                'Unnamed'.tr())
                                            .toString(),
                                        gender: (member['gender'] ?? '-')
                                            .toString(),
                                        imageUrl:
                                            PatientProfileImage.urlOf(member),
                                      ),
                                    ),
                                ],
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: AddMemberCard(onTap: _addMember),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 40),
                                  child: FamilyFinancialCard(),
                                ),
                              ],
                            ),
                    ),
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
