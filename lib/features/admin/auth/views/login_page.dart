import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/views/custom_button.dart';
import '../../../../core/views/custom_input.dart';
import '../../../../generated/assets.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/styles.dart';
import '../provider/admin_login_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    var style = Styles(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            style.isMobile
                ? _buildForm()
                : Container(
                    width:
                        style.isDesktop ? style.width * .6 : style.width * .7,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ]),
                    child: Row(
                      children: [
                        Container(
                          height: 450,
                          width: style.width * .3,
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Image.asset(
                            Assets.imagesLogin,
                          ),
                        ),
                        Expanded(child: _buildForm())
                      ],
                    ),
                  ),
          ],
        )),
      ),
    );
  }

  Widget _buildForm() {
    var style = Styles(context);
    var notifier = ref.read(adminLoginProvider.notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            if (style.isMobile)
              Image.asset(
                Assets.imagesLogin,
                width: 200,
                height: 200,
              ),
            if (style.isMobile) const SizedBox(height: 12),
            Text('ADMIN LOGIN',
                style: style.title(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontSize: style.isDesktop
                        ? 35
                        : style.isTablet
                            ? 30
                            : 20)),
            const Divider(
              height: 22,
              thickness: 3,
            ),
            const SizedBox(height: 15),
            CustomTextFields(
              label: 'Admin ID',
              prefixIcon: Icons.email,
              hintText: 'Enter admin ID',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter admin ID';
                }
                return null;
              },
              onSaved: (email) {
                notifier.setId(email!);
              },
            ),
            const SizedBox(height: 22),
            CustomTextFields(
              label: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icons.lock,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onSaved: (password) {
                notifier.setPassword(password!);
              },
              obscureText: _isObscure,
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
            ),
           const SizedBox(height: 22),
            CustomButton(
                text: 'Login',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    notifier.loginAdmin(context: context, ref: ref);
                  }
                }),
            const SizedBox(height: 22),
           ],
        ),
      ),
    );
  }
}
