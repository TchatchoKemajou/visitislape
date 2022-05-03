// import 'package:flutter/material.dart';
// import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
//
// import '../constantes.dart';
//
// class GuardPage extends StatefulWidget {
//   const GuardPage({Key? key}) : super(key: key);
//
//   @override
//   _GuardPageState createState() => _GuardPageState();
// }
//
// class _GuardPageState extends State<GuardPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 titleMenu(),
//                 // const Text(
//                 //   "Liste des etudiants",
//                 //   style: TextStyle(
//                 //       fontFamily: 'PopBold',
//                 //       color: Colors.black,
//                 //       fontSize: 20
//                 //   ),
//                 // ),
//                 Row(
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         SmartDialog.show(
//                           isLoadingTemp: false,
//                           alignmentTemp: Alignment.center,
//                           maskColorTemp: Colors.transparent,
//                           keepSingle: false,
//                           widget: addNewVisitorWidget(),
//                         );
//                       },
//                       child: Row(
//                         children: const [
//                           Icon(Icons.add, color: Colors.white, size: 16,),
//                           SizedBox(width: 2,),
//                           Text(
//                             "Nouvel étudiant",
//                             style: TextStyle(
//                               fontFamily: 'PopBold',
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                       style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.resolveWith((states) => secondcolor),
//                           padding: MaterialStateProperty.all(const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5)),
//                           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                               RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(5.0),
//                                 // side: BorderSide(color: Colors.red)
//                               )
//                           )
//                       ),
//                     ),
//                     const SizedBox(width: 5,),
//                     ElevatedButton(
//                       onPressed: () {
//                         //getAllVisitor();
//                       },
//                       child: const Icon(Icons.refresh, color: Colors.white, size: 16,),
//                       style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.resolveWith((states) => secondcolor),
//                           padding: MaterialStateProperty.all(const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5)),
//                           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                               RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(5.0),
//                                 // side: BorderSide(color: Colors.red)
//                               )
//                           )
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//   List<Widget> _getTitleWidget() {
//     return [
//       _getTitleItemWidget("Matricule", MediaQuery.of(context).size.width * 0.15),
//       _getTitleItemWidget("Nom", MediaQuery.of(context).size.width * 0.15),
//       _getTitleItemWidget('Spcialité', MediaQuery.of(context).size.width * 0.15),
//       _getTitleItemWidget("Niveau", MediaQuery.of(context).size.width * 0.15),
//       _getTitleItemWidget('Actions', MediaQuery.of(context).size.width * 0.05),
//     ];
//   }
//   Widget _getTitleItemWidget(String label, w) {
//     return Container(
//       child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'PopBold', fontSize: 15)),
//       width: w,
//       height: 56,
//       padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
//       alignment: Alignment.centerLeft,
//     );
//   }
//   Widget _generateFirstColumnRow(BuildContext context, int index) {
//     final student = isSearch == true ? studentListSearch[index] : studentList[index];
//     return Container(
//       child: Text(
//         student['etuMatricule'] != null ? student['etuMatricule'].toString() : "",
//         style: const TextStyle(
//           fontFamily: 'PopBold',
//           color: thirdcolor,
//         ),
//       ),
//       width: MediaQuery.of(context).size.width * 0.15,
//       height: 52,
//       padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
//       alignment: Alignment.centerLeft,
//     );
//   }
//   Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
//     final student = isSearch == true ? studentListSearch[index] : studentList[index];
//     return Row(
//       children: <Widget>[
//         Container(
//           child: Text(
//             student['etuFullName'] ?? "",
//             style: const TextStyle(
//               fontFamily: 'PopRegular',
//               color: color2,
//             ),
//           ),
//           width: MediaQuery.of(context).size.width * 0.15,
//           height: 52,
//           padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
//           alignment: Alignment.centerLeft,
//         ),
//         Container(
//           child: Text(
//             student['specialite'] ?? "Aucun",
//             style: const TextStyle(
//               fontFamily: 'PopRegular',
//               color: color2,
//             ),
//           ),
//           width: MediaQuery.of(context).size.width * 0.15,
//           height: 52,
//           padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
//           alignment: Alignment.centerLeft,
//         ),
//         Container(
//           child: Text(
//             student['niveau'] ?? "Aucun",
//             style: const TextStyle(
//               fontFamily: 'PopRegular',
//               color: color2,
//             ),
//           ),
//           width: MediaQuery.of(context).size.width * 0.15,
//           height: 52,
//           padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
//           alignment: Alignment.centerLeft,
//         ),
//         Container(
//           child: ElevatedButton(
//             onPressed: () async{
//               final studentprovider = Provider.of<StudentProvider>(context, listen: false);
//               studentprovider.changeStudentId = student['etuID'];
//               await studentprovider.updateStudentCard();
//               if(studentprovider.requestMessage == "success"){
//                 ElegantNotification.success(
//                   description: const Text("opération effectuée avec success"),
//                   title: const Text("Success"),
//                   notificationPosition: NOTIFICATION_POSITION.top,
//                   width: MediaQuery.of(context).size.width * 0.2,
//                 ).show(context);
//               }else{
//                 ElegantNotification.error(
//                   description: const Text("échec de l'operation"),
//                   title: const Text("erreur"),
//                   notificationPosition: NOTIFICATION_POSITION.top,
//                   width: MediaQuery.of(context).size.width * 0.2,
//                 ).show(context);
//               }
//             },
//             child: Text(
//               student['etatCarte'] == true ? "Activer" : "Désactiver",
//               style: const TextStyle(
//                 fontFamily: 'PopBold',
//                 color: Colors.white,
//               ),
//             ),
//             style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.resolveWith((states) => student['etatCarte'] == true ? secondcolor : thirdcolor),
//                 padding: MaterialStateProperty.all(const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5)),
//                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5.0),
//                       // side: BorderSide(color: Colors.red)
//                     )
//                 )
//             ),
//           ),
//           width: MediaQuery.of(context).size.width * 0.15,
//           height: 52,
//           padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
//           alignment: Alignment.centerLeft,
//         ),
//       ],
//     );
//   }
//
//   searchFunction(String query){
//     setState(() {
//       if(query == ""){
//         isSearch = false;
//       }else{
//         isSearch = true;
//       }
//     });
//     setState(() {
//       studentListSearch = studentList.where((element) {
//         return element['visitorFullName'].toLowerCase().contains(query.toLowerCase()) || element['vistorLastName'].toLowerCase().contains(query.toLowerCase()) || element['visitorCardId'].toLowerCase().contains(query.toLowerCase());
//       }).toList();
//     });
//   }
//   titleMenu(){
//     return Row(
//       children: [
//         searchWidget(),
//         const SizedBox(width: 10,),
//       ],
//     );
//   }
//   addNewVisitorWidget(){
//     final visitorProvider = Provider.of<VisitorProvider>(context, listen: false);
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.5,
//       width: MediaQuery.of(context).size.width * 0.2,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       alignment: Alignment.center,
//       child: Column(
//         children: [
//           Container(
//             color: secondcolor,
//             width: double.infinity,
//             height: 50,
//             child: const Center(
//               child: Text(
//                 "Ajouter un visiteur",
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontFamily: 'PopBold',
//                     fontSize: 15
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
//             child: Form(
//               key: key,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   TextFormField(
//                     keyboardType: TextInputType.text,
//                     validator: (e) => e!.isEmpty ? " ce champ est obligatoire":null,
//                     onChanged: (e){
//                       visitorProvider.changeVisitorFullName = e;
//                     },
//                     controller: nameController,
//                     maxLines: 1,
//                     style: const TextStyle(
//                         color: secondcolor
//                     ),
//                     decoration: const InputDecoration(
//                       hoverColor: Colors.white,
//                       hintText: 'Nom du visiteur',
//                       hintStyle: TextStyle(
//                           color: secondcolor,
//                           fontFamily: 'PopRegular',
//                           fontSize: 12
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(5)),
//                           borderSide: BorderSide(
//                               color: secondcolor
//                           )
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(5)),
//                           borderSide: BorderSide(
//                               color: color2
//                           )
//                       ),
//                       isDense: true,                      // Added this
//                       contentPadding: EdgeInsets.all(10),
//                       //hintText: "login",
//                       prefixIcon: Icon(Icons.person, color: color4,),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(5)),
//                           borderSide: BorderSide(
//                               color: color2
//                           )
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10,),
//                   TextFormField(
//                     keyboardType: TextInputType.text,
//                     onChanged: (e){
//                       visitorProvider.changeVisitorLastName = e;
//                     },
//                     controller: prenomController,
//                     maxLines: 1,
//                     style: const TextStyle(
//                         color: secondcolor
//                     ),
//                     decoration: const InputDecoration(
//                       hoverColor: Colors.white,
//                       hintText: 'Prenom',
//                       hintStyle: TextStyle(
//                           color: secondcolor,
//                           fontFamily: 'PopRegular',
//                           fontSize: 12
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(5)),
//                           borderSide: BorderSide(
//                               color: secondcolor
//                           )
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(5)),
//                           borderSide: BorderSide(
//                               color: color2
//                           )
//                       ),
//                       isDense: true,                      // Added this
//                       contentPadding: EdgeInsets.all(10),
//                       //hintText: "login",
//                       prefixIcon: Icon(Icons.person, color: color4,),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(5)),
//                           borderSide: BorderSide(
//                               color: color2
//                           )
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10,),
//                   TextFormField(
//                     keyboardType: TextInputType.text,
//                     validator: (e) => e!.isEmpty ? " ce champ est obligatoire":null,
//                     onChanged: (e){
//                       visitorProvider.changeVisitorCardId = e;
//                     },
//                     controller: cardController,
//                     maxLines: 1,
//                     style: const TextStyle(
//                         color: secondcolor
//                     ),
//                     decoration: const InputDecoration(
//                       hoverColor: Colors.white,
//                       hintText: "N Carte d'identité",
//                       hintStyle: TextStyle(
//                           color: secondcolor,
//                           fontFamily: 'PopRegular',
//                           fontSize: 12
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(5)),
//                           borderSide: BorderSide(
//                               color: secondcolor
//                           )
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(5)),
//                           borderSide: BorderSide(
//                               color: color2
//                           )
//                       ),
//                       isDense: true,                      // Added this
//                       contentPadding: EdgeInsets.all(10),
//                       //hintText: "login",
//                       prefixIcon: Icon(Icons.person, color: color4,),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(5)),
//                           borderSide: BorderSide(
//                               color: color2
//                           )
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10,),
//                   TextFormField(
//                     keyboardType: TextInputType.text,
//                     validator: (e) => e!.isEmpty ? " ce champ est obligatoire":null,
//                     onChanged: (e){
//                       visitorProvider.changeVisitorNumber = e;
//                     },
//                     controller: phoneController,
//                     maxLines: 1,
//                     style: const TextStyle(
//                         color: secondcolor
//                     ),
//                     decoration: const InputDecoration(
//                       hoverColor: Colors.white,
//                       hintText: 'N de téléphone',
//                       hintStyle: TextStyle(
//                           color: secondcolor,
//                           fontFamily: 'PopRegular',
//                           fontSize: 12
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(5)),
//                           borderSide: BorderSide(
//                               color: secondcolor
//                           )
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(5)),
//                           borderSide: BorderSide(
//                               color: color2
//                           )
//                       ),
//                       isDense: true,                      // Added this
//                       contentPadding: EdgeInsets.all(10),
//                       //hintText: "login",
//                       prefixIcon: Icon(Icons.person, color: color4,),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(5)),
//                           borderSide: BorderSide(
//                               color: color2
//                           )
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10,),
//                   ElevatedButton(
//                     onPressed: () async{
//                       if(key.currentState!.validate()){
//                         await visitorProvider.saveVisitor();
//                         if(visitorProvider.requestMessage == "success"){
//                           SmartDialog.dismiss();
//                           ElegantNotification.success(
//                             description: const Text("Visiteur enregistré avec succès"),
//                             title: const Text("Success"),
//                             notificationPosition: NOTIFICATION_POSITION.top,
//                             width: MediaQuery.of(context).size.width * 0.2,
//                           ).show(context);
//                         }else{
//                           SmartDialog.dismiss();
//                           ElegantNotification.error(
//                             description: const Text("un problème s'est produit durant l'enregistrement du visiteur"),
//                             title: const Text("échec"),
//                             notificationPosition: NOTIFICATION_POSITION.top,
//                             width: MediaQuery.of(context).size.width * 0.2,
//                           ).show(context);
//                         }
//                       }
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [
//                         Icon(Icons.add, color: Colors.white, size: 16,),
//                         SizedBox(width: 2,),
//                         Text(
//                           "Enregitrer",
//                           style: TextStyle(
//                             fontFamily: 'PopBold',
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                     style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.resolveWith((states) => secondcolor),
//                         padding: MaterialStateProperty.all(const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5)),
//                         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                               // side: BorderSide(color: Colors.red)
//                             )
//                         )
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//   searchWidget(){
//     return Container(
//       decoration: const BoxDecoration(
//         color: color3,
//         borderRadius: BorderRadius.all(Radius.circular(25)),
//       ),
//       //padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 20),
//       height: 30,
//       width: 300,
//       child: TextFormField(
//         keyboardType: TextInputType.text,
//         onChanged: searchFunction,
//         controller: searchController,
//         maxLines: 1,
//         style: const TextStyle(
//             color: secondcolor
//         ),
//         decoration: InputDecoration(
//           hoverColor: Colors.white,
//           suffixIcon: isSearch == true
//               ? InkWell(
//             child: const Icon(Icons.close, color: secondcolor,),
//             onTap: (){
//             },
//           )
//               : const SizedBox(),
//           hintText: 'Rechercher par: Nom, Matricule, Spécialité',
//           hintStyle: const TextStyle(
//               color: secondcolor,
//               fontFamily: 'PopRegular',
//               fontSize: 12
//           ),
//           focusedBorder: const OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(25)),
//               borderSide: BorderSide(
//                   color: secondcolor
//               )
//           ),
//           enabledBorder: const OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(25)),
//               borderSide: BorderSide(
//                   color: Colors.white
//               )
//           ),
//           isDense: true,                      // Added this
//           contentPadding: const EdgeInsets.all(10),
//           //hintText: "login",
//           prefixIcon: const Icon(Icons.search, color: color4,),
//           border: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(25)),
//           ),
//         ),
//       ),
//     );
//   }
// }
