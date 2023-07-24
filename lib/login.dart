// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'base.dart';
import 'home.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() async {
    var s = await getsp('user');
    if (s != "null") {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var sz = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Wrap(
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (Rect bounds) => LinearGradient(
                begin: Alignment.bottomLeft,
                // stops: [.5, 1],
                colors: [
                  Colors.blueGrey.shade400,
                  Colors.blueGrey.shade200,
                ],
              ).createShader(bounds),
              child: Icon(
                CupertinoIcons.bolt_horizontal_fill,
                size: sz.shortestSide * 0.4,
              ),
            ),
            Wrap(
              children: [
                GradientText(
                  'Messaging Redesigned',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                  colors: [
                    Colors.blueGrey.shade500,
                    Colors.blueGrey.shade400,
                    Colors.lightBlueAccent,
                    Colors.blueGrey.shade300,
                    Colors.blueGrey.shade200,
                  ],
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => LoginModal(),
          );
        },
        child: Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.shade600,
                    offset: Offset(5, 5),
                    blurRadius: 15,
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-5, -5),
                    blurRadius: 15,
                  )
                ]),
            child: Icon(Icons.login)),
      ),
    );
  }
}

class LoginModal extends StatefulWidget {
  const LoginModal({super.key});

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  var useravail = true;
  var username = '';

  @override
  Widget build(BuildContext context) {
    var sz = MediaQuery.of(context).size;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your username',
              style: GoogleFonts.poppins(color: Colors.black, fontSize: 20),
            ),
            Wrap(
              children: [
                SizedBox(
                  width: sz.width * 0.7,
                  child: TextField(
                    onChanged: (value) {
                      username = value;
                      setState(() {});
                    },
                  ),
                ),
                IconButton(
                    disabledColor: Colors.blueGrey,
                    color: Colors.blueAccent,
                    onPressed: (useravail == true && username.length > 2)
                        ? () {
                            setup(username);
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Home(),
                                ));
                          }
                        : null,
                    icon: Icon(
                      CupertinoIcons.check_mark,
                    ))
              ],
            ),
            Visibility(
              visible: username.length > 2,
              child: Visibility(
                visible: useravail,
                replacement: Text(
                  'Username not available!',
                  style: TextStyle(color: Colors.redAccent.shade700),
                ),
                child: Text(
                  'Username available!',
                  style: TextStyle(color: Colors.green.shade700),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
