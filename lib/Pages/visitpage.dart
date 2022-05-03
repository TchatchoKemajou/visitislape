import 'dart:io';

import 'package:advance_notification/advance_notification.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';
import 'package:visitislape/Providers/visitprovider.dart';
import 'package:visitislape/Services/visitservice.dart';
import '../API/pdf_invoice_api.dart';
import '../constantes.dart';

class VisitPage extends StatefulWidget {
  const VisitPage({Key? key}) : super(key: key);

  @override
  _VisitPageState createState() => _VisitPageState();
}

class _VisitPageState extends State<VisitPage> {
  final searchController = TextEditingController();
  final nameController = TextEditingController();
  final cardController = TextEditingController();
  final phoneController = TextEditingController();
  final hostController = TextEditingController();
  final HDTRefreshController _hdtRefreshController = HDTRefreshController();
  List<dynamic> visitOfDays = [];
  List<dynamic> visitListSearch = [];
  List<dynamic> visitListFilter = [];

  static const int sortName = 0;
  static const int sortStatus = 1;
  bool isAscending = true;
  int sortType = sortName;
  bool isSearch = false;
  bool isFilter = false;
  String? statusValue;
  String? filterValue;
  String? optionValue;
  String? actionValue;

  List<String> filterOption = [
    'Filtre: aucun',
    'En cours',
    'Terminer',
    'Attendu'
  ];

  List<String> visitActions = [
    'Commencer',
    'Terminer',
  ];

  List<String> actions = [
    'Visite',
    'Attente',
    'Carte temporelle',
  ];
  // List<PlutoColumn> columns = [
  //   /// Text Column definition
  //   PlutoColumn(
  //     title: 'text column',
  //     field: 'text_field',
  //     type: PlutoColumnType.text(),
  //   ),
  //   /// Number Column definition
  //   PlutoColumn(
  //     title: 'number column',
  //     field: 'number_field',
  //     type: PlutoColumnType.number(),
  //   ),
  //   /// Select Column definition
  //   PlutoColumn(
  //     title: 'select column',
  //     field: 'select_field',
  //     type: PlutoColumnType.select(['item1', 'item2', 'item3']),
  //   ),
  //   /// Datetime Column definition
  //   PlutoColumn(
  //     title: 'date column',
  //     field: 'date_field',
  //     type: PlutoColumnType.date(),
  //   ),
  //   /// Time Column definition
  //   PlutoColumn(
  //     title: 'time column',
  //     field: 'time_field',
  //     type: PlutoColumnType.time(),
  //   ),
  // ];
  //
  // List<PlutoRow> rows = [
  //   PlutoRow(
  //     cells: {
  //       'text_field': PlutoCell(value: 'Text cell value1'),
  //       'number_field': PlutoCell(value: 2020),
  //       'select_field': PlutoCell(value: 'item1'),
  //       'date_field': PlutoCell(value: '2020-08-06'),
  //       'time_field': PlutoCell(value: '12:30'),
  //     },
  //   ),
  //   PlutoRow(
  //     cells: {
  //       'text_field': PlutoCell(value: 'Text cell value2'),
  //       'number_field': PlutoCell(value: 2021),
  //       'select_field': PlutoCell(value: 'item2'),
  //       'date_field': PlutoCell(value: '2020-08-07'),
  //       'time_field': PlutoCell(value: '18:45'),
  //     },
  //   ),
  //   PlutoRow(
  //     cells: {
  //       'text_field': PlutoCell(value: 'Text cell value3'),
  //       'number_field': PlutoCell(value: 2022),
  //       'select_field': PlutoCell(value: 'item3'),
  //       'date_field': PlutoCell(value: '2020-08-08'),
  //       'time_field': PlutoCell(value: '23:59'),
  //     },
  //   ),
  // ];
  @override
  void initState() {
    // TODO: implement initState
    //user.initData(100);
    super.initState();
   // getListVisitOfDay();
  }


  getListVisitOfDay() async{
    final visitprovider = Provider.of<VisitProvider>(context);
    final v = await visitprovider.findAllVisit();
    setState(() {
      visitOfDays = v;
    });
  }

  @override
  Widget build(BuildContext context) {
      getListVisitOfDay();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Liste de visites",
                    style: TextStyle(
                        fontFamily: 'PopBold',
                        color: Colors.black,
                      fontSize: 20
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async{
                          //if (!await launch("http://localhost:8080/api/v1/visite/downloadpdf")) throw 'Could not launch fgggf';
                          Map<String, dynamic> m = {
                            'number': DateTime.now().day.toString() + DateTime.now().second.toString() + DateTime.now().hour.toString() + "9999",
                            'date': (DateTime.now().day.toString().length == 1 ? "0" + DateTime.now().day.toString() : DateTime.now().day.toString()) + "/" + (DateTime.now().month.toString().length == 1 ? "0" + DateTime.now().month.toString() : DateTime.now().month.toString()) + "/" + DateTime.now().year.toString(),
                          };
                          String name = "fiche" + DateTime.now().day.toString() + DateTime.now().second.toString() + DateTime.now().hour.toString() + "9999";
                          final info = m;
                          final invoice = visitOfDays;
                          String pdfFile = await PdfInvoiceApi.generate(invoice, info, name);
                          if(pdfFile == "success"){
                            ElegantNotification.success(
                              description: const Text("Le fichier a été enregistré dans le dossier \"Document\""),
                              title: const Text("Success"),
                              notificationPosition: NOTIFICATION_POSITION.top,
                              width: MediaQuery.of(context).size.width * 0.2,
                            ).show(context);
                          }else{
                            ElegantNotification.error(
                              description: const Text("Nous avons rencontré un problème durant l'opération"),
                              title: const Text("erreur"),
                              notificationPosition: NOTIFICATION_POSITION.top,
                              width: MediaQuery.of(context).size.width * 0.2,
                            ).show(context);
                          }
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.print, color: Colors.white, size: 16,),
                            SizedBox(width: 2,),
                            Text(
                                "Exporter",
                              style: TextStyle(
                                fontFamily: 'PopBold',
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        style: ButtonStyle(
                          enableFeedback: false,
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
                          // ElegantNotification.success(
                          //     description: const Text("description"),
                          //   title: const Text("Success"),
                          //   notificationPosition: NOTIFICATION_POSITION.top,
                          //   width: MediaQuery.of(context).size.width * 0.2,
                          // ).show(context);
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
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              // decoration: const BoxDecoration(
              //   color: Colors.white,
              //   borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
              // ),
              child: HorizontalDataTable(
                leftHandSideColumnWidth: MediaQuery.of(context).size.width * 0.15,
                rightHandSideColumnWidth: MediaQuery.of(context).size.width * 0.75,
                isFixedHeader: true,
                headerWidgets: _getTitleWidget(),
                leftSideItemBuilder: _generateFirstColumnRow,
                rightSideItemBuilder: _generateRightHandSideColumnRow,
                itemCount: isSearch == false && isFilter == false ? visitOfDays.length : isSearch == true ? visitListSearch.length : isFilter == true ? visitListFilter.length : visitOfDays.length,
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
          ],
        ),
      ),
    );
  }

  searchFunction(String query){
    setState(() {
      isSearch = true;
      visitListSearch = visitOfDays.where((element) {
        return element['visitorId']['visitorFullName'].toLowerCase().contains(query.toLowerCase()) || element['visitHost'].toLowerCase().contains(query.toLowerCase()) || element['visitCarteTemp'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  filterFunction(filter){

      setState(() {
        filterValue = (filter as String);
      });

      if(filterValue == "Filtre: aucun"){
        setState(() {
          isSearch = false;
          isFilter = false;
        });
      }else{
        setState(() {
          isSearch = false;
          isFilter = true;
          print(filterValue);
          visitListFilter = visitOfDays.where((element) {
            return element['visitStatut'].toLowerCase().contains(filterValue!.toLowerCase());
          }).toList();
        });
      }
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Status', MediaQuery.of(context).size.width * 0.15),
      _getTitleItemWidget("Heure d'entrée", MediaQuery.of(context).size.width * 0.15),
      _getTitleItemWidget("Heure de sortie", MediaQuery.of(context).size.width * 0.15),
      _getTitleItemWidget('Visiteur', MediaQuery.of(context).size.width * 0.15),
      _getTitleItemWidget('Raison', MediaQuery.of(context).size.width * 0.15),
      _getTitleItemWidget('Gardien', MediaQuery.of(context).size.width * 0.15),
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
    final visitProvider = Provider.of<VisitProvider>(context, listen: false);
    final visit = isSearch == false && isFilter == false ? visitOfDays[index] : isSearch == true ? visitListSearch[index] : isFilter == true ? visitListFilter[index] : visitOfDays[index];
    return Container(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          hint: Row(
            children: [
              visit['visitStatut'] == "En cours"
                  ? const Icon(
                Icons.hourglass_bottom,
                size: 16,
                color: Colors.white,
              )
              : visit['visitStatut'] == "Terminer"
                  ? const Icon(
                Icons.exit_to_app,
                size: 16,
                color: Colors.white,
              )
              :const Icon(
                Icons.check_circle_outline,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  visit['visitStatut'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'PopBold'
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: visitActions
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
          value: statusValue,
          onChanged: (value) async{
            setState(() {
              actionValue = value as String;
            });
            if(actionValue == "Commencer"){
              if(visit['visitStatut'] == "Attendu"){
                visitProvider.changeVisitId = visit['visitId'];
                await visitProvider.startVisit();
                if(visitProvider.requestMessage == "success"){
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
                ElegantNotification.info(
                  description: const Text("Impossible de commencer une viste en cours"),
                  title: const Text("Infos"),
                  notificationPosition: NOTIFICATION_POSITION.top,
                  width: MediaQuery.of(context).size.width * 0.2,
                ).show(context);
              }
            }else{
              if(visit['visitStatut'] == "En cours"){
                visitProvider.changeVisitId = visit['visitId'];
                await visitProvider.endVisit();
                if(visitProvider.requestMessage == "success"){
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
                ElegantNotification.info(
                  description: const Text("Impossible de Terminer cette opration"),
                  title: const Text("Infos"),
                  notificationPosition: NOTIFICATION_POSITION.top,
                  width: MediaQuery.of(context).size.width * 0.2,
                ).show(context);
              }
            }
          },
          icon: Row(
            children:  [
              Container(
                height: 20,
                width: 2,
                color: Colors.white,
              ),
              const Icon(
                Icons.keyboard_arrow_down, color: Colors.white,
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
            color: visit['visitStatut'] == "En cours" ? color5 : visit['visitStatut'] == "Terminer" ? color7 : secondcolor,
          ),
          //buttonElevation: 2,
          itemHeight: 40,
          itemPadding: const EdgeInsets.only(left: 14, right: 14),
          dropdownMaxHeight: 120,
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
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    final visit = isSearch == false && isFilter == false ? visitOfDays[index] : isSearch == true ? visitListSearch[index] : isFilter == true ? visitListFilter[index] : visitOfDays[index];
    return Row(
      children: <Widget>[
        Container(
          child: Text(
            visit['visitTimeStar'] ?? "00-00-00",
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
            visit['visiTimeEnd'] ?? "00-00-00",
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
            visit['visitorId']['visitorFullName'] ?? "",
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
            visit['visitHost'] ?? "",
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
            visit['guardID']['guardFullName'] ?? "",
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
      ],
    );
  }
  titleMenu(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            searchWidget(),
            const SizedBox(width: 10,),
            filterWidget(),
            const SizedBox(width: 10,),
            //selectDateWidget()
          ],
        ),
        //newVisitWidget()
      ],
    );
  }
  filterWidget(){
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: const Text(
          'Filtre: aucun',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: secondcolor,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        items: filterOption
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
        value: filterValue,
        onChanged: filterFunction,
        icon: Row(
          children:  [
            Container(
              height: 20,
              width: 2,
              color: secondcolor,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                Icons.keyboard_arrow_down,
              ),
            ),
          ],
        ),
        iconSize: 16,
        iconEnabledColor: secondcolor,
        //iconDisabledColor: Colors.grey,
        buttonHeight: 30,
        buttonWidth: 160,
        buttonPadding: const EdgeInsets.only(left: 14, right: 14),
        buttonDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          // border: Border.all(
          //   color: Colors.black26,
          // ),
          color: color3,
        ),
        //buttonElevation: 2,
        itemHeight: 40,
        itemPadding: const EdgeInsets.only(left: 14, right: 14),
        dropdownMaxHeight: 180,
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
  addNewVisitorWidget(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  //onChanged: searchFunction,
                  controller: nameController,
                  maxLines: 1,
                  style: const TextStyle(
                      color: secondcolor
                  ),
                  decoration: const InputDecoration(
                    hoverColor: Colors.white,
                    hintText: 'Nom complet du visiteur',
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
                  //onChanged: searchFunction,
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
                  //onChanged: searchFunction,
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
                TextFormField(
                  keyboardType: TextInputType.text,
                  //onChanged: searchFunction,
                  controller: hostController,
                  maxLines: 1,
                  style: const TextStyle(
                      color: secondcolor
                  ),
                  decoration: const InputDecoration(
                    hoverColor: Colors.white,
                    hintText: 'Raison, Hôte, Description',
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
                const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () {
                    print(nameController.text);
                    SmartDialog.dismiss();
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
  selectDateWidget(){
    return Container(
      decoration: const BoxDecoration(
        color: color3,
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 7),
      height: 30,
      width: 200,
      child: DateTimePicker(
        type: DateTimePickerType.date,
        dateMask: 'd MMM, yyyy',
        initialValue: DateTime.now().toString(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefix: Icon(Icons.event, size: 15, color: secondcolor,),
          suffix: Icon(Icons.keyboard_arrow_down, size: 15, color: secondcolor,)
        ),
        style: const TextStyle(
          color: secondcolor,
          fontFamily: 'PopRegular',
          fontSize: 14
        ),
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.top,
        icon: const Icon(Icons.event, color: secondcolor,),
        selectableDayPredicate: (date) {
          // Disable weekend days to select from the calendar
          if (date.weekday == 6 || date.weekday == 7) {
            return false;
          }

          return true;
        },
        onChanged: (val) => print(val),
        validator: (val) {
          print(val);
          return null;
        },
        onSaved: (val) => print(val),
      ),
    );
  }
  // zfzefzfzef(){
  //   return Container(
  //     padding: const EdgeInsets.all(30),
  //     child: PlutoGrid(
  //         mode: PlutoGridMode.normal,
  //         configuration: const PlutoGridConfiguration(
  //             gridBorderColor: color1
  //         ),
  //         columns: columns,
  //         rows: rows,
  //         onChanged: (PlutoGridOnChangedEvent event) {
  //           print(event);
  //         },
  //         onLoaded: (PlutoGridOnLoadedEvent event) {
  //           print(event);
  //         }
  //     ),
  //   );
  // }
}

// User user = User();
//
// class User {
//   List<UserInfo> userInfo = [];
//
//   void initData(int size) {
//     for (int i = 0; i < size; i++) {
//       userInfo.add(UserInfo(
//           "User_$i", i % 3 == 0, '2019-01-01', 'scolarité', '2019-01-01', 'N/A'));
//     }
//   }
//
//   ///
//   /// Single sort, sort Name's id
//   void sortName(bool isAscending) {
//     userInfo.sort((a, b) {
//       int aId = int.tryParse(a.name.replaceFirst('User_', '')) ?? 0;
//       int bId = int.tryParse(b.name.replaceFirst('User_', '')) ?? 0;
//       return (aId - bId) * (isAscending ? 1 : -1);
//     });
//   }
//
//   ///
//   /// sort with Status and Name as the 2nd Sort
//   void sortStatus(bool isAscending) {
//     userInfo.sort((a, b) {
//       if (a.status == b.status) {
//         int aId = int.tryParse(a.name.replaceFirst('User_', '')) ?? 0;
//         int bId = int.tryParse(b.name.replaceFirst('User_', '')) ?? 0;
//         return (aId - bId);
//       } else if (a.status) {
//         return isAscending ? 1 : -1;
//       } else {
//         return isAscending ? -1 : 1;
//       }
//     });
//   }
// }
//
// class UserInfo {
//   String name;
//   bool status;
//   String phone;
//   String raison;
//   String registerDate;
//   String terminationDate;
//
//   UserInfo(this.name, this.status, this.phone, this.raison, this.registerDate,
//       this.terminationDate);
// }