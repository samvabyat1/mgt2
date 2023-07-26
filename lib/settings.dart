// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mgt2/base.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: [
                InkWell(
                  onTap: () async {
                    if (await clearsp() == true) {
                      showsnack('log cleared!', context);
                      Navigator.pop(context);
                    }
                  },
                  child: SettingGridItem(
                    icone: Icons.logout,
                    texte: 'Log out',
                  ),
                ),
                InkWell(
                  onTap: () {
                    clearbox().whenComplete(() => Navigator.pop(context));
                  },
                  child: SettingGridItem(
                    icone: Icons.remove_circle_outline,
                    texte: 'Delete box',
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}

class SettingGridItem extends StatelessWidget {
  IconData icone;
  String texte;
  SettingGridItem({super.key, required this.icone, required this.texte});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
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
          child: Center(
            child: Wrap(
              direction: Axis.vertical,
              spacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(
                  icone,
                  size: 40,
                ),
                Text(texte)
              ],
            ),
          )),
    );
  }
}
