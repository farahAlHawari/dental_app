import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/core/widgets/app_text_field.dart';
import 'package:dental_app/core/widgets/masked_phone_chip.dart';
import 'package:dental_app/features/Verify_otp/presentation/pages/otp_flow.dart';
import 'package:dental_app/features/Verify_otp/presentation/pages/verify_otp_page.dart';
import 'package:dental_app/features/change_phone_number/data/datasources/change_phone_data_source.dart';
import 'package:dental_app/features/change_phone_number/domain/repositories/change_phone_repository_impl.dart';
import 'package:dental_app/features/change_phone_number/presentation/bloc/change_phone_bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePhonenumberPage extends StatefulWidget {
  const ChangePhonenumberPage({super.key});

  @override
  State<ChangePhonenumberPage> createState() => _ChangePhonenumberPageState();
}

class _ChangePhonenumberPageState extends State<ChangePhonenumberPage>
    with SingleTickerProviderStateMixin {
  final _phonenumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _toothController;

  String? _currentPhone;

  final ChangePhoneRepositoryImpl _changePhoneRepository =
      ChangePhoneRepositoryImpl(
    dataSource: ChangePhoneDataSource(api: DioConsumer(dio: Dio())),
  );

  @override
  void initState() {
    super.initState();
    _toothController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _loadCurrentPhone();
  }

  Future<void> _loadCurrentPhone() async {
    final phone = await SharedPrefs.getPhone();
    if (!mounted) return;
    setState(() => _currentPhone = phone);
  }

  @override
  void dispose() {
    _toothController.dispose();
    _phonenumber.dispose();
    super.dispose();
  }

  Future<void> _openOtp(String newPhone) async {
    final verified = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => VerifyOtpPage(
          phone: newPhone,
          flow: OtpFlow.changePhone,
          onResend: () async {
            final result = await _changePhoneRepository.startChangePhone(
              newPhone: newPhone,
            );
            return result.fold((_) => false, (_) => true);
          },
        ),
      ),
    );

    if (verified == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Phone number updated successfully'.tr())),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return BlocProvider(
      create: (_) => ChangePhoneBloc(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        body: BlocConsumer<ChangePhoneBloc, ChangePhoneState>(
          listener: (context, state) {
            if (state is ChangePhoneSuccess) {
              _openOtp(state.newPhone);
            } else if (state is ChangePhoneFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errMessage)),
              );
            }
          },
          builder: (context, state) {
            return SizedBox.expand(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/backgrounds/background1.png',
                      color: primary,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SafeArea(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 24,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(28),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .shadow,
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Container(
                                            width: 60,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              color: primary,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Center(
                                          child: SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/images/1.png",
                                                  color: primary,
                                                  width: 100,
                                                ),
                                                AnimatedBuilder(
                                                  animation: _toothController,
                                                  builder: (context, child) {
                                                    final scale = 1 +
                                                        (_toothController
                                                                .value *
                                                            0.15);
                                                    return Transform.scale(
                                                      scale: scale,
                                                      child: child,
                                                    );
                                                  },
                                                  child: Image.asset(
                                                    "assets/images/reset phone.png",
                                                    width: 45,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            "Change phone number".tr(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: onSurface,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Center(
                                          child: Text(
                                            "enter your new phone number and we will sent you a varification code."
                                                .tr(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color:
                                                  onSurface.withOpacity(0.7),
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        MaskedPhoneChip(
                                          label: "Current phone number".tr(),
                                          phone: _currentPhone,
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          "New phone number".tr(),
                                          style: TextStyle(
                                            color: onSurface,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        AppTextField(
                                          controller: _phonenumber,
                                          hint: "09xxxxxxxx",
                                          prefixIcon: Icons.phone_outlined,
                                          keyboardType: TextInputType.phone,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return "Phone number is required"
                                                  .tr();
                                            }
                                            if (!RegExp(r'^09\d{8}$')
                                                .hasMatch(value.trim())) {
                                              return "Phone number must start with 09 and contain 10 digits"
                                                  .tr();
                                            }
                                            if (_currentPhone != null &&
                                                _currentPhone!.isNotEmpty &&
                                                value.trim() ==
                                                    _currentPhone!.trim()) {
                                              return "New phone number must be different from current phone number."
                                                  .tr();
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 35),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 54,
                                          child: ElevatedButton(
                                            onPressed: state
                                                    is ChangePhoneLoading
                                                ? null
                                                : () {
                                                    if (!_formKey.currentState!
                                                        .validate()) {
                                                      return;
                                                    }
                                                    final newPhone =
                                                        _phonenumber.text
                                                            .trim();
                                                    if (_currentPhone != null &&
                                                        _currentPhone!
                                                            .isNotEmpty &&
                                                        newPhone ==
                                                            _currentPhone!
                                                                .trim()) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            "New phone number must be different from current phone number."
                                                                .tr(),
                                                          ),
                                                        ),
                                                      );
                                                      return;
                                                    }
                                                    context
                                                        .read<ChangePhoneBloc>()
                                                        .add(
                                                          ChangePhoneSubmitted(
                                                            newPhone: newPhone,
                                                          ),
                                                        );
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              elevation: 0,
                                            ),
                                            child: state is ChangePhoneLoading
                                                ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : Text(
                                                    "Continue".tr(),
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.background,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
