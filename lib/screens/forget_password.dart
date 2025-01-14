import 'package:flutter/material.dart';
import 'package:graduationproject/screens/login.dart';
import 'constants.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    // New Password TextField
    Widget _buildNewPasswordTextField() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: kInputColor,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          const Expanded(
            child: TextField(
              obscureText: true,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: "New password",
                hintStyle: TextStyle(
                  fontSize: 17.5,
                  fontWeight: FontWeight.w500,
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: kInputColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Confirm TextField
    Widget _buildConfirmPasswordTextField() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: kInputColor,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          const Expanded(
            child: TextField(
              obscureText: true,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: "Confirm new password",
                hintStyle: TextStyle(
                  fontSize: 17.5,
                  fontWeight: FontWeight.w500,
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: kInputColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Submit Button
    Widget _buildSubmitBtn() {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: MaterialButton(
          elevation: 0.0,
          highlightElevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          color: Color.fromARGB(255, 74, 20, 140),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
          child: const Text(
            "Submit",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.only(top: 30, left: 25.0, right: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: kBackButtonColor,
                  ),
                ),
              ),
              Center(
                child: Expanded(
                  flex: 8,
                  child: Image.asset("assets/images/rest password.jpg"),
                ),
              ),
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Reset Password",
                      style: TextStyle(
                        color: Color.fromARGB(255, 74, 20, 140),
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    _buildNewPasswordTextField(),
                    const SizedBox(height: 30.0),
                    _buildConfirmPasswordTextField(),
                    const SizedBox(height: 50.0),
                    _buildSubmitBtn()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
