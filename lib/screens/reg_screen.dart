import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ruta_user/screens/login_screen.dart';
import 'package:ruta_user/services/auth_services.dart';

class UserTypeSelector extends StatefulWidget {
  final ValueChanged<String>
      onUserTypeChanged; // Callback for user type changes

  UserTypeSelector({required this.onUserTypeChanged});

  @override
  _UserTypeSelectorState createState() => _UserTypeSelectorState();
}

class _UserTypeSelectorState extends State<UserTypeSelector> {
  String _selectedUserType = 'Passenger';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16),
              'Are you a'),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Radio<String>(
                value: 'Passenger',
                groupValue: _selectedUserType,
                onChanged: (value) {
                  setState(() {
                    _selectedUserType = value!;
                    widget.onUserTypeChanged(_selectedUserType);
                  });
                },
              ),
              Text('Passenger'),
              SizedBox(width: 20),
              Radio<String>(
                value: 'Driver',
                groupValue: _selectedUserType,
                onChanged: (value) {
                  setState(() {
                    _selectedUserType = value!;
                    widget.onUserTypeChanged(_selectedUserType);
                  });
                },
              ),
              Text('Driver'),
            ],
          ),
        ],
      ),
    );
  }
}

class Signup extends StatefulWidget {
  Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  String _selectedUserType = 'Passenger'; // Track selected user type

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: _signin(context),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 50,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  const Center(
                    child: Text('Register Account',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 32)),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  _displayName(),
                  const SizedBox(
                    height: 20,
                  ),
                  _emailAddress(),
                  const SizedBox(
                    height: 20,
                  ),
                  _password(),
                  const SizedBox(
                    height: 20,
                  ),
                  UserTypeSelector(
                    onUserTypeChanged: (userType) {
                      setState(() {
                        _selectedUserType = userType;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  _signup(context),
                ],
              ),
            ),
          )),
    );
  }

  Widget _emailAddress() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email Address',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
        ),
        const SizedBox(
          height: 16,
        ),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
              filled: true,
              hintText: 'example@gmail.com',
              hintStyle: const TextStyle(
                  color: Color(0xff6A6A6A),
                  fontWeight: FontWeight.normal,
                  fontSize: 14),
              fillColor: const Color(0xffF7F7F9),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(14))),
        )
      ],
    );
  }

  Widget _password() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
        ),
        const SizedBox(
          height: 16,
        ),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xffF7F7F9),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(14))),
        )
      ],
    );
  }

  Widget _displayName() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Display Name',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
        ),
        const SizedBox(
          height: 16,
        ),
        TextField(
          controller: _displayNameController,
          decoration: InputDecoration(
              filled: true,
              hintText: 'Name',
              hintStyle: const TextStyle(
                  color: Color(0xff6A6A6A),
                  fontWeight: FontWeight.normal,
                  fontSize: 14),
              fillColor: const Color(0xffF7F7F9),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(14))),
        )
      ],
    );
  }

  Widget _signup(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size(double.infinity, 60),
        elevation: 0,
      ),
      onPressed: () async {
        if (_selectedUserType == 'Driver') {
          await AuthService().driverSignup(
            email: _emailController.text,
            password: _passwordController.text,
            displayName: _displayNameController.text,
            context: context,
          );
        } else {
          await AuthService().signup(
            email: _emailController.text,
            password: _passwordController.text,
            displayName: _displayNameController.text,
            context: context,
          );
        }
      },
      child: const Text("Sign Up"),
    );
  }

  Widget _signin(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            const TextSpan(
              text: "Already Have Account? ",
              style: TextStyle(
                  color: Color(0xff6A6A6A),
                  fontWeight: FontWeight.normal,
                  fontSize: 16),
            ),
            TextSpan(
                text: "Log In",
                style: const TextStyle(
                    color: Color(0xff1A1D1E),
                    fontWeight: FontWeight.normal,
                    fontSize: 16),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  }),
          ])),
    );
  }
}
