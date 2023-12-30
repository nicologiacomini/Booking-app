import 'package:book_app/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewPromoterPage extends StatefulWidget {
  const NewPromoterPage({super.key});

  @override
  State<NewPromoterPage> createState() => _NewPromoterPageState();
}

class _NewPromoterPageState extends State<NewPromoterPage> {
  final _globalFormKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _newPasswordController1 = TextEditingController();
  final _newPasswordController2 = TextEditingController();

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? "Inserisci un'email valida"
        : null;
  }

  void signUp(String username, String email, String password) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(email)
        .set({'name': username, 'email': email});
    var signInDone = await Auth.mailRegister(email, password);
    if (signInDone != null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nuovo promoter aggiunto!")));
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _newPasswordController1.dispose();
    _newPasswordController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
          "assets/images/logo.jpg",
          height: 30.0,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _globalFormKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(
                      top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
                  child: const Text("Nome promoter",
                      style: TextStyle(fontSize: 20.0)),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(
                      top: 10.0, left: 20.0, right: 20.0, bottom: 20.0),
                  child: TextFormField(
                    validator: (String? value) {
                      if ((value != null && value.isEmpty) ||
                          value!.length < 3) {
                        return "L'username deve essere almeno 3 caratteri";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    controller: _usernameController,
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(
                      top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
                  child: const Text("Email", style: TextStyle(fontSize: 20.0)),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    validator: validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(
                      top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
                  child:
                      const Text("Password", style: TextStyle(fontSize: 20.0)),
                ),
                Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(
                        top: 10.0, left: 20.0, right: 20.0, bottom: 20.0),
                    child: TextFormField(
                      validator: (String? inputValue) {
                        if ((inputValue != null && inputValue.isEmpty) ||
                            inputValue!.length < 6) {
                          return "La password deve contenere almeno 6 caratteri";
                        }
                        return null;
                      },
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _newPasswordController1,
                    )),
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(
                      top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
                  child: const Text("Conferma password",
                      style: TextStyle(fontSize: 20.0)),
                ),
                Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(
                        top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
                    child: TextFormField(
                      validator: (String? inputValue) {
                        if (_newPasswordController1.text.trim() !=
                            _newPasswordController2.text.trim()) {
                          return "Le password devono essere uguali";
                        }
                        return null;
                      },
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _newPasswordController2,
                    )),
                Container(
                  margin: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_globalFormKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Nuovo promoter aggiunto")));
                        Navigator.pop(context);
                        signUp(
                            _usernameController.text,
                            _emailController.text.trim(),
                            _newPasswordController1.text);
                      }
                    },
                    child: const Text(
                      "Registra nuovo promoter",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
