import 'package:carousel_nullsafety/carousel_nullsafety.dart';
import 'package:cool_stepper_reloaded/cool_stepper_reloaded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple_button/ripple_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visitislape/Pages/homepage.dart';
import 'package:visitislape/Providers/authprovider.dart';
import 'package:visitislape/constantes.dart';

import '../../API/securityapi.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  SecurityApi securityApi = SecurityApi();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  bool isConnected = false;
  
  
  verifyStatus() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool i;
    if(localStorage.containsKey('site') && localStorage.containsKey('guard')){
      i = true;
    }else{
      i = false;
    }
    setState(() {
      isConnected = i;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    verifyStatus();
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.5,
            child: publicite(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.5,
            child: isConnected == true ? loginForm() :configurationSteps(),
          )
        ],
      ),
    );
  }

  configurationSteps(){
    final authprovider = Provider.of<AuthProvider>(context);
    return CoolStepper(
        isHeaderEnabled: false,
        hasRoundedCorner: false,
        onCompleted: () async{
          print("dfzukbgrzekfgrhufg");
          await authprovider.createSite();
          if(authprovider.siteRequestMessage == "success"){
            authprovider.changeGuardRole = "ROLE_ADMIN";
            await authprovider.createGuard();
            if(authprovider.guardRequestMessage == "success"){
              await authprovider.authGuard();
              if(authprovider.siteRequestMessage == "success"){
                await securityApi.setSite(authprovider.siteId);
                await securityApi.setGuard(authprovider.guardId);
                await securityApi.setToken(authprovider.token);
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
              }
            }
          }
        },
        config: CoolStepperConfig(
          stepText: "étape",
          ofText: "sur",
          stepColor: Colors.white,
          backButton: RippleButton(
            'Retour',
            type: RippleButtonType.BLUE_TRANSLUCENT,
            padding: const EdgeInsets.only(left: 16, bottom: 15),
            style: const RippleButtonStyle(
              width: 24,
            ),
            onPressed: () => {},
          ),
          nextButton: RippleButton(
            'Suivant',
            type: RippleButtonType.PINK,
            padding: const EdgeInsets.only(right: 16, bottom: 15),
            style: const RippleButtonStyle(
              width: 24,
            ),
            onPressed: () => {},
          ),
          finishButton: RippleButton(
            'Terminer',
            type: RippleButtonType.PINK,
            padding: const EdgeInsets.only(right: 16, bottom: 15),
            style: const RippleButtonStyle(
              width: 24,
            ),
            onPressed: () {
              // print("dfzukbgrzekfgrhufg");
              // await authprovider.createSite();
              // await authprovider.createGuard();
              // if(authprovider.siteRequestMessage == "success" && authprovider.guardRequestMessage == "success"){
              //   await authprovider.authGuard();
              //   if(authprovider.siteRequestMessage == "success"){
              //     await securityApi.setToken(authprovider.token);
              //     Navigator.pop(context);
              //     Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
              //   }
              // }
            },
          ),
        ),
        steps: [
          welcomeStep(),
          CoolStep(
              alignment: Alignment.center,
              validation: () {
                if (!_formKey.currentState!.validate()) {
                  return 'Fill form correctly';   // Error message to be shown
                }
                return null;
              },
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Text(
                        "Cela vous aidera à séparer les données si votre entreprise possède plusieurs sites",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'PopBold',
                            fontSize: 15
                        ),
                      ),
                    ),
                    const SizedBox(height: 80,),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                      ),
                      color: Colors.white,
                      elevation: 15.0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 30),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const Text(
                                "Description du site",
                                style: TextStyle(
                                    fontFamily: 'PopRegular',
                                    fontSize: 15,
                                    color: fisrtcolor
                                ),
                              ),
                              const SizedBox(height: 30,),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                validator: (e) => e!.isEmpty ? " ce champ est obligatoire":null,
                                onChanged: (e){
                                  authprovider.changeSiteName = e;
                                },
                                //controller: nameController,
                                maxLines: 1,
                                style: const TextStyle(
                                    color: secondcolor
                                ),
                                decoration: const InputDecoration(
                                  hoverColor: Colors.white,
                                  hintText: 'Nom du Site',
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
                              const SizedBox(height: 15,),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                validator: (e) => e!.isEmpty ? " ce champ est obligatoire":null,
                                onChanged: (e){
                                  authprovider.changeSiteActive = e;
                                },
                                //controller: nameController,
                                maxLines: 1,
                                style: const TextStyle(
                                    color: secondcolor
                                ),
                                decoration: const InputDecoration(
                                  hoverColor: Colors.white,
                                  hintText: 'Lieu du Site',
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ),
          CoolStep(
              alignment: Alignment.center,
              validation: () {
                if (!_formKey2.currentState!.validate()) {
                  return 'Fill form correctly';   // Error message to be shown
                }
                return null;
              },
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Text(
                        "Créer un compte administrateur pour manager l'ensemble du système",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'PopBold',
                            fontSize: 15
                        ),
                      ),
                    ),
                    const SizedBox(height: 80,),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                      ),
                      color: Colors.white,
                      elevation: 15.0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 30),
                        child: Form(
                          key: _formKey2,
                          child: Column(
                            children: [
                              const Text(
                                "Création du compte",
                                style: TextStyle(
                                    fontFamily: 'PopRegular',
                                    fontSize: 15,
                                    color: fisrtcolor
                                ),
                              ),
                              const SizedBox(height: 30,),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                validator: (e) => e!.isEmpty ? " ce champ est obligatoire":null,
                                onChanged: (e){
                                  authprovider.changeGuardFullName = e;
                                },
                                //controller: nameController,
                                maxLines: 1,
                                style: const TextStyle(
                                    color: secondcolor
                                ),
                                decoration: const InputDecoration(
                                  hoverColor: Colors.white,
                                  hintText: 'Nom',
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
                              const SizedBox(height: 15,),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                validator: (e) => e!.isEmpty ? " ce champ est obligatoire":null,
                                onChanged: (e){
                                  authprovider.changeGuardUserName = e;
                                },
                                //controller: nameController,
                                maxLines: 1,
                                style: const TextStyle(
                                    color: secondcolor
                                ),
                                decoration: const InputDecoration(
                                  hoverColor: Colors.white,
                                  hintText: 'Username',
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
                              const SizedBox(height: 15,),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                controller: passwordController,
                                onChanged: (e){
                                  authprovider.changeGuardPassword = e;
                                },
                                validator: (e) => e!.isEmpty ? "Mot de passe non valide":null,
                                maxLines: 1,
                                obscureText: true,
                                style: const TextStyle(
                                    color: secondcolor
                                ),
                                decoration: const InputDecoration(
                                  hoverColor: Colors.white,
                                  hintText: 'Mot de passe',
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
                              TextFormField(
                                keyboardType: TextInputType.text,
                                controller: confirmpasswordController,
                                validator: (e) => e!.isEmpty || e != passwordController.text ? " confirmation non valide":null,
                                maxLines: 1,
                                obscureText: true,
                                style: const TextStyle(
                                    color: secondcolor
                                ),
                                decoration: const InputDecoration(
                                  hoverColor: Colors.white,
                                  hintText: 'Confirmer le mot de passe',
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ),
        ]
    );
  }
  
  loginForm(){
    final authprovider = Provider.of<AuthProvider>(context);
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
          ),
          color: Colors.white,
          elevation: 15.0,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 30),
            child: Form(
              key: _formKey3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Se connecter",
                    style: TextStyle(
                        fontFamily: 'PopRegular',
                        fontSize: 15,
                        color: fisrtcolor
                    ),
                  ),
                  const SizedBox(height: 30,),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    validator: (e) => e!.isEmpty ? " ce champ est obligatoire":null,
                    onChanged: (e){
                      authprovider.changeGuardUserName = e;
                    },
                    //controller: nameController,
                    maxLines: 1,
                    style: const TextStyle(
                        color: secondcolor
                    ),
                    decoration: const InputDecoration(
                      hoverColor: Colors.white,
                      hintText: 'login',
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
                  const SizedBox(height: 15,),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    validator: (e) => e!.isEmpty ? " ce champ est obligatoire":null,
                    onChanged: (e){
                      authprovider.changeGuardPassword = e;
                    },
                    obscureText: true,
                    //controller: nameController,
                    maxLines: 1,
                    style: const TextStyle(
                        color: secondcolor
                    ),
                    decoration: const InputDecoration(
                      hoverColor: Colors.white,
                      hintText: 'Mot de passe',
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
                  const SizedBox(height: 30,),
                  RippleButton(
                    'connexion',
                    type: RippleButtonType.PINK,
                    padding: const EdgeInsets.only(right: 16, bottom: 15),
                    style: const RippleButtonStyle(
                      width: 24,
                    ),
                    onPressed: () async{
                      if(_formKey3.currentState!.validate()){
                        await authprovider.authGuard();
                        if(authprovider.siteRequestMessage == "success"){
                          await securityApi.setToken(authprovider.token);
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  welcomeStep(){
    return CoolStep(
      alignment: Alignment.center,
        content: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: [
              const Text(
                "Bienvenue sur Digital Security la plateforme de gestion de la sécurité la plus moderne",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'PopBold',
                    fontSize: 20
                ),
              ),
              Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
              ),
            ],
          ),
        )
    );
  }

  configureSiteStep(){
    return CoolStep(
        alignment: Alignment.center,
        validation: () {
          if (!_formKey.currentState!.validate()) {
            return 'Fill form correctly';   // Error message to be shown
          }
          return null;
        },
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  "Cela vous aidera à séparer les données si votre entreprise possède plusieurs sites",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'PopBold',
                      fontSize: 15
                  ),
                ),
              ),
              const SizedBox(height: 80,),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
                color: Colors.white,
                elevation: 15.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          "Description du site",
                          style: TextStyle(
                            fontFamily: 'PopRegular',
                            fontSize: 15,
                            color: fisrtcolor
                          ),
                        ),
                        const SizedBox(height: 30,),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (e) => e!.isEmpty ? " ce champ est obligatoire":null,
                          onChanged: (e){
                            //visitorProvider.changeVisitorFullName = e;
                          },
                          //controller: nameController,
                          maxLines: 1,
                          style: const TextStyle(
                              color: secondcolor
                          ),
                          decoration: const InputDecoration(
                            hoverColor: Colors.white,
                            hintText: 'Nom du Site',
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
                        const SizedBox(height: 15,),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (e) => e!.isEmpty ? " ce champ est obligatoire":null,
                          onChanged: (e){
                            //visitorProvider.changeVisitorFullName = e;
                          },
                          //controller: nameController,
                          maxLines: 1,
                          style: const TextStyle(
                              color: secondcolor
                          ),
                          decoration: const InputDecoration(
                            hoverColor: Colors.white,
                            hintText: 'Lieu du Site',
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  configureAdminStep(){

    return CoolStep(
        alignment: Alignment.center,
        validation: () {
          if (!_formKey2.currentState!.validate()) {
            return 'Fill form correctly';   // Error message to be shown
          }
          return null;
        },
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  "Créer un compte administrateur pour manager l'ensemble du système",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'PopBold',
                      fontSize: 15
                  ),
                ),
              ),
              const SizedBox(height: 80,),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                ),
                color: Colors.white,
                elevation: 15.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 30),
                  child: Form(
                    key: _formKey2,
                    child: Column(
                      children: [
                        const Text(
                          "Création du compte",
                          style: TextStyle(
                              fontFamily: 'PopRegular',
                              fontSize: 15,
                              color: fisrtcolor
                          ),
                        ),
                        const SizedBox(height: 30,),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (e) => e!.isEmpty ? " ce champ est obligatoire":null,
                          onChanged: (e){
                            //visitorProvider.changeVisitorFullName = e;
                          },
                          //controller: nameController,
                          maxLines: 1,
                          style: const TextStyle(
                              color: secondcolor
                          ),
                          decoration: const InputDecoration(
                            hoverColor: Colors.white,
                            hintText: 'Nom',
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
                        const SizedBox(height: 15,),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (e) => e!.isEmpty ? " ce champ est obligatoire":null,
                          onChanged: (e){
                            //visitorProvider.changeVisitorFullName = e;
                          },
                          //controller: nameController,
                          maxLines: 1,
                          style: const TextStyle(
                              color: secondcolor
                          ),
                          decoration: const InputDecoration(
                            hoverColor: Colors.white,
                            hintText: 'Username',
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
                        const SizedBox(height: 15,),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: passwordController,
                          onChanged: (e){
                            //userprovider.Changepassword = e;
                          },
                          validator: (e) => e!.isEmpty ? "Mot de passe non valide":null,
                          maxLines: 1,
                          obscureText: true,
                          style: const TextStyle(
                              color: Colors.white
                          ),
                          decoration: const InputDecoration(
                            hoverColor: Colors.white,
                            hintText: 'Mot de passe',
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
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: confirmpasswordController,
                          validator: (e) => e!.isEmpty || e != passwordController.text ? " confirmation non valide":null,
                          maxLines: 1,
                          obscureText: true,
                          style: const TextStyle(
                              color: Colors.white
                          ),
                          decoration: const InputDecoration(
                            hoverColor: Colors.white,
                            hintText: 'Confirmer le mot de passe',
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  publicite(){
    return Carousel(
      dotSize: 6.0,
      dotSpacing: 20.0,
      dotIncreasedColor: fisrtcolor,
      dotColor: Colors.pink,
      //indicatorBgPadding: 120.0,
      dotBgColor: Colors.transparent,
      autoplay: true,
      borderRadius: true,
      images:[
        slide1(),
        slide2(),
        slide3(),
      ]
    );
  }

  slide1(){
    return Column(
      children: [
        Image.asset(
          "assets/images/badge.png",
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.8,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Text(
            "Créer et gérer des badges temporaires pour des visiteurs VIP",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'PopBold',
                fontSize: 15
            ),
          ),
        )
      ],
    );
  }
  slide2(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/management.png",
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.8,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Text(
            "Gérer facilement les entrées et sorties de votre entreprise gràce à DigitalSecurity",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'PopBold',
                fontSize: 15
            ),
          ),
        )
      ],
    );
  }
  slide3(){
    return Column(
      children: [
        Image.asset(
          "assets/images/scancard.png",
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.8,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Text(
            "Scanner rapidement les cartes gràce au lecteur et aux technologies de dernières générations",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'PopBold',
              fontSize: 15
            ),
          ),
        )
      ],
    );
  }
}
