// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables, unused_import, unnecessary_import

import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mgt2/base.dart';

class Chat extends StatefulWidget {
  var user;
  Chat({super.key, required this.user});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  var it = TextEditingController();
  // List<Map<String, String>> msgs = [];
  List<dynamic> msgs = [];

  Future<void> init() async {
    var box = await Hive.openBox('box1');
    var c = box.get(widget.user);
    if (c != null) {
      setState(() {
        msgs = box.get(widget.user);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var sz = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[300],
        elevation: 0,
        title: Text(
          widget.user,
          style: GoogleFonts.poppins(color: Colors.blueGrey[700]),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: msgs.length,
              itemBuilder: (context, index) => Row(
                mainAxisAlignment:
                    (msgs[msgs.length - 1 - index]['me'].toString() == '1')
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: sz.width * 0.7),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: (msgs[msgs.length - 1 - index]['me']
                                        .toString() ==
                                    '1')
                                ? Colors.blue.shade900
                                : Colors.blueGrey.shade600,
                            offset: Offset(5, 5),
                            blurRadius: 15,
                          ),
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(-5, -5),
                            blurRadius: 15,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                        color:
                            (msgs[msgs.length - 1 - index]['me'].toString() ==
                                    '1')
                                ? Colors.lightBlueAccent[100]
                                : Colors.grey[300],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          msgs[msgs.length - 1 - index]['txt'].toString(),
                          style:
                              GoogleFonts.poppins(color: Colors.blueGrey[900]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: sz.width * 0.7,
                  child: TextField(
                    controller: it,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (it.text != '') {
                        String dt =
                            DateFormat('yyMMddHHmmss').format(DateTime.now());
                        addtoherfb(it.text, widget.user, dt);
                        addtomsgs(it.text, widget.user, dt);
                        init();
                      }

                      it.text = '';
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(100),
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
                        child: Icon(
                          CupertinoIcons.paperplane_fill,
                          size: 20,
                        )),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
