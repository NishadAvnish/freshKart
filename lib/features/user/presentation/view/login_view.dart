import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fresh_kart/features/user/domain/entity/login_req_entity.dart';
import 'package:fresh_kart/features/user/presentation/provider/login_providers.dart';
import 'package:fresh_kart/utils/app_strings.dart';
import 'package:fresh_kart/components/textfield.dart';
import 'package:fresh_kart/utils/app_regex.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fresh_kart/utils/assets.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userInfoProvider = ref.read(userProvider.notifier);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: SvgPicture.asset(
                  Assets.grocery,
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.loginTitle,
                      style: Theme.of(context).textTheme.headlineMedium),
                  SizedBox(height: 24),

                  // Email Field
                  CustomTextField(
                    controller: _emailController,
                    hintText: AppStrings.emailHint,
                    labelText: AppStrings.emailLabel,
                    keyboardType: TextInputType.emailAddress,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(AppRegex.noSpaces),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.emailEmptyError;
                      }
                      if (!AppRegex.emailPattern.hasMatch(value)) {
                        return AppStrings.emailInvalidError;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Password Field
                  CustomTextField(
                    controller: _passwordController,
                    hintText: AppStrings.passwordHint,
                    labelText: AppStrings.passwordLabel,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(AppRegex.noSpaces),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.passwordEmptyError;
                      }
                      if (!AppRegex.passwordMinLength.hasMatch(value)) {
                        return AppStrings.passwordLengthError;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),

                  // Login Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          userInfoProvider.login(
                            context,
                            LoginReqEntity(
                                email: _emailController.text,
                                password: _passwordController.text),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                      child: Text(AppStrings.loginButton,
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
