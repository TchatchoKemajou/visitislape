import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:provider/provider.dart';
import 'package:visitislape/API/securityapi.dart';
import 'package:visitislape/Providers/visitorprovider.dart';
import 'package:visitislape/Providers/visitprovider.dart';
import '../constantes.dart';

class VisitorPage extends StatefulWidget {
  const VisitorPage({Key? key}) : super(key: key);

  @override
  _VisitorPageState createState() => _VisitorPageState();
}

class _VisitorPageState extends State<VisitorPage> {
  SecurityApi securityApi = SecurityApi();
  final key = GlobalKey<FormState>();
  final key2 = GlobalKey<FormState>();
  final key3 = GlobalKey<FormState>();
  final searchController = TextEditingController();
  final nameController = TextEditingController();
  final prenomController = TextEditingController();
  final cardController = TextEditingController();
  final phoneController = TextEditingController();
  final hostController = TextEditingController();
  List<dynamic> visitorList = [];
  List<dynamic> visitorListSearch = [];
  final HDTRefreshController _hdtRefreshController = HDTRefreshController();

  bool isSearch = false;
  String? optionValue;
  String? chooseValue;

  List<String> actions = [
    'Visite',
    'Attente',
    'Carte temporelle',
  ];

  getAllVisitor() async{
    final visitorprovider = Provider.of<VisitorProvider>(context);
    final v = await visitorprovider.findAllVisitor();
    setState(() {
      visitorList = v;
    });
  }
  @override
  Widget build(BuildContext context) {
    getAllVisitor();
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Liste des visiteurs",
                  style: TextStyle(
                      fontFamily: 'PopBold',
                      color: Colors.black,
                      fontSize: 20
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        SmartDialog.show(
                          isLoadingTemp: false,
                          alignmentTemp: Alignment.center,
                          maskColorTemp: Colors.transparent,
                          keepSingle: false,
                          widget: addNewVisitorWidget(),
                        );
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.add, color: Colors.white, size: 16,),
                          SizedBox(width: 2,),
                          Text(
                            "Nouveau visiteur",
                            style: TextStyle(
                              fontFamily: 'PopBold',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith((states) => secondcolor),
                          padding: MaterialStateProperty.all(const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                // side: BorderSide(color: Colors.red)
                              )
                          )
                      ),
                    ),
                    const SizedBox(width: 5,),
                    ElevatedButton(
                      onPressed: () async{
                       await getAllVisitor();
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.refresh, color: Colors.white, size: 16,),
                        ],
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith((states) => secondcolor),
                          padding: MaterialStateProperty.all(const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                // side: BorderSide(color: Colors.red)
                              )
                          )
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
            child: titleMenu(),
          ),
          const SizedBox(height: 20,),
          Expanded(
            child: Container(
             // height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: HorizontalDataTable(
                leftHandSideColumnWidth: MediaQuery.of(context).size.width * 0.15,
                rightHandSideColumnWidth: MediaQuery.of(context).size.width * 0.75,
                isFixedHeader: true,
                headerWidgets: _getTitleWidget(),
                leftSideItemBuilder: _generateFirstColumnRow,
                rightSideItemBuilder: _generateRightHandSideColumnRow,
                itemCount: isSearch == true ? visitorListSearch.length : visitorList.length,
                rowSeparatorWidget: const Divider(
                  color: Colors.black54,
                  height: 1.0,
                  thickness: 0.0,
                ),
                leftHandSideColBackgroundColor: Colors.white,
                rightHandSideColBackgroundColor: Colors.white,
                verticalScrollbarStyle: const ScrollbarStyle(
                  thumbColor: Colors.yellow,
                  isAlwaysShown: true,
                  thickness: 4.0,
                  radius: Radius.circular(5.0),
                ),
                horizontalScrollbarStyle: const ScrollbarStyle(
                  thumbColor: Colors.red,
                  isAlwaysShown: true,
                  thickness: 4.0,
                  radius: Radius.circular(5.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Code', MediaQuery.of(context).size.width * 0.15),
      _getTitleItemWidget("Nom", MediaQuery.of(context).size.width * 0.15),
      _getTitleItemWidget("Prénom", MediaQuery.of(context).size.width * 0.15),
      _getTitleItemWidget("Carte d'identité", MediaQuery.of(context).size.width * 0.15),
      _getTitleItemWidget('Numéro de téléphone', MediaQuery.of(context).size.width * 0.15),
      _getTitleItemWidget('Actions', MediaQuery.of(context).size.width * 0.10),
    ];
  }
  Widget _getTitleItemWidget(String label, w) {
    return Container(
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'PopBold', fontSize: 15)),
      width: w,
      height: 56,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }
  Widget _generateFirstColumnRow(BuildContext context, int index) {
    final visitor = isSearch == true ? visitorListSearch[index] : visitorList[index];
    return Container(
      child: Text(
        visitor['visitorID'] != null ? "Islape00" + visitor['visitorID'].toString() : "",
        style: const TextStyle(
          fontFamily: 'PopBold',
          color: Colors.redAccent,
        ),
      ),
      width: MediaQuery.of(context).size.width * 0.15,
      height: 52,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }
  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    final visitProvider = Provider.of<VisitProvider>(context, listen: false);
    final visitor = isSearch == true ? visitorListSearch[index] : visitorList[index];
    return Row(
      children: <Widget>[
        Container(
          child: Text(
            visitorList[index]['visitorFullName'] ?? "",
            style: const TextStyle(
              fontFamily: 'PopRegular',
              color: color2,
            ),
          ),
          width: MediaQuery.of(context).size.width * 0.15,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
            visitor['vistorLastName'] != "" ? visitor['vistorLastName'] : "Aucun",
            style: const TextStyle(
              fontFamily: 'PopRegular',
              color: color2,
            ),
          ),
          width: MediaQuery.of(context).size.width * 0.15,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
            visitor['visitorCardId'] ?? "",
            style: const TextStyle(
              fontFamily: 'PopRegular',
              color: color2,
            ),
          ),
          width: MediaQuery.of(context).size.width * 0.15,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text(
            visitor['visitorNumber'] ?? "",
            style: const TextStyle(
              fontFamily: 'PopRegular',
              color: color2,
            ),
          ),
          width: MediaQuery.of(context).size.width * 0.15,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: Row(
                children: const [
                  Icon(
                    Icons.add,
                    size: 16,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Text(
                      'Nouvelle',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              items: actions
                  .map((item) =>
                  DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PopRegular',
                        color: secondcolor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
                  .toList(),
              value: optionValue,
              onChanged: (value) async{
                setState(() {
                  chooseValue = value as String;
                });
                if(chooseValue == "Visite"){
                  SmartDialog.show(
                    isLoadingTemp: false,
                    alignmentTemp: Alignment.center,
                    maskColorTemp: Colors.transparent,
                    keepSingle: false,
                    widget: addNewVisitWidget(visitor['visitorID']),
                  );
                }else if(chooseValue == "Attente"){
                  visitProvider.changeVisitorId = visitor['visitorID'];
                  visitProvider.changeGuardId = securityApi.getGuard();
                  visitProvider.changeSiteId = securityApi.getSite();
                  await visitProvider.saveAttente();
                  if(visitProvider.requestMessage == "success"){
                    SmartDialog.dismiss();
                    ElegantNotification.success(
                      description: const Text("Visiteur enregistré avec succès"),
                      title: const Text("Success"),
                      notificationPosition: NOTIFICATION_POSITION.top,
                      width: MediaQuery.of(context).size.width * 0.2,
                    ).show(context);
                  }else{
                    SmartDialog.dismiss();
                    ElegantNotification.error(
                      description: const Text("un problème s'est produit durant l'enregistrement du visiteur"),
                      title: const Text("échec"),
                      notificationPosition: NOTIFICATION_POSITION.top,
                      width: MediaQuery.of(context).size.width * 0.2,
                    ).show(context);
                  }
                }else{
                  SmartDialog.show(
                    isLoadingTemp: false,
                    alignmentTemp: Alignment.center,
                    maskColorTemp: Colors.transparent,
                    keepSingle: false,
                    widget: addNewTemporalCard(visitor['visitorID']),
                  );
                }
              },
              icon: Row(
                children:  [
                  Container(
                    height: 20,
                    width: 2,
                    color: Colors.white,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.keyboard_arrow_down, color: Colors.white,
                    ),
                  ),
                ],
              ),
              iconSize: 16,
              iconEnabledColor: Colors.white,
              //iconDisabledColor: Colors.grey,
              buttonHeight: 30,
              buttonWidth: 160,
              buttonPadding: const EdgeInsets.only(left: 14, right: 14),
              buttonDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                // border: Border.all(
                //   color: Colors.black26,
                // ),
                color: secondcolor,
              ),
              //buttonElevation: 2,
              itemHeight: 40,
              itemPadding: const EdgeInsets.only(left: 14, right: 14),
              dropdownMaxHeight: 140,
              dropdownWidth: 150,
              dropdownPadding: null,
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
              ),
              dropdownElevation: 8,
              scrollbarRadius: const Radius.circular(40),
              scrollbarThickness: 6,
              scrollbarAlwaysShow: true,
              offset: const Offset(-20, 0),
            ),
          ),
          width: MediaQuery.of(context).size.width * 0.15,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
  addNewVisitWidget(visitorId){
    final visitProvider = Provider.of<VisitProvider>(context, listen: false);
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            color: secondcolor,
            width: double.infinity,
            height: 50,
            child: const Center(
              child: Text(
                "Commencer une visite",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PopBold',
                    fontSize: 15
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: Form(
              key: key2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    validator: (e) => e!.isEmpty ? " ce champ est obligatoire":null,
                    onChanged: (e){
                      visitProvider.changeVisitHost = e;
                    },
                    //controller: nameController,
                    maxLines: 1,
                    style: const TextStyle(
                        color: secondcolor
                    ),
                    decoration: const InputDecoration(
                      hoverColor: Colors.white,
                      hintText: 'Hête du visiteur',
                      hintStyle: TextStyle(
                          color: secondcolor,
                          fontFamily: 'PopRegular',
                          fontSize: 12
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: secondcolor
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: color2
                          )
                      ),
                      isDense: true,                      // Added this
                      contentPadding: EdgeInsets.all(10),
                      //hintText: "login",
                      prefixIcon: Icon(Icons.home, color: color4,),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: color2
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    onChanged: (e){
                      visitProvider.changeVisitDescription = e;
                    },
                    //controller: prenomController,
                    maxLines: 1,
                    style: const TextStyle(
                        color: secondcolor
                    ),
                    decoration: const InputDecoration(
                      hoverColor: Colors.white,
                      hintText: 'Description',
                      hintStyle: TextStyle(
                          color: secondcolor,
                          fontFamily: 'PopRegular',
                          fontSize: 12
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: secondcolor
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: color2
                          )
                      ),
                      isDense: true,                      // Added this
                      contentPadding: EdgeInsets.all(10),
                      //hintText: "login",
                      prefixIcon: Icon(Icons.edit_road, color: color4,),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: color2
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: () async{
                      if(key2.currentState!.validate()){
                        visitProvider.changeVisitorId = visitorId;
                        visitProvider.changeGuardId = await securityApi.getGuard();
                        visitProvider.changeSiteId = await securityApi.getSite();
                        await visitProvider.saveVisit();
                        if(visitProvider.requestMessage == "success"){
                          SmartDialog.dismiss();
                          ElegantNotification.success(
                            description: const Text("Visite enregistré avec succès"),
                            title: const Text("Success"),
                            notificationPosition: NOTIFICATION_POSITION.top,
                            width: MediaQuery.of(context).size.width * 0.2,
                          ).show(context);
                        }else if(visitProvider.requestMessage == "impossible"){
                          SmartDialog.dismiss();
                          ElegantNotification.info(
                            description: const Text("Il existe déjà une visite en cours à ce nom"),
                            title: const Text("Attention"),
                            notificationPosition: NOTIFICATION_POSITION.top,
                            width: MediaQuery.of(context).size.width * 0.2,
                          ).show(context);
                        } else{
                          SmartDialog.dismiss();
                          ElegantNotification.error(
                            description: const Text("un problème s'est produit durant l'enregistrement du visiteur"),
                            title: const Text("échec"),
                            notificationPosition: NOTIFICATION_POSITION.top,
                            width: MediaQuery.of(context).size.width * 0.2,
                          ).show(context);
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add, color: Colors.white, size: 16,),
                        SizedBox(width: 2,),
                        Text(
                          "Commencer",
                          style: TextStyle(
                            fontFamily: 'PopBold',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) => secondcolor),
                        padding: MaterialStateProperty.all(const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              // side: BorderSide(color: Colors.red)
                            )
                        )
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  addNewTemporalCard(visitorId){
    final visitProvider = Provider.of<VisitProvider>(context, listen: false);
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            color: secondcolor,
            width: double.infinity,
            height: 50,
            child: const Center(
              child: Text(
                "Créer un badge temporaire",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PopBold',
                    fontSize: 15
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: Form(
              key: key3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    validator: (e) => e!.isEmpty ? " ce champ est obligatoire":null,
                    onChanged: (e){
                      visitProvider.changeVisitTempCard = e;
                    },
                    //controller: nameController,
                    maxLines: 1,
                    style: const TextStyle(
                        color: secondcolor
                    ),
                    decoration: const InputDecoration(
                      hoverColor: Colors.white,
                      hintText: 'Numéro de la carte',
                      hintStyle: TextStyle(
                          color: secondcolor,
                          fontFamily: 'PopRegular',
                          fontSize: 12
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: secondcolor
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: color2
                          )
                      ),
                      isDense: true,                      // Added this
                      contentPadding: EdgeInsets.all(10),
                      //hintText: "login",
                      prefixIcon: Icon(Icons.home, color: color4,),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: color2
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    validator: (e) => e!.isEmpty ? " ce champ est obligatoire":null,
                    onChanged: (e){
                      visitProvider.changeVisitHost = e;
                    },
                    //controller: nameController,
                    maxLines: 1,
                    style: const TextStyle(
                        color: secondcolor
                    ),
                    decoration: const InputDecoration(
                      hoverColor: Colors.white,
                      hintText: 'Hête du visiteur',
                      hintStyle: TextStyle(
                          color: secondcolor,
                          fontFamily: 'PopRegular',
                          fontSize: 12
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: secondcolor
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: color2
                          )
                      ),
                      isDense: true,                      // Added this
                      contentPadding: EdgeInsets.all(10),
                      //hintText: "login",
                      prefixIcon: Icon(Icons.home, color: color4,),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: color2
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    onChanged: (e){
                      visitProvider.changeVisitDescription = e;
                    },
                    //controller: prenomController,
                    maxLines: 1,
                    style: const TextStyle(
                        color: secondcolor
                    ),
                    decoration: const InputDecoration(
                      hoverColor: Colors.white,
                      hintText: 'Description',
                      hintStyle: TextStyle(
                          color: secondcolor,
                          fontFamily: 'PopRegular',
                          fontSize: 12
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: secondcolor
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: color2
                          )
                      ),
                      isDense: true,                      // Added this
                      contentPadding: EdgeInsets.all(10),
                      //hintText: "login",
                      prefixIcon: Icon(Icons.edit_road, color: color4,),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: color2
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: () async{
                      if(key3.currentState!.validate()){
                        visitProvider.changeVisitorId = visitorId;
                        visitProvider.changeGuardId = securityApi.getGuard();
                        visitProvider.changeSiteId = securityApi.getSite();
                        await visitProvider.saveVisit();
                        if(visitProvider.requestMessage == "success"){
                          SmartDialog.dismiss();
                          ElegantNotification.success(
                            description: const Text("Visiteur enregistré avec succès"),
                            title: const Text("Success"),
                            notificationPosition: NOTIFICATION_POSITION.top,
                            width: MediaQuery.of(context).size.width * 0.2,
                          ).show(context);
                        }else if(visitProvider.requestMessage == "impossible"){
                          SmartDialog.dismiss();
                          ElegantNotification.info(
                            description: const Text("Il existe déjà une visite en cours à ce nom"),
                            title: const Text("Attention"),
                            notificationPosition: NOTIFICATION_POSITION.top,
                            width: MediaQuery.of(context).size.width * 0.2,
                          ).show(context);
                        }else{
                          SmartDialog.dismiss();
                          ElegantNotification.error(
                            description: const Text("un problème s'est produit durant l'enregistrement du visiteur"),
                            title: const Text("échec"),
                            notificationPosition: NOTIFICATION_POSITION.top,
                            width: MediaQuery.of(context).size.width * 0.2,
                          ).show(context);
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add, color: Colors.white, size: 16,),
                        SizedBox(width: 2,),
                        Text(
                          "Commencer",
                          style: TextStyle(
                            fontFamily: 'PopBold',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) => secondcolor),
                        padding: MaterialStateProperty.all(const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              // side: BorderSide(color: Colors.red)
                            )
                        )
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  newVisitWidget(){
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Row(
          children: const [
            Icon(
              Icons.add,
              size: 16,
              color: Colors.white,
            ),
            SizedBox(
              width: 4,
            ),
            Expanded(
              child: Text(
                'Nouvelle',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: actions
            .map((item) =>
            DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PopRegular',
                  color: secondcolor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ))
            .toList(),
        value: optionValue,
        onChanged: (value) {
          setState(() {
            optionValue = value as String;
          });
        },
        icon: Row(
          children:  [
            Container(
              height: 20,
              width: 2,
              color: Colors.white,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                Icons.keyboard_arrow_down, color: Colors.white,
              ),
            ),
          ],
        ),
        iconSize: 16,
        iconEnabledColor: Colors.white,
        //iconDisabledColor: Colors.grey,
        buttonHeight: 30,
        buttonWidth: 160,
        buttonPadding: const EdgeInsets.only(left: 14, right: 14),
        buttonDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          // border: Border.all(
          //   color: Colors.black26,
          // ),
          color: secondcolor,
        ),
        //buttonElevation: 2,
        itemHeight: 40,
        itemPadding: const EdgeInsets.only(left: 14, right: 14),
        dropdownMaxHeight: 140,
        dropdownWidth: 150,
        dropdownPadding: null,
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
        ),
        dropdownElevation: 8,
        scrollbarRadius: const Radius.circular(40),
        scrollbarThickness: 6,
        scrollbarAlwaysShow: true,
        offset: const Offset(-20, 0),
      ),
    );
  }
  searchFunction(String query){
    setState(() {
      if(query == ""){
        isSearch = false;
      }else{
        isSearch = true;
      }
    });
    setState(() {
      visitorListSearch = visitorList.where((element) {
        return element['visitorFullName'].toLowerCase().contains(query.toLowerCase()) || element['vistorLastName'].toLowerCase().contains(query.toLowerCase()) || element['visitorCardId'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }
  titleMenu(){
    return Row(
      children: [
        searchWidget(),
        const SizedBox(width: 10,),
      ],
    );
  }
  addNewVisitorWidget(){
    final visitorProvider = Provider.of<VisitorProvider>(context, listen: false);
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width * 0.2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            color: secondcolor,
            width: double.infinity,
            height: 50,
            child: const Center(
              child: Text(
                "Ajouter un visiteur",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PopBold',
                    fontSize: 15
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: Form(
              key: key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    validator: (e) => e!.isEmpty ? " ce champ est obligatoire":null,
                    onChanged: (e){
                      visitorProvider.changeVisitorFullName = e;
                    },
                    controller: nameController,
                    maxLines: 1,
                    style: const TextStyle(
                        color: secondcolor
                    ),
                    decoration: const InputDecoration(
                      hoverColor: Colors.white,
                      hintText: 'Nom du visiteur',
                      hintStyle: TextStyle(
                          color: secondcolor,
                          fontFamily: 'PopRegular',
                          fontSize: 12
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: secondcolor
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: color2
                          )
                      ),
                      isDense: true,                      // Added this
                      contentPadding: EdgeInsets.all(10),
                      //hintText: "login",
                      prefixIcon: Icon(Icons.person, color: color4,),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: color2
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    onChanged: (e){
                      visitorProvider.changeVisitorLastName = e;
                    },
                    controller: prenomController,
                    maxLines: 1,
                    style: const TextStyle(
                        color: secondcolor
                    ),
                    decoration: const InputDecoration(
                      hoverColor: Colors.white,
                      hintText: 'Prenom',
                      hintStyle: TextStyle(
                          color: secondcolor,
                          fontFamily: 'PopRegular',
                          fontSize: 12
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: secondcolor
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: color2
                          )
                      ),
                      isDense: true,                      // Added this
                      contentPadding: EdgeInsets.all(10),
                      //hintText: "login",
                      prefixIcon: Icon(Icons.person, color: color4,),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: color2
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    validator: (e) => e!.isEmpty ? " ce champ est obligatoire":null,
                    onChanged: (e){
                      visitorProvider.changeVisitorCardId = e;
                    },
                    controller: cardController,
                    maxLines: 1,
                    style: const TextStyle(
                        color: secondcolor
                    ),
                    decoration: const InputDecoration(
                      hoverColor: Colors.white,
                      hintText: "N Carte d'identité",
                      hintStyle: TextStyle(
                          color: secondcolor,
                          fontFamily: 'PopRegular',
                          fontSize: 12
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: secondcolor
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: color2
                          )
                      ),
                      isDense: true,                      // Added this
                      contentPadding: EdgeInsets.all(10),
                      //hintText: "login",
                      prefixIcon: Icon(Icons.person, color: color4,),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: color2
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    validator: (e) => e!.isEmpty ? " ce champ est obligatoire":null,
                    onChanged: (e){
                      visitorProvider.changeVisitorNumber = e;
                    },
                    controller: phoneController,
                    maxLines: 1,
                    style: const TextStyle(
                        color: secondcolor
                    ),
                    decoration: const InputDecoration(
                      hoverColor: Colors.white,
                      hintText: 'N de téléphone',
                      hintStyle: TextStyle(
                          color: secondcolor,
                          fontFamily: 'PopRegular',
                          fontSize: 12
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: secondcolor
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: color2
                          )
                      ),
                      isDense: true,                      // Added this
                      contentPadding: EdgeInsets.all(10),
                      //hintText: "login",
                      prefixIcon: Icon(Icons.person, color: color4,),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: color2
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  // TextFormField(
                  //   keyboardType: TextInputType.text,
                  //   //onChanged: searchFunction,
                  //   controller: hostController,
                  //   maxLines: 1,
                  //   style: const TextStyle(
                  //       color: secondcolor
                  //   ),
                  //   decoration: const InputDecoration(
                  //     hoverColor: Colors.white,
                  //     hintText: 'Raison, Hôte, Description',
                  //     hintStyle: TextStyle(
                  //         color: secondcolor,
                  //         fontFamily: 'PopRegular',
                  //         fontSize: 12
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(5)),
                  //         borderSide: BorderSide(
                  //             color: secondcolor
                  //         )
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(5)),
                  //         borderSide: BorderSide(
                  //             color: color2
                  //         )
                  //     ),
                  //     isDense: true,                      // Added this
                  //     contentPadding: EdgeInsets.all(10),
                  //     //hintText: "login",
                  //     prefixIcon: Icon(Icons.person, color: color4,),
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(5)),
                  //         borderSide: BorderSide(
                  //             color: color2
                  //         )
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: () async{
                      if(key.currentState!.validate()){
                        await visitorProvider.saveVisitor();
                        if(visitorProvider.requestMessage == "success"){
                          SmartDialog.dismiss();
                          ElegantNotification.success(
                            description: const Text("Visiteur enregistré avec succès"),
                            title: const Text("Success"),
                            notificationPosition: NOTIFICATION_POSITION.top,
                            width: MediaQuery.of(context).size.width * 0.2,
                          ).show(context);
                        }else{
                          SmartDialog.dismiss();
                          ElegantNotification.error(
                            description: const Text("un problème s'est produit durant l'enregistrement du visiteur"),
                            title: const Text("échec"),
                            notificationPosition: NOTIFICATION_POSITION.top,
                            width: MediaQuery.of(context).size.width * 0.2,
                          ).show(context);
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add, color: Colors.white, size: 16,),
                        SizedBox(width: 2,),
                        Text(
                          "Enregitrer",
                          style: TextStyle(
                            fontFamily: 'PopBold',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) => secondcolor),
                        padding: MaterialStateProperty.all(const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              // side: BorderSide(color: Colors.red)
                            )
                        )
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  searchWidget(){
    return Container(
      decoration: const BoxDecoration(
        color: color3,
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      //padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 20),
      height: 30,
      width: 300,
      child: TextFormField(
        keyboardType: TextInputType.text,
        onChanged: searchFunction,
        controller: searchController,
        maxLines: 1,
        style: const TextStyle(
            color: secondcolor
        ),
        decoration: InputDecoration(
          hoverColor: Colors.white,
          suffixIcon: isSearch == true
              ? InkWell(
            child: const Icon(Icons.close, color: secondcolor,),
            onTap: (){
            },
          )
              : const SizedBox(),
          hintText: 'Rechercher par: visite, visiteur',
          hintStyle: const TextStyle(
              color: secondcolor,
              fontFamily: 'PopRegular',
              fontSize: 12
          ),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide(
                  color: secondcolor
              )
          ),
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide(
                  color: Colors.white
              )
          ),
          isDense: true,                      // Added this
          contentPadding: const EdgeInsets.all(10),
          //hintText: "login",
          prefixIcon: const Icon(Icons.search, color: color4,),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
        ),
      ),
    );
  }
}
