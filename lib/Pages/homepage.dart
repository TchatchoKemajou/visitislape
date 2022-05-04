import 'dart:async';

import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:visitislape/API/securityapi.dart';
import 'package:visitislape/Pages/Auth/register.dart';
import 'package:visitislape/Pages/dashboardpage.dart';
import 'package:visitislape/Pages/employepage.dart';
import 'package:visitislape/Pages/historiquepage.dart';
import 'package:visitislape/Pages/studentpage.dart';
import 'package:visitislape/Pages/traficpage.dart';
import 'package:visitislape/Pages/visitorpage.dart';
import 'package:visitislape/Pages/visitpage.dart';
import 'package:visitislape/constantes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SecurityApi securityApi = SecurityApi();
  String heure = (DateTime.now().hour.toString().length == 1 ? "0" + DateTime.now().hour.toString() : DateTime.now().hour.toString()) + " : " + (DateTime.now().minute.toString().length == 1 ? "0" + DateTime.now().minute.toString() : DateTime.now().minute.toString());
  PageController page = PageController();

  @override
  Widget build(BuildContext context) {
    datetime();
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: page,
            style: SideMenuStyle(
              displayMode: SideMenuDisplayMode.auto,
              hoverColor: Colors.blue[100],
              selectedColor: secondcolor,
              unselectedTitleTextStyle: const TextStyle(
                fontFamily: 'PopBold',
                fontSize: 15,
                color: color2
              ),
              selectedTitleTextStyle: const TextStyle(
                  color: Colors.white,
                fontFamily: 'PopRegular',
                fontSize: 15
              ),
              selectedIconColor: Colors.white,
              // backgroundColor: Colors.amber
              openSideMenuWidth: 200
            ),
            title: Column(
              children:  [
                const SizedBox(height: 15,),
                Card(
                  color: thirdcolor,
                  //elevation: 10.0,
                  child: Row(
                    children: [
                      Text(
                        (DateTime.now().day.toString().length == 1 ? "0" + DateTime.now().day.toString() : DateTime.now().day.toString()) + "/" + (DateTime.now().month.toString().length == 1 ? "0" + DateTime.now().month.toString() : DateTime.now().month.toString()) + "/" + DateTime.now().year.toString(),
                        style: const TextStyle(
                            fontFamily: 'PopBold',
                            fontSize: 16,
                            color: Colors.white
                        ),
                      ),
                      const Text("  -  "),
                      Text(
                        heure,
                        style: const TextStyle(
                          fontFamily: 'PopBold',
                          fontSize: 16,
                          color: Colors.white
                        ),
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
                const SizedBox(height: 10,),
                 Center(
                   child: Image.asset(
                     "assets/images/logo.png",
                     fit: BoxFit.contain,
                     height: 150,
                     width: 200,
                   ),
                   // child: Icon(Icons.person, color: color2, size: 80,),
                 ),
                const Text(
                    "Empereur Tech",
                  style: TextStyle(
                    fontFamily: 'PopBold',
                    fontSize: 16
                  ),
                ),
                const Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            footer: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'By Digital Security',
                style: TextStyle(
                    fontSize: 12,
                  fontFamily: 'PopBold'
                ),
              ),
            ),
            items: [
              SideMenuItem(
                priority: 0,
                title: 'Visiteurs',
                onTap: () {
                  page.jumpToPage(0);
                },
                icon: const Icon(Icons.download),
              ),
              SideMenuItem(
                priority: 1,
                title: 'Visites',
                onTap: () {
                  page.jumpToPage(1);
                },
                icon: const Icon(Icons.supervisor_account),
              ),
              // SideMenuItem(
              //   priority: 2,
              //   title: 'Etudiants',
              //   onTap: () {
              //     page.jumpToPage(2);
              //   },
              //   icon: const Icon(Icons.file_copy_rounded),
              // ),
              // SideMenuItem(
              //   priority: 3,
              //   title: 'Employées',
              //   onTap: () {
              //     page.jumpToPage(3);
              //   },
              //   icon: const Icon(Icons.download),
              // ),
              SideMenuItem(
                priority: 2,
                title: 'Trafic',
                onTap: () {
                  page.jumpToPage(2);
                },
                icon: const Icon(Icons.settings),
              ),
              SideMenuItem(
                priority: 3,
                title: 'Dashboard',
                onTap: () {
                  page.jumpToPage(3);
                },
                icon: const Icon(Icons.home),
                // badgeContent: const Text(
                //   '3',
                //   style: TextStyle(color: Colors.white),
                // ),
              ),
              SideMenuItem(
                priority: 4,
                title: 'Historique',
                onTap: () {
                  page.jumpToPage(4);
                },
                icon: const Icon(Icons.settings),
              ),
              SideMenuItem(
                priority: 6,
                title: 'Deconnexion',
                onTap: () async {
                  await securityApi.deleteToken();
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                },
                icon: const Icon(Icons.exit_to_app),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: const [
                VisitorPage(),
                VisitPage(),
                // StudentPage(),
                // EmployedPage(),
                TraficPage(),
                DashboardPage(),
                HistoriquePage()
              ],
            ),
          ),
        ],
      ),
    );
  }

  datetime(){
    Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        heure = (DateTime.now().hour.toString().length == 1 ? "0" + DateTime.now().hour.toString() : DateTime.now().hour.toString()) + " : " + (DateTime.now().minute.toString().length == 1 ? "0" + DateTime.now().minute.toString() : DateTime.now().minute.toString());
      });
    });
  }
}
