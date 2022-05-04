import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:visitislape/Pages/trafichistory.dart';
import 'package:visitislape/Pages/visithistory.dart';

import '../constantes.dart';


class HistoriquePage extends StatefulWidget {
  const HistoriquePage({Key? key}) : super(key: key);

  @override
  _HistoriquePageState createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .0,
        title: const Text(
          "Historique",
          style: TextStyle(
              fontFamily: 'PopBold',
              color: Colors.black,
              fontSize: 20
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: DefaultTabController(
          length: 2,
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
                        label: 'Historique des visites',
                      ),
                      SegmentTab(
                        label: 'Historique du trafic',
                      ),
                    ],
                  ),
                ),
                // Sample pages
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: TabBarView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      VisitHistory(),
                      TraficHistory(),
                    ],
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

