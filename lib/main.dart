import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tto/constant/color.dart';
// import 'package:tto/pages/form_page.dart' deferred as formPage;
// import 'package:tto/pages/home_page.dart' deferred as homePage;
// import 'package:tto/pages/approve_page.dart' deferred as approvalPage;
import 'package:tto/pages/form_page.dart';
import 'package:tto/pages/home_page.dart';
import 'package:tto/pages/approve_page.dart';
import 'package:go_router/go_router.dart';

import 'constant/color.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  // final Future<void> formPageLoadLibrary = formPage.loadLibrary();
  // final Future<void> approvePageLoadLibrary = approvalPage.loadLibrary();

  // Future<FutureBuilder> formPageLoad() async{
  //   return  FutureBuilder(
  //           future: formPageLoadLibrary,
  //           builder: (context, snapshot) {
  //             return formPage.FormPage();
  //           },
  //         )
  // }
  late final _router = GoRouter(
    routes: [
      GoRoute(
        name: 'home',
        path: '/',
        // builder: (context, state) => HomePage(),
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: HomePage(),
        ),
        // pageBuilder: (context, state) => NoTransitionPage<void>(
        //   key: state.pageKey,
        //   child: FutureBuilder(
        //     future: homePage.loadLibrary(),
        //     builder: (context, snapshot) {
        //       return homePage.HomePage();
        //     },
        //   ),
        // ),
      ),
      GoRoute(
        name: 'submit_form',
        path: '/form',
        // builder: (context, state) => HomePage(),
        // pageBuilder: (context, state) => NoTransitionPage<void>(
        //   key: state.pageKey,
        //   child:
        // ),
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: FormPage(),
        ),
      ),
      GoRoute(
        name: 'approve_page',
        path: '/approval/id=:id',
        // builder: (context, state) => HomePage(),
        // pageBuilder: (context, state) => NoTransitionPage<void>(
        //   key: state.pageKey,
        //   child: FutureBuilder(
        //     future: approvePageLoadLibrary,
        //     builder: (context, snapshot) {
        //       return approvalPage.ApprovalPage(
        //         id: state.params['id'],
        //       );
        //     },
        //   ),
        // ),
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: ApprovalPage(
            id: state.params['id'],
          ),
        ),
      ),
    ],
    initialLocation: '/form',
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: MaterialApp.router(
        title: 'TT O',
        theme: ThemeData(
          fontFamily: 'Helvetica',
          scaffoldBackgroundColor: scaffoldBg,
          backgroundColor: scaffoldBg,
        ),
        debugShowCheckedModeBanner: false,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        routeInformationProvider: _router.routeInformationProvider,
        builder: (context, child) => ResponsiveWrapper.builder(
          child,
          minWidth: 600,
          maxWidth: MediaQuery.of(context).size.width < 600 ? 600 : 1366,
          defaultScale: MediaQuery.of(context).size.width < 600 ? true : false,
          // defaultScale: true,
          // backgroundColor: Colors.amberAccent,
          background: Container(
            color: scaffoldBg,
          ),
          breakpoints: const [
            // ResponsiveBreakpoint.resize(480, name: MOBILE),
            // ResponsiveBreakpoint.resize(600, name: TABLET),
          ],
        ),
      ),
    );
  }
}
