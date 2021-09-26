import 'package:flutter/material.dart';
import 'package:travel_expense_tracker/constants/custom-colors.dart';
import 'package:travel_expense_tracker/screens/authentication/signIn.dart';
import 'package:travel_expense_tracker/screens/trips/my-trips.dart';
import 'package:provider/provider.dart';
import 'package:travel_expense_tracker/services/authentication-service.dart';
import 'package:travel_expense_tracker/services/user-handler.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  bool obsText = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  signUpNewUser() {
    if (formKey.currentState.validate() &&
        passwordController.text == password2Controller.text) {
      setState(() {
        isLoading = true;
      });

      context
          .read<AuthenticationService>()
          .signUp(
              email: emailController.text, password: passwordController.text)
          .then((_) {
        new UserHandler().createUser(email: emailController.text);

        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyTrips()));
      }).catchError((_) {
        setState(() {
          isLoading = false;
        });
        print('User already exists');
      });
    } else if (formKey.currentState.validate() &&
        passwordController.text != password2Controller.text) {
      print('passwords don\'t match');
    }
  }

  signInWithGoogle() {
    setState(() {
      isLoading = true;
    });

    context.read<AuthenticationService>().googleLogin().then((_) {
      new UserHandler().createUser(email: "");

      setState(() {
        isLoading = false;
      });
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
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 70, bottom: 50),
                      width: MediaQuery.of(context).size.width,
                      child: signInWithGoogleButton(),
                    ),
                    orLine(),
                    Form(key: formKey, child: SignUpCard(context)),
                  ],
                ),
              ),
            ),
    );
  }

  Widget signInWithGoogleButton() {
    return GestureDetector(
        onTap: () => {signInWithGoogle()},
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
                    'Sign up with google',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
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
              color: Colors.black38,
              height: 1,
              width: MediaQuery.of(context).size.width / 3),
          Text('or', style: TextStyle(color: Colors.black38)),
          Container(
              color: Colors.black38,
              height: 1,
              width: MediaQuery.of(context).size.width / 3),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget SignUpCard(BuildContext context) {
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
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        PageRouteBuilder(pageBuilder: (context, _, __) {
                      return SignIn();
                    }));
                  },
                  child: Container(
                    height: 50,
                    child: Column(
                      children: [
                        Text("Login",
                            style: TextStyle(
                                fontSize: 26, color: Colors.blueGrey)),
                        SizedBox(height: 4),
                        //Container(height: 2, width: 60, color: Colors.accent)
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  child: Column(
                    children: [
                      Text("Sign-up",
                          style: TextStyle(
                              fontSize: 26, color: CustomColor.accentLight)),
                      SizedBox(height: 4),
                      Container(height: 2, width: 80, color: CustomColor.accent)
                    ],
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
                  labelStyle: TextStyle(color: Colors.blueGrey),
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
                    labelStyle: TextStyle(color: Colors.blueGrey),
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
          Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            elevation: 2,
            child: ListTile(
              dense: true,
              title: TextFormField(
                validator: password2Validator,
                controller: password2Controller,
                keyboardType: TextInputType.visiblePassword,
                maxLines: 1,
                obscureText: obsText,
                decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(color: Colors.blueGrey),
                    hintText: 'confirm pa**word',
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
            onTap: signUpNewUser,
            child: Container(
              margin: EdgeInsets.only(top: 20, bottom: 25, left: 50, right: 50),
              width: MediaQuery.of(context).size.width,
              child: customButton(
                  context: context,
                  title: 'Sign up',
                  filled: true,
                  width: MediaQuery.of(context).size.width / 4),
            ),
          ),
        ],
      ),
    );
  }

  String password2Validator(String password) {
    return password.compareTo(passwordController.text) == 0
        ? null
        : "passwords don't match";
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

Widget customButton(
    {@required BuildContext context,
    @required String title,
    @required bool filled,
    double height = 50,
    @required double width}) {
  return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: filled ? CustomColor.blackTrans : CustomColor.white,
          borderRadius: BorderRadius.circular(8)),
      child: Center(
          child: Text(
        title,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: filled ? CustomColor.white : CustomColor.accent),
      )));
}
