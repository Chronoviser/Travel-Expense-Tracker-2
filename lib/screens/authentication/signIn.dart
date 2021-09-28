import 'package:Travel_Expense_Tracker/services/toast-service.dart';
import 'package:flutter/material.dart';
import '../../constants/custom-colors.dart';
import 'signUp.dart';
import '../trips/my-trips.dart';
import '../../services/auth-service.dart';

class SignIn extends StatefulWidget {
  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  bool obsText = true;

  AuthService authService = new AuthService();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  signInUser() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      authService
          .signIn(
              email: emailController.text, password: passwordController.text)
          .then((_) async {
        Navigator.of(context)
            .push(PageRouteBuilder(pageBuilder: (context, _, __) => MyTrips()));
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
        ToastService.errorToast(context: context, message: e.message);
      });
    }
  }

  signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    authService.googleLogin(context).then((_) {
      Navigator.of(context)
          .push(PageRouteBuilder(pageBuilder: (context, _, __) => MyTrips()));
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      ToastService.errorToast(context: context, message: e.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/moon.jpg"),
                        fit: BoxFit.cover)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 70, bottom: 50),
                      width: MediaQuery.of(context).size.width,
                      child: signInWithGoogleButton(),
                    ),
                    orLine(),
                    Form(key: formKey, child: loginCard(context)),
                  ],
                ),
              ),
            ),
    );
  }

  Widget signInWithGoogleButton() {
    return GestureDetector(
        onTap: () {
          signInWithGoogle();
        },
        child: Center(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: CustomColor.blackTrans,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/googleicon.png'))),
                  ),
                  Text(
                    'Log in with google',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: CustomColor.white),
                  ),
                  SizedBox(width: 1),
                ],
              )),
        ));
  }

  Widget orLine() {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              color: CustomColor.lightBlack,
              height: 1,
              width: MediaQuery.of(context).size.width / 3),
          Text('or', style: TextStyle(color: CustomColor.lightBlack)),
          Container(
              color: CustomColor.lightBlack,
              height: 1,
              width: MediaQuery.of(context).size.width / 3),
        ],
      ),
    );
  }

  Widget loginCard(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.5),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(vertical: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 50,
                  child: Column(
                    children: [
                      Text("Login",
                          style: TextStyle(
                              fontSize: 26, color: CustomColor.accentLight)),
                      SizedBox(height: 4),
                      Container(height: 2, width: 60, color: CustomColor.accent)
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        PageRouteBuilder(pageBuilder: (context, _, __) {
                      return SignUp();
                    }));
                  },
                  child: Container(
                    height: 50,
                    child: Column(
                      children: [
                        Text("Sign-up",
                            style: TextStyle(
                                fontSize: 26, color: CustomColor.hint)),
                        SizedBox(height: 4),
                        // Container(height: 1, width: 80, color: CustomColor.accent)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            elevation: 2,
            child: ListTile(
              dense: true,
              title: TextFormField(
                validator: emailValidator,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                maxLines: 1,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Email',
                  labelStyle: TextStyle(color: CustomColor.hint),
                  hintText: 'email@example.com',
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            elevation: 2,
            child: ListTile(
              dense: true,
              title: TextFormField(
                validator: passwordValidator,
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                maxLines: 1,
                obscureText: obsText,
                decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Password',
                    labelStyle: TextStyle(color: CustomColor.hint),
                    hintText: 'pa**word',
                    border: UnderlineInputBorder()),
              ),
              trailing: GestureDetector(
                  onTap: () {
                    setState(() {
                      obsText = !obsText;
                    });
                  },
                  child: obsText
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility)),
            ),
          ),
          GestureDetector(
            onTap: signInUser,
            child: Container(
              margin: EdgeInsets.only(top: 20, bottom: 25, left: 50, right: 50),
              width: MediaQuery.of(context).size.width,
              child: customButton(
                  context: context,
                  title: 'log in',
                  filled: true,
                  width: MediaQuery.of(context).size.width / 4),
            ),
          )
        ],
      ),
    );
  }
}

String emailValidator(email) {
  return RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email)
      ? null
      : "Invalid Email";
}

String passwordValidator(password) {
  return password.length >= 6 ? null : "At least 6 characters long";
}
