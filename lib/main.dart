import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:visitislape/Pages/Auth/register.dart';
import 'package:visitislape/Providers/authprovider.dart';
import 'package:visitislape/Providers/employeeprovider.dart';
import 'package:visitislape/Providers/studentprovider.dart';
import 'package:visitislape/Providers/visitorprovider.dart';
import 'package:visitislape/Providers/visitprovider.dart';
import 'Pages/homepage.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<VisitProvider>(create: (_) => VisitProvider()),
        Provider<VisitorProvider>(create: (_) => VisitorProvider()),
        Provider<EmployeeProvider>(create: (_) => EmployeeProvider()),
        Provider<StudentProvider>(create: (_) => StudentProvider()),
        Provider<AuthProvider>(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const RegisterPage(),
          navigatorObservers: [FlutterSmartDialog.observer],
          // here
          builder: FlutterSmartDialog.init()
      ),
    );
  }
}
