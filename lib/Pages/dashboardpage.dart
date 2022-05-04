import 'dart:async';

import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visitislape/Pages/employepage.dart';
import 'package:visitislape/Pages/studentpage.dart';
import '../API/securityapi.dart';
import '../Providers/personprovider.dart';
import '../Providers/traficprovider.dart';
import '../Providers/visitorprovider.dart';
import '../constantes.dart';
import 'package:flutter_svg/flutter_svg.dart';
class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  SecurityApi securityApi = SecurityApi();
  int? visitorNumber;
  int? employeeNumber;
  int? studentNumber;
  int? traficNumber;

  getTotal() async{
    final visitorprovider = Provider.of<VisitorProvider>(context, listen: false);
    final personProvider = Provider.of<PersonProvider>(context, listen: false);
    final traficProvider = Provider.of<TraficProvider>(context, listen: false);
    final v = await visitorprovider.findAllVisitor();
    final site = await securityApi.getSite();
    final t = await traficProvider.findAllTrafic(site);
    final e = await personProvider.findAllEmployees();
    final s = await personProvider.findAllStudent();
    setState(() {
      visitorNumber = v.length;
      studentNumber = s.length;
      employeeNumber = e.length;
      traficNumber = t.length;
    });
    print(visitorNumber);
  }
  @override
  Widget build(BuildContext context) {
    getTotal();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Dashboard",
                        style: TextStyle(
                            fontFamily: 'PopBold',
                            color: Colors.black,
                            fontSize: 20
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     ElevatedButton(
                      //       onPressed: () {
                      //         SmartDialog.show(
                      //           isLoadingTemp: false,
                      //           alignmentTemp: Alignment.center,
                      //           maskColorTemp: Colors.transparent,
                      //           keepSingle: false,
                      //           widget: Container(),
                      //         );
                      //       },
                      //       child: Row(
                      //         children: const [
                      //           Icon(Icons.add, color: Colors.white, size: 16,),
                      //           SizedBox(width: 2,),
                      //           Text(
                      //             "Nouveau gardien",
                      //             style: TextStyle(
                      //               fontFamily: 'PopBold',
                      //               color: Colors.white,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       style: ButtonStyle(
                      //           backgroundColor: MaterialStateProperty.resolveWith((states) => secondcolor),
                      //           padding: MaterialStateProperty.all(const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5)),
                      //           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      //               RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(5.0),
                      //                 // side: BorderSide(color: Colors.red)
                      //               )
                      //           )
                      //       ),
                      //     ),
                      //     const SizedBox(width: 5,),
                      //     ElevatedButton(
                      //       onPressed: () {
                      //         //getAllVisitor();
                      //       },
                      //       child: const Icon(Icons.refresh, color: Colors.white, size: 16,),
                      //       style: ButtonStyle(
                      //           backgroundColor: MaterialStateProperty.resolveWith((states) => secondcolor),
                      //           padding: MaterialStateProperty.all(const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5)),
                      //           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      //               RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(5.0),
                      //                 // side: BorderSide(color: Colors.red)
                      //               )
                      //           )
                      //       ),
                      //     )
                      //   ],
                      // )
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, ),
                  child: dashMenu(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              //padding: const EdgeInsets.only(left: 15, right: 15),
              child: DefaultTabController(
                length: 3,
                child: SafeArea(
                  child: Stack(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: SegmentedTabControl(
                          radius: Radius.circular(25),
                          backgroundColor: Colors.white,
                          indicatorColor: thirdcolor,
                          tabTextColor: Colors.black,
                          textStyle: TextStyle(
                            fontFamily: 'PopBold'
                          ),
                          selectedTabTextColor: Colors.white,
                          squeezeIntensity: 2,
                          height: 30,
                          //textStyle: Theme.of(context).textTheme.bodyText1,
                          // Options for selection
                          // All specified values will override the [SegmentedTabControl] setting
                          tabs: [
                            SegmentTab(
                              label: 'Gérer les etudiants',
                            ),
                            SegmentTab(
                              label: 'Gérer le personnel',
                            ),
                            SegmentTab(label: 'Statistiques'),
                          ],
                        ),
                      ),
                      // Sample pages
                      Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: TabBarView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            StudentPage(),
                            EmployedPage(),
                            SampleWidget(
                              label: 'THIRD PAGE',
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  dashMenu(){
    // Timer.periodic(const Duration(seconds: 5), (timer){
    //   getTotal();
    // });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          height: 120,
          width: 250,
          child: Card(
            elevation: 10.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    trailing: CircleAvatar(
                      radius: 20,
                      backgroundColor: color9,
                      child: Center(
                        child: SvgPicture.asset("assets/icons/people.svg", height: 30, width: 30, color: Colors.deepPurple,),
                      ),
                    ),
                    title: const Text(
                      "Total visiteurs",
                      style: TextStyle(
                        fontFamily: 'PopRegular',
                        fontSize: 13,
                        color: Colors.grey
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 10),
                      child: Text(
                        visitorNumber != null ? visitorNumber.toString() : "0",
                        style: const TextStyle(
                          fontFamily: 'PopBold',
                          fontSize: 18,
                          color: Colors.black
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                          "assets/icons/trendingup.svg",
                        height: 20,
                        width: 30,
                        color: color5,
                      ),
                      const Text(
                          "85%",
                        style: TextStyle(
                            fontFamily: 'PopRegular',
                            fontSize: 14,
                            color: color5
                        ),
                      ),
                      const SizedBox(width: 5,),
                      const Text(
                        "d'évolution depuis hier",
                        style: TextStyle(
                            fontFamily: 'PopRegular',
                            fontSize: 13,
                            color: Colors.grey
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 120,
          width: 250,
          child: Card(
            elevation: 10.0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    trailing: CircleAvatar(
                      radius: 20,
                      backgroundColor: color9,
                      child: Center(
                        child: SvgPicture.asset("assets/icons/people.svg", height: 30, width: 30, color: Colors.deepPurple,),
                      ),
                    ),
                    title: const Text(
                      "Total étudiant",
                      style: TextStyle(
                          fontFamily: 'PopRegular',
                          fontSize: 13,
                          color: Colors.grey
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 10),
                      child: Text(
                        studentNumber != null ? studentNumber.toString() : "0",
                        style: const TextStyle(
                            fontFamily: 'PopBold',
                            fontSize: 18,
                            color: Colors.black
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/trendingup.svg",
                        height: 20,
                        width: 30,
                        color: color5,
                      ),
                      const Text(
                        "85%",
                        style: TextStyle(
                            fontFamily: 'PopRegular',
                            fontSize: 14,
                            color: color5
                        ),
                      ),
                      const SizedBox(width: 5,),
                      const Text(
                        "d'évolution depuis hier",
                        style: TextStyle(
                            fontFamily: 'PopRegular',
                            fontSize: 13,
                            color: Colors.grey
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 120,
          width: 250,
          child: Card(
            elevation: 10.0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    trailing: CircleAvatar(
                      radius: 20,
                      backgroundColor: color9,
                      child: Center(
                        child: SvgPicture.asset("assets/icons/people.svg", height: 30, width: 30, color: Colors.deepPurple,),
                      ),
                    ),
                    title: const Text(
                      "Total employée",
                      style: TextStyle(
                          fontFamily: 'PopRegular',
                          fontSize: 13,
                          color: Colors.grey
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 10),
                      child: Text(
                        employeeNumber != null ? employeeNumber.toString() : "0",
                        style: const TextStyle(
                            fontFamily: 'PopBold',
                            fontSize: 18,
                            color: Colors.black
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/trendingup.svg",
                        height: 20,
                        width: 30,
                        color: color5,
                      ),
                      const Text(
                        "85%",
                        style: TextStyle(
                            fontFamily: 'PopRegular',
                            fontSize: 14,
                            color: color5
                        ),
                      ),
                      const SizedBox(width: 5,),
                      const Text(
                        "d'évolution depuis hier",
                        style: TextStyle(
                            fontFamily: 'PopRegular',
                            fontSize: 13,
                            color: Colors.grey
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 120,
          width: 250,
          child: Card(
            elevation: 10.0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    trailing: CircleAvatar(
                      radius: 20,
                      backgroundColor: color9,
                      child: Center(
                        child: SvgPicture.asset("assets/icons/people.svg", height: 30, width: 30, color: Colors.deepPurple,),
                      ),
                    ),
                    title: const Text(
                      "Total trafic",
                      style: TextStyle(
                          fontFamily: 'PopRegular',
                          fontSize: 13,
                          color: Colors.grey
                      ),
                    ),
                    subtitle:  Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 10),
                      child: Text(
                        traficNumber != null ? traficNumber.toString() : "0",
                        style: const TextStyle(
                            fontFamily: 'PopBold',
                            fontSize: 18,
                            color: Colors.black
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/trendingup.svg",
                        height: 20,
                        width: 30,
                        color: color5,
                      ),
                      const Text(
                        "85%",
                        style: TextStyle(
                            fontFamily: 'PopRegular',
                            fontSize: 14,
                            color: color5
                        ),
                      ),
                      const SizedBox(width: 5,),
                      const Text(
                        "d'évolution depuis hier",
                        style: TextStyle(
                            fontFamily: 'PopRegular',
                            fontSize: 13,
                            color: Colors.grey
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SampleWidget extends StatelessWidget {
  const SampleWidget({
    Key? key,
    required this.label,
    required this.color,
  }) : super(key: key);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10))),
      child: Text(label),
    );
  }
}
