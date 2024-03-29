import 'package:cropx/four_button.dart';
import 'package:cropx/home.dart';
import 'package:cropx/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  String errorMessage = " ";
  bool islogin = false;

  loginpage() async {
    try {
      setState(() {
        islogin = true;
        errorMessage = '';
      });

      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text,
        password: passwordcontroller.text,
      );
      if (credential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const fourbutton()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        islogin = false;
        errorMessage = 'براے مہربانی دوبارہ کوشش کرین';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/login.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 150,
                ),
                const Text(
                  "SignIn/سائن ان",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  height: 70,
                  width: 300,
                  child: TextField(
                    controller: emailcontroller,
                    
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: "Enter Email/ ی میل درج کریں۔",
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 5,
                // ),
                Container(
                  height: 60,
                  width: 300,
                  child: TextField(
                    controller: passwordcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                      
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: "Enter Password / پاس ورڈ درج کریں",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      loginpage();
                    },
                    child: const Text(
                      "LogIn / لاگ ان کریں ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                    style: ButtonStyle(
                      shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(
                            width: 0.1,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      fixedSize: MaterialStateProperty.all<Size>(const Size(300, 50)),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 33, 150, 70),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUp()),
                    );
                  },
                  child: const Column(
                    children: [
                      // Text(
                      //   "If don't have an account, SignUp?",
                      //   style: TextStyle(
                      //     color: const Color.fromARGB(255, 0, 0, 0),
                      //     fontSize: 15,
                      //   ),
                      // ),
                      Text(
                        "اگر آپ کے پاس اکاؤنٹ نہیں ہے تو سائن اپ کریں؟",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
