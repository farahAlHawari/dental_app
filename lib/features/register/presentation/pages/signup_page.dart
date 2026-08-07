import 'package:dental_app/core/api/dio_consumer.dart';
import 'package:dental_app/core/theme/app_colors.dart';
import 'package:dental_app/core/theme/bloc/theme_bloc_bloc.dart';
import 'package:dental_app/core/theme/bloc/theme_bloc_event.dart';
import 'package:dental_app/core/utils/shared_prefs.dart';
import 'package:dental_app/core/widgets/app_text_field.dart';
import 'package:dental_app/features/Verify_otp/presentation/pages/otp_flow.dart';
import 'package:dental_app/features/Verify_otp/presentation/pages/verify_otp_page.dart';
import 'package:dental_app/features/login/presentation/pages/login_page.dart';
import 'package:dental_app/features/register/data/datasources/register_remote_data_source.dart';
import 'package:dental_app/features/register/domain/repositories/register_repository_impl.dart';
import 'package:dental_app/features/register/presentation/bloc/register_bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();

  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final _confirmPasswordController = TextEditingController();
  bool _obscureConfirmPassword = true;

  late AnimationController _toothController;
  final _formKey = GlobalKey<FormState>();

  final RegisterRepositoryImpl _registerRepository = RegisterRepositoryImpl(
  remoteDataSource: RegisterRemoteDataSource(
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
    _phoneController.dispose();
    _passwordController.dispose();
    _toothController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      body: SizedBox.expand(
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
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
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
                                          // الدائرة الخلفية
                                          Image.asset(
                                            "assets/images/1.png",
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            width: 100,
                                          ),
                              
                                          AnimatedBuilder(
                                            animation: _toothController,
                                            builder: (context, child) {
                                              final scale =
                                                  1.3 +
                                                  (_toothController.value * 0.15);
                                              return Transform.scale(
                                                scale: scale,
                                                child: child,
                                              );
                                            },
                                            child: Image.asset(
                                              "assets/images/3.png",
                                              width: 45,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      "Sign Up".tr(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Center(
                                    child: Text(
                                      "Create your account to get started".tr(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface.withOpacity(0.7),
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                              
                                  SizedBox(height: 20),
                                  Text(
                                    "Phone Number".tr(),
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  AppTextField(
                                    controller: _phoneController,
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
                              
                                  SizedBox(height: 20),
                              
                                  Text(
                                    "Password".tr(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                              
                                  AppTextField(
                                controller: _passwordController,
                                hint: "••••••••",
                                isPassword: true,
                                prefixIcon: Icons.lock_outline,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Password is required".tr();
                                  }
                              
                                  if (value.length < 8) {
                                    return "Password must be at least 8 characters".tr();
                                  }
                              
                                  return null;
                                },
                              ),
                              
                                  SizedBox(height: 20),
                                  Text(
                                    "Confirm Password".tr(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                              
                                  AppTextField(
                                controller: _confirmPasswordController,
                                hint: "••••••••",
                                isPassword: true,
                                prefixIcon: Icons.lock_outline,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please confirm your password".tr();
                                  }
                              
                                  if (value != _passwordController.text) {
                                    return "Passwords do not match".tr();
                                  }
                              
                                  return null;
                                },
                              ),
                              
                                  SizedBox(height: 40),
                                  BlocProvider(
                                    create: (context) => RegisterBloc(),
                                    child: BlocConsumer<RegisterBloc, RegisterState>(
                                      listener: (context, state) {
                                        if (state is RegisterSuccess) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => VerifyOtpPage(
                                                phone: _phoneController.text,
                                                flow: OtpFlow.register,
                                               onResend: () async {
  final language = await SharedPrefs.getLanguage() ?? "en";
  final result = await _registerRepository.register(
    phone: _phoneController.text,
    password: _passwordController.text,
    confirmPassword: _confirmPasswordController.text,
    language: language,
  );
  return result.fold(
    (failure) => false,
    (_) => true,
  );
},
                                              ),
                                            ),
                                          );
                                        } else if (state is RegisterFailure) {
                                          // ACTIVE already exists → dialog + Login.
                                          if (state.statusCode == 409) {
                                            showDialog<void>(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: Text(
                                                  'Account already exists'.tr(),
                                                ),
                                                content: Text(
                                                  state.errMessage,
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(ctx),
                                                    child: Text('Cancel'.tr()),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(ctx);
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              const LoginPage(),
                                                        ),
                                                      );
                                                    },
                                                    child: Text('Login'.tr()),
                                                  ),
                                                ],
                                              ),
                                            );
                                            return;
                                          }
                                          // DISABLED / INVITED / other → backend message only.
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(state.errMessage),
                                            ),
                                          );
                                        }
                                      },
                                      builder: (context, state) {
                                        return SizedBox(
                                          width: double.infinity,
                                          height: 54,
                                          child: ElevatedButton(
                                            onPressed: state is RegisterLoading
                                                ? null
                                                : () async {
                                                    if (!_formKey.currentState!
                                                        .validate()) {
                                                      return;
                                                    }
                                                    final language =
                                                        await SharedPrefs
                                                                .getLanguage() ??
                                                            'en';

                                                    context
                                                        .read<RegisterBloc>()
                                                        .add(
                                                          RegisterSubmitted(
                                                            phone:
                                                                _phoneController
                                                                    .text,
                                                            password:
                                                                _passwordController
                                                                    .text,
                                                            confirmPassword:
                                                                _confirmPasswordController
                                                                    .text,
                                                            language: language,
                                                          ),
                                                        );
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              elevation: 0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                if (state is RegisterLoading)
                                                  const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                else
                                                  Text(
                                                    'Sign Up'.tr(),
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .scaffoldBackgroundColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                              
                                  const SizedBox(height: 20),
                              
                                  Divider(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                              
                                  const SizedBox(height: 16),
                              
                                  Row(
                                    children: [
                                      Text(
                                        "Already have an account?".tr(),
                              
                                        textAlign: TextAlign.center,
                              
                                        style: TextStyle(
                                          fontSize: 14,
                              
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.7),
                                        ),
                                      ),
                              
                                      const SizedBox(height: 6),
                              
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginPage(),
                                            ),
                                          );
                                        },
                              
                                        child: Text(
                                          "Login".tr(),
                              
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                              
                                            fontWeight: FontWeight.bold,
                              
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
      ),
    );
  }
}