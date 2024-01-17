import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nutriscan/features/auth/presentation/auth_controller.dart';
import 'package:nutriscan/theme.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: secondary,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 32, left: 16, bottom: 64),
              child: Text(
                'NutriScan',
                style: TextStyle(
                    color: HexColor("#17894C"),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.only(top: 64, left: 18, right: 20),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        )
                        ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Daftar",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 28),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'tolong masukkan email anda';
                            }
                            return null;
                          },
                          // style: logInput,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(width: 0.7, color: graySecond),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(width: 0.7, color: graySecond),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primary)),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            hintText: 'Email',
                            hintStyle: TextStyle(
                                color: gray, fontWeight: FontWeight.w400),

                            // hintStyle: emailHint,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'tolong masukkan nama anda';
                            }
                            return null;
                          },
                          // style: logInput,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(width: 0.7, color: graySecond),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(width: 0.7, color: graySecond),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primary)),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            hintText: 'Nama kamu',
                            hintStyle: TextStyle(
                                color: gray, fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'tolong masukkan password anda';
                            }
                            return null;
                          },
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(width: 0.7, color: graySecond),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  BorderSide(width: 1, color: graySecond),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primary)),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                                color: gray, fontWeight: FontWeight.w400),
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.remove_red_eye_outlined),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: TextButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate() &&
                                    _isLoading == false) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await ref
                                      .read(authControllerProvider.notifier)
                                      .signUp(
                                          context,
                                          _emailController.text,
                                          _nameController.text,
                                          _passwordController.text);
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                'Daftar Sekarang',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 130,
                              height: 1,
                              color: HexColor('#A6A6A6'),
                            ),
                            Text(
                              'Atau',
                              // style: orTxt,
                            ),
                            Container(
                              width: 130,
                              height: 1,
                              color: HexColor('#A6A6A6'),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Center(
                          child: OutlinedButton(
                            onPressed: () {},
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/image/icon-google.png',
                                  width: 28,
                                  height: 28,
                                ),
                                // Icon(Icons.security),
                                SizedBox(
                                  width: 48,
                                ),
                                Text(
                                  'Lanjut dengan Google',
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 16),
                                ),
                              ],
                            ),
                            style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.only(
                                    top: 16, bottom: 16, left: 20),
                                shape: RoundedRectangleBorder(
                                    // side: BorderSide(color: Colors.r),
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Sudah punya akun? ",
                                // style: dontTxt
                                style: TextStyle(
                                    fontSize: 15,
                                    color: gray,
                                    fontWeight: FontWeight.w400),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.pushNamed("sign-in");
                                },
                                child: Text(
                                  'Masuk',
                                  style:
                                      TextStyle(color: primary, fontSize: 15),
                                  // style: txtBtnBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
