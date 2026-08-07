import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/widgets/app_text_field.dart';
import 'package:dental_app/features/Verify_otp/presentation/pages/otp_flow.dart';
import 'package:dental_app/features/Verify_otp/presentation/pages/verify_otp_page.dart';
import 'package:dental_app/features/reset_password/data/datasources/forget_password_remote_data_source.dart';
import 'package:dental_app/features/reset_password/domain/repositories/forget_password_repository_impl.dart';
import 'package:dental_app/features/reset_password/presentation/bloc/forget_password_bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InsertPhonenumberPage extends StatefulWidget {
  const InsertPhonenumberPage({super.key});

  @override
  State<InsertPhonenumberPage> createState() => _InsertPhonenumberPageState();
}

class _InsertPhonenumberPageState extends State<InsertPhonenumberPage>
    with SingleTickerProviderStateMixin {
  final _phonenumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _toothController;

  final ForgetPasswordRepositoryImpl _forgetPasswordRepository =
      ForgetPasswordRepositoryImpl(
    remoteDataSource: ForgetPasswordRemoteDataSource(
      api: DioConsumer(dio: Dio()),
    ),
  );

  @override
  void initState() {
    super.initState();
    _toothController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _toothController.dispose();
    _phonenumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgetPasswordBloc(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        body: BlocConsumer<ForgetPasswordBloc, ForgetPasswordState>(
          listener: (context, state) {
            if (state is ForgetPasswordSuccess) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VerifyOtpPage(
                    phone: state.phone,
                    flow: OtpFlow.forgotPassword,
                    onResend: () async {
                      final result = await _forgetPasswordRepository
                          .forgetPassword(phone: state.phone);
                      return result.fold((_) => false, (_) => true);
                    },
                  ),
                ),
              );
            } else if (state is ForgetPasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.failureMessage)),
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
                      color: Theme.of(context).colorScheme.primary,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SafeArea(
                    child: LayoutBuilder(builder: (context, constraints) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 24),
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraints.maxHeight),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.shadow,
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Form(
                                    key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Container(
                                          width: 60,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Center(
                                        child: SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Image.asset(
                                                "assets/images/1.png",
                                                color: Theme.of(context).colorScheme.primary,
                                                width: 100,
                                              ),
                                              AnimatedBuilder(
                                                animation: _toothController,
                                                builder: (context, child) {
                                                  final scale =
                                                      1 + (_toothController.value * 0.15);
                                                  return Transform.scale(
                                                    scale: scale,
                                                    child: child,
                                                  );
                                                },
                                                child: Image.asset(
                                                  "assets/images/phone.png",
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
                                          "Did you forget your password?".tr(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).colorScheme.onSurface,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Center(
                                        child: Text(
                                          "Enter your phone number and we will send you a varification code.".tr(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.9),
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Phone Number".tr(),
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onSurface,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      AppTextField(
                                        controller: _phonenumber,
                                        hint: "09xxxxxxxx",
                                        prefixIcon: Icons.phone_outlined,
                                        validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Phone number is required".tr();
                                    }
                                                                
                                    if (!RegExp(r'^09\d{8}$').hasMatch(value.trim())) {
                                      return "Phone number must start with 09 and contain 10 digits".tr();
                                    }
                                                                
                                    return null;
                                  },
                                      ),
                                      const SizedBox(height: 35),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 54,
                                        child: ElevatedButton(
                                          onPressed: state is ForgetPasswordLoading
                                      ? null
                                      : () {
                                          if (!_formKey.currentState!.validate()) return;
                                          context.read<ForgetPasswordBloc>().add(
                                                ForgetPasswordSubmitted(
                                                  phone: _phonenumber.text.trim(),
                                                ),
                                              );
                                        },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Theme.of(context).colorScheme.primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: state is ForgetPasswordLoading
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Send verification code".tr(),
                                                      style: TextStyle(
                                                        color: AppColors.background,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
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
                    }),
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