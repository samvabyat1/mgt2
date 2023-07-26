// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:mgt2/settings.dart';
import 'package:search_page/search_page.dart';
import 'base.dart';
import 'chat.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  var net = false;
  List<String> users = [];
  List<String> chatlist = [];
  List<String> newlist = [];

  Future<void> getbox() async {
    var box = await Hive.openBox('box1');
    var c = box.get('chatlist');
    var n = box.get('newlist');
    setState(() {
      if (c != null) {
        chatlist = box.get('chatlist');
      }
      if (n != null) {
        newlist = box.get('newlist');
      }
    });
  }

  Future<void> init() async {
    getbox();

    print(chatlist);
    print(newlist);

    var me = await getsp('user');
    db.child(me).onValue.listen((event) {
      for (final child in event.snapshot.children) {
        if (child.key.toString() != 'joined') {
          addtonewlist(child.key.toString());
          for (final child1 in child.children) {
            addtohermsgs(child1.value.toString(), child.key.toString(),
                child1.key.toString());

            db
                .child(me)
                .child(child.key.toString())
                .child(child1.key.toString())
                .remove();
          }
        }
      }
      getbox();
    });
  }

  @override
  Widget build(BuildContext context) {
    var sz = MediaQuery.of(context).size;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.grey[300],
      systemNavigationBarColor: Colors.grey[300],
      statusBarIconBrightness: Brightness.dark,
    ));

    search() => showSearch(
          context: context,
          delegate: SearchPage<String>(
            barTheme: ThemeData(
                scaffoldBackgroundColor: Colors.grey[300],
                appBarTheme: AppBarTheme(
                  iconTheme: IconThemeData(color: Colors.blue),
                  backgroundColor: Colors.grey[300],
                  elevation: 0,
                )),
            items: users,
            searchLabel: 'Type username',
            suggestion: Center(
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
                    CupertinoIcons.search,
                    size: sz.shortestSide * 0.4,
                  ),
                ),
                Text(
                  textAlign: TextAlign.end,
                  'Search your friends\nand start chat',
                  style: GoogleFonts.montserrat(color: Colors.blueGrey[700]),
                ),
              ],
            )),
            failure: Center(
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
                      Colors.redAccent.shade100,
                      Colors.blueGrey.shade200,
                    ],
                  ).createShader(bounds),
                  child: Icon(
                    CupertinoIcons.exclamationmark_triangle_fill,
                    size: sz.shortestSide * 0.4,
                  ),
                ),
                Text(
                  textAlign: TextAlign.end,
                  'Not found!',
                  style: GoogleFonts.montserrat(color: Colors.blueGrey[700]),
                ),
              ],
            )),
            filter: (user) => [user],
            builder: (t) => EachUser(
              user: t,
            ),
          ),
        );

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: LiquidPullToRefresh(
          onRefresh: () => init(),
          backgroundColor: Colors.blueGrey[300],
          color: Colors.grey[300],
          height: sz.longestSide * 0.2,
          animSpeedFactor: 2,
          showChildOpacityTransition: false,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.grey[300],
                expandedHeight: sz.longestSide * 0.4,
                floating: false,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: ShaderMask(
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
                ),
              ),
              SliverToBoxAdapter(
                child: Wrap(
                  alignment: WrapAlignment.end,
                  // spacing: 25,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          users = await getallusers();
                          search();
                        },
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
                            child: Icon(Icons.search)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => Settings(),
                            )),
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
                            child: Icon(Icons.settings)),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your chats',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[700],
                          fontSize: 20,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            net = !net;
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: SizedBox(
                            height: 10,
                            width: sz.width * 0.2,
                            child: Visibility(
                              visible: net,
                              replacement: Container(
                                color: Colors.blueGrey[300],
                              ),
                              child: AnimateGradient(
                                primaryBegin: Alignment.topLeft,
                                primaryEnd: Alignment.bottomLeft,
                                secondaryBegin: Alignment.bottomLeft,
                                secondaryEnd: Alignment.topRight,
                                primaryColors: const [
                                  Colors.green,
                                  Colors.greenAccent,
                                  Colors.white,
                                ],
                                secondaryColors: const [
                                  Colors.white,
                                  Colors.lightBlueAccent,
                                  Colors.lightBlue,
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: newlist.length,
                      (context, index) => EachUser(
                            user: newlist[index],
                            isnew: true,
                          ))),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: chatlist.length,
                      (context, index) =>
                          (newlist.contains(chatlist[index]) == false)
                              ? EachUser(
                                  user: chatlist[index],
                                )
                              : SizedBox()))
            ],
          ),
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () async {
          users = await getallusers();
          search();
        },
        child: Container(
            padding: EdgeInsets.all(25),
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
            child: Icon(Icons.edit)),
      ),
    );
  }
}

class EachUser extends StatefulWidget {
  String user;
  bool isnew;
  EachUser({super.key, required this.user, this.isnew = false});

  @override
  State<EachUser> createState() => _EachUserState();
}

class _EachUserState extends State<EachUser> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        addtochatlist(widget.user);
        if (widget.isnew) {
          markasread(widget.user);
        }
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => Chat(
                user: widget.user,
              ),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueGrey[300],
              child: Icon(
                CupertinoIcons.person_fill,
                color: Colors.grey[300],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Wrap(
              direction: Axis.vertical,
              children: [
                Text(
                  widget.user,
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight:
                          widget.isnew ? FontWeight.bold : FontWeight.normal),
                ),
                Text(
                  'recently joined',
                  style: GoogleFonts.poppins(color: Colors.grey),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
