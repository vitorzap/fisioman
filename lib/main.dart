import 'package:fisioman/views/session_delete_form_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'views/open_payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './views/client_screen.dart';
import './providers/clients.dart';
import './providers/session_days.dart';
import './providers/session_by_day.dart';
import './providers/payments.dart';
import './providers/checks.dart';
import './providers/sessions.dart';
import './utils/app_routes.dart';
import './views/client_form_screen.dart';
import './views/client_details_screen.dart';
import './views/payment_form_screen.dart';
import './views/payment_client_screen.dart';
import './views/session_day_screen.dart';
import './views/payment_confirm_form_screen.dart';
import './views/check_payment_screen.dart';
import './views/check_form_screen.dart';
import './views/check_withdraw_form_screen.dart';
import './views/open_check_screen.dart';
import './views/session_client_screen.dart';
import './views/session_form_screen.dart';
import './views/session_schedule_form_screen.dart';
import './views/session_generate_form_screen.dart';
import './views/session_screen.dart';
import './views/util_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new Clients(),
        ),
        ChangeNotifierProvider(
          create: (_) => new SessionDays(),
        ),
        ChangeNotifierProvider(
          create: (_) => new SessionsByDay(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Payments(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Checks(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Sessions(),
        ),
      ],
      child: MaterialApp(
          localizationsDelegates: [GlobalMaterialLocalizations.delegate],
          supportedLocales: [const Locale('en'), const Locale('pt')],
          title: 'FisioMan',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
          ),
          // home: ClientScreen(),
          routes: {
            AppRoutes.HOME: (ctx) => ClientScreen(),
            AppRoutes.CLIENT_FORM: (ctx) => ClientFormScreen(),
            AppRoutes.CLIENT_DETAILS: (ctx) => ClientDetailsScreen(),
            AppRoutes.SESSION_DAY_SCREEN: (ctx) => SessionDayScreen(),
            AppRoutes.OPEN_PAYMENT_SCREEN: (ctx) => OpenPaymentScreen(),
            AppRoutes.CLIENT_PAYMENT_SCREEN: (ctx) => ClientPaymentScreen(),
            AppRoutes.PAYMENT_FORM_SCREEN: (ctx) => PaymentFormScreen(),
            AppRoutes.PAYMENT_CONFIRM_FORM_SCREEN: (ctx) =>
                PaymentConfirmFormScreen(),
            AppRoutes.PAYMENT_CHECK_SCREEN: (ctx) => PaymentCheckScreen(),
            AppRoutes.CHECK_FORM_SCREEN: (ctx) => CheckFormScreen(),
            AppRoutes.CHECK_WITHDRAW_FORM_SCREEN: (ctx) =>
                CheckWithdrawFormScreen(),
            AppRoutes.OPEN_CHECK_SCREEN: (ctx) => OpenCheckScreen(),
            AppRoutes.CLIENT_SESSION_SCREEN: (ctx) => ClientSessionScreen(),
            AppRoutes.SESSION_FORM_SCREEN: (ctx) => SessionFormScreen(),
            AppRoutes.SESSION_SCHEDULE_FORM_SCREEN: (ctx) =>
                SessionScheduleFormScreen(),
            AppRoutes.SESSION_GENERATE_FORM_SCREEN: (ctx) =>
                SessionGenerateFormScreen(),
            AppRoutes.SESSION_DELETE_FORM_SCREEN: (ctx) =>
                SessionDeleteFormScreen(),
            AppRoutes.SESSION_SCREEN: (ctx) => SessionScreen(),
            AppRoutes.UTILIDADES: (ctx) => UtilScreen()
          }),
    );
  }
}
