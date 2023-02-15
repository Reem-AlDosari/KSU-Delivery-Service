import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kcds/resources/resources.dart';
import 'package:kcds/src/Landing_pages/landing_page.dart';
import 'package:kcds/src/Landing_pages/splash/splash.dart';
import 'package:kcds/src/auth/view/auth_view.dart';
import 'package:kcds/src/auth/view_model/auth_vm.dart';
import 'package:kcds/src/base/carrier/carrier_base_view.dart';
import 'package:kcds/src/base/carrier/carrier_home/view/carrier_home_view.dart';
import 'package:kcds/src/base/carrier/carrier_home/view_model/carrier_home_vm.dart';
import 'package:kcds/src/base/carrier/carrier_order/view/carrier_order_view.dart';
import 'package:kcds/src/base/carrier/carrier_order/view_model/carrier_order_vm.dart';
import 'package:kcds/src/base/customer/base_view.dart';
import 'package:kcds/src/base/customer/base_vm.dart';
import 'package:kcds/src/base/customer/home/view/home_view.dart';
import 'package:kcds/src/base/customer/home/view_model/home_vm.dart';
import 'package:kcds/src/base/customer/order/view/order_view.dart';
import 'package:kcds/src/base/customer/order/view/type_order_view.dart';
import 'package:kcds/src/base/customer/order/view_model/order_vm.dart';
import 'package:kcds/src/chat/view/chat_view.dart';
import 'package:kcds/src/chat/view_model/chat_vm.dart';
import 'package:kcds/src/location/view/location_view.dart';
import 'package:kcds/src/location/view_model/location_viewmodal.dart';
import 'package:kcds/src/widgets/Report_issue.dart';
import 'package:kcds/src/widgets/dunkin_page.dart';
import 'package:kcds/src/widgets/payment_method_view.dart';
import 'package:kcds/src/widgets/registration_successful.dart';
import 'package:kcds/src/widgets/subway_page.dart';
import 'package:kcds/utils/fb_msg_handler/fmsg_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final GlobalKey<NavigatorState>? navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: R.colors.theme,
      statusBarIconBrightness: Brightness.light,
    ));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthVM()),
          ChangeNotifierProvider(create: (context) => BaseVM()),
          ChangeNotifierProvider(create: (context) => HomeVM()),
          ChangeNotifierProvider(create: (context) => OrderVM()),
          ChangeNotifierProvider(create: (context) => CarrierOrderVM()),
          ChangeNotifierProvider(create: (context) => CarrierHomeVM()),
          ChangeNotifierProvider(create: (context) => ChatVM()),
          ChangeNotifierProvider(create: (context) => RoomProvider()),
        ],
        child: Sizer(builder: (context, orientation, deviceType) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'KSUDS',
            theme: ThemeData(
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: R.colors.theme, //thereby
              ),
              primaryColor: R.colors.theme,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            initialRoute: SplashView.route,
            getPages: [
              GetPage(
                  name: SplashView.route,
                  page: () => Application(
                        page: SplashView(),
                      )),
              GetPage(name: AuthView.route, page: () => const AuthView()),
              GetPage(name: PaymentView.route, page: () => const PaymentView()),
              GetPage(name: DunkinView.route, page: () => const DunkinView()),
              GetPage(name: SubwayView.route, page: () => const SubwayView()),
              GetPage(
                  name: RegistrationSuccessful.route,
                  page: () => const RegistrationSuccessful()),
              GetPage(
                  name: ReportAnIssue.route, page: () => const ReportAnIssue()),
              GetPage(
                  name: RegistrationSuccessful.route,
                  page: () => const RegistrationSuccessful()),
              GetPage(
                  name: ChatView.route,
                  page: () => ChatView(
                        orderId: '',
                      )),
              GetPage(name: LandingPage.route, page: () => const LandingPage()),
              GetPage(name: BaseView.route, page: () => const BaseView()),
              GetPage(
                  name: CarrierBaseView.route,
                  page: () => const CarrierBaseView()),
              GetPage(name: HomeView.route, page: () => const HomeView()),
              GetPage(name: OrderView.route, page: () => const OrderView()),
              GetPage(name: TypeOrder.route, page: () => const TypeOrder()),
              GetPage(
                  name: CarrierHomeView.route,
                  page: () => const CarrierHomeView()),
              GetPage(
                  name: CarrierOrderView.route,
                  page: () => const CarrierOrderView()),
              GetPage(name: LocationView.route, page: () => LocationView())
            ],
          );
        }));
  }
}
