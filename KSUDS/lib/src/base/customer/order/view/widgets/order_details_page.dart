import 'dart:async';
import 'dart:math';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kcds/constants/enums.dart';
import 'package:kcds/src/base/customer/order/view/widgets/accept_reject_sheet.dart';
import 'package:kcds/src/base/customer/order/view/widgets/payment_successful.dart';
import 'package:kcds/src/base/customer/order/view/widgets/rate_user.dart';
import 'package:kcds/src/base/customer/order/view_model/order_vm.dart';
import 'package:kcds/src/location/model/location_model.dart';
import 'package:kcds/utils/show_message.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../resources/resources.dart';
import '../../../../../../utils/fb_collections.dart';
import '../../../../../../utils/fb_msg_handler/fb_notifications.dart';
import '../../../../../../utils/loader.dart';
import '../../../../../auth/view_model/auth_vm.dart';
import '../../../../../chat/view/chat_view.dart';
import '../../../../../notifications/model/app_notification.dart';
import '../../../../../widgets/my_button.dart';
import '../../model/order.dart';

class OrderDetailsPage extends StatefulWidget {
  final Order order;
  final bool isCustomer;
  final bool showDetail;
  const OrderDetailsPage(
      {Key? key,
      this.isCustomer = true,
      required this.order,
      this.showDetail = true})
      : super(key: key);

  @override
  State<OrderDetailsPage> createState() => OrderDetailsPageState();
}

class OrderDetailsPageState extends State<OrderDetailsPage> {
  FBNotification fbNotification = FBNotification();
  bool isLoading = false;
  final Completer<GoogleMapController> _controller = Completer();
  PolylinePoints polylinePoints = PolylinePoints();

  Set<Marker> _markers = Set();
  Set<Polyline> _polyline = {};
  Set<Polyline> _polylineEmpty = {};

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.721429997204492, 46.62304240158732),
    zoom: 17.4746,
  );

  static CameraPosition _kStore = CameraPosition(
      target: LatLng(24.720407927655305, 46.62231284079452), zoom: 18);

  late OrderVM provider;

  List<LatLng> polylineCoordinates = [];
  List<EachLine> resultLine = [];
  List<String> statuses = [
    'Pending',
    'Accepted',
    'Going to pickup',
    'Picked Food',
    'Arrived at drop location',
    'Delivered',
    'Canceled'
  ];
  int selectRes = 0;
  late Detail rest;
  int index = 0;
  int selectedLine = -1;

  Future<void> computePath(LatLng end) async {
    polylineCoordinates = [];
    _kStore = CameraPosition(
        target: LatLng(
            rest.lat ?? 24.717441525288805, rest.long ?? 46.61921735518651),
        zoom: 18);
    resultLine = await GetRouteByMap().getRoutesList(
        _kStore.target, LatLng(end.latitude, end.longitude), 'walking');
    int index = 0;
    for (var eachLine in resultLine) {
      eachLine.points?.forEach((LatLng element) {
        polylineCoordinates.add(element);
      });
      final _random = Random();
      _polyline.add(Polyline(
          polylineId: PolylineId('iter' + index.toString()),
          visible: true,
          points: polylineCoordinates,
          width: 3,
          color: Colors.lightBlue,
          // color: Color.fromARGB(_random.nextInt(256), _random.nextInt(256),
          //     _random.nextInt(256), _random.nextInt(256)),
          startCap: Cap.roundCap,
          endCap: Cap.buttCap,
          patterns: [PatternItem.dash(15), PatternItem.gap(5)],
          onTap: () {
            selectedLine = index;
            setState(() {});
          }));
      break;
    }
  }

  getPolyline() async {
    await computePath(LatLng((widget.order.dropLat)!, (widget.order.dropLng)!));
    _setMapFitToTour(_polyline);
    setState(() {});
  }

  void _setMapFitToTour(Set<Polyline> p) async {
    double minLat = p.first.points.first.latitude;
    double minLong = p.first.points.first.longitude;
    double maxLat = p.first.points.first.latitude;
    double maxLong = p.first.points.first.longitude;
    p.forEach((poly) {
      poly.points.forEach((point) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLong) minLong = point.longitude;
        if (point.longitude > maxLong) maxLong = point.longitude;
      });
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(minLat, minLong),
            northeast: LatLng(maxLat, maxLong)),
        20));
  }

  @override
  void didChangeDependencies() {
    Future.delayed(Duration(milliseconds: 100), () async {
      trackOrder();
    });

    super.didChangeDependencies();
  }

  Future<void> trackOrder() async {
    setState(() {
      isLoading = true;
    });
    await provider.disposeCurrentOrder();
    await provider.fetchOrderStream(widget.order.id!);
    await _markers.add(Marker(
        markerId: MarkerId("room" + widget.order.id!),
        position: LatLng((widget.order.dropLat)!, (widget.order.dropLng)!),
        infoWindow: InfoWindow(title: (widget.order.dropAddress)!)));

    rest = Detail.fromJson(fixPosition[(widget.order.storeId)!]);
    await _markers.add(Marker(
        markerId: MarkerId("rest"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        position: LatLng(
            rest.lat ?? 24.717441525288805, rest.long ?? 46.61921735518651),
        infoWindow: InfoWindow(title: rest.label)));
    await getPolyline();
    _kStore = CameraPosition(
        target: LatLng(
            rest.lat ?? 24.720407927655305, rest.long ?? 46.62231284079452),
        zoom: 18);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    provider = Provider.of<OrderVM>(context, listen: false);
    // trackOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthVM, OrderVM>(builder: (context, model, orderVm, _) {
      return ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: MyLoader(),
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 9.h,
            elevation: 0.7,
            backgroundColor: R.colors.theme,
            title: Image.asset(
              R.images.pin,
              height: 5.h,
            ),
            centerTitle: true,
            leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: R.colors.white,
                    boxShadow: [
                      BoxShadow(color: R.colors.grey, blurRadius: 10)
                    ]),
                width: 2.h,
                height: 2.h,
                margin: EdgeInsets.only(left: 4.w, top: 1.5.h, bottom: 1.5.h),
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: R.colors.darkGrey,
                ),
              ),
            ),
          ),
          body: resultLine.isEmpty
              ? SizedBox()
              : Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.hybrid,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) async {
                        _controller.complete(controller);
                      },
                      padding: const EdgeInsets.only(bottom: 100),
                      markers: _markers,
                      polylines: _polyline,
                    ),
                    if (model.appUser?.role == UserType.customer.index &&
                        widget.showDetail)
                      Container(
                        margin: EdgeInsets.all(
                          20,
                        ),
                        height: 360,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  statuses[(orderVm.streamOrder?.status)!],
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                                GlowingProgressIndicator(
                                  child: Image.asset(
                                    R.images.logo,
                                    height: 30,
                                  ),
                                ),
                              ],
                            ),
                            R.sizedBox.sizedBox1h(),
                            FutureBuilder(
                                future: FBCollections.users
                                    .doc(widget.order.carrierId)
                                    .get(),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (!snapshot.hasData) {
                                    return MyLoader();
                                  } else {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Carrier:${snapshot.data['fullName'] ?? ""}',
                                          style: R.textStyles
                                              .poppinsTitle1()
                                              .copyWith(
                                                fontSize: 12.sp,
                                              ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _makePhoneCall(
                                                    'tel:${snapshot.data['phoneNo']}');
                                              });
                                            },
                                            icon: Icon(Icons.phone)),
                                      ],
                                    );
                                  }
                                }),
                            R.sizedBox.sizedBox1h(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order ID:',
                                  style: R.textStyles.poppinsTitle1().copyWith(
                                        fontSize: 12.sp,
                                      ),
                                ),
                                Text(
                                  '#${widget.order.id}',
                                  style: R.textStyles.poppinsTitle1().copyWith(
                                      fontSize: 12.sp,
                                      color: const Color(0xff667C8A)),
                                ),
                              ],
                            ),
                            R.sizedBox.sizedBox1h(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Bill:',
                                  style: R.textStyles.poppinsTitle1().copyWith(
                                        fontSize: 12.sp,
                                      ),
                                ),
                                Text(
                                  '${widget.order.totalPrice}',
                                  style: R.textStyles.poppinsTitle1().copyWith(
                                      fontSize: 12.sp,
                                      color: const Color(0xff667C8A)),
                                ),
                              ],
                            ),
                            R.sizedBox.sizedBox1h(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order Detail:',
                                  style: R.textStyles.poppinsTitle1().copyWith(
                                        fontSize: 12.sp,
                                      ),
                                ),
                                Text(
                                  '${widget.order.orderDetail}',
                                  style: R.textStyles.poppinsTitle1().copyWith(
                                      fontSize: 12.sp,
                                      color: const Color(0xff667C8A)),
                                ),
                              ],
                            ),
                            R.sizedBox.sizedBox1h(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Time:',
                                  style: R.textStyles.poppinsTitle1().copyWith(
                                        fontSize: 12.sp,
                                      ),
                                ),
                                Text(
                                  ' ${DateFormat('yyyy-MM-dd – hh:mm a').format(((widget.order.createdAt)?.toDate())!)}',
                                  style: R.textStyles.poppinsTitle1().copyWith(
                                      fontSize: 12.sp,
                                      color: const Color(0xff667C8A)),
                                ),
                              ],
                            ),
                            R.sizedBox.sizedBox1h(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Payment status ${orderVm.streamOrder?.paymentStatus == 0 ? 'Not Paid' : orderVm.streamOrder?.paymentStatus == 1 ? 'Bill Exported' : 'Paid'}',
                                  style: R.textStyles.poppinsTitle1().copyWith(
                                        fontSize: 12.sp,
                                      ),
                                ),
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("chats")
                                      .where('roomId',
                                          isEqualTo: widget.order.id)
                                      .where('receiver',
                                          isEqualTo: model.appUser?.email)
                                      .where('isSeen', isEqualTo: false)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return SizedBox();
                                    } else if (snapshot.data!.docs.isEmpty) {
                                      return IconButton(
                                          onPressed: () {
                                            Get.to(() => ChatView(
                                                  price: widget.order.price,
                                                  peerId:
                                                      widget.order.carrierId,
                                                  orderId: (orderVm
                                                      .streamOrder?.id)!,
                                                ));
                                          },
                                          icon: Image.asset(
                                              R.images.commentIcon));
                                    } else {
                                      return Badge(
                                        position: BadgePosition.topEnd(
                                            end: 0, top: 6),
                                        badgeContent: Text(
                                          '${snapshot.data!.docs.length}',
                                          style: R.textStyles
                                              .robotoRegular()
                                              .copyWith(
                                                  fontSize: 8,
                                                  color: R.colors.white),
                                        ),
                                        child: IconButton(
                                            onPressed: () {
                                              Get.to(() => ChatView(
                                                    price: widget.order.price,
                                                    peerId:
                                                        widget.order.carrierId,
                                                    orderId: (orderVm
                                                        .streamOrder?.id)!,
                                                  ));
                                            },
                                            icon: Image.asset(
                                                R.images.commentIcon)),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                            R.sizedBox.sizedBox1h(),
                            R.sizedBox.sizedBox3w(),
                            (orderVm.streamOrder?.status)! > 2
                                ? SizedBox()
                                : Expanded(
                                    child: MyButton(
                                        onTap: () {
                                          Get.bottomSheet(
                                            AcceptRejectSheet(
                                              accept: false,
                                              cancel: true,
                                              onTap: () async {
                                                Get.back();
                                                await cancelOrder(
                                                    widget.order, model);
                                              },
                                            ),
                                          );
                                        },
                                        buttonText: "Cancel"),
                                  ),
                            R.sizedBox.sizedBox1h(),
                            widget.order.paymentStatus ==
                                    PaymentStatus.Paid.index
                                ? StreamBuilder(
                                    stream: FBCollections.ratings
                                        .where('rate_by',
                                            isEqualTo: model.appUser?.email)
                                        .where('order_id',
                                            isEqualTo: orderVm.streamOrder?.id)
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: MyLoader(),
                                        );
                                      } else if (snapshot.data!.docs.isEmpty) {
                                        return MyButton(
                                            onTap: () {
                                              Get.to(() => RateUser(
                                                    orderId:
                                                        orderVm.streamOrder?.id,
                                                    userId: orderVm
                                                        .streamOrder?.carrierId,
                                                  ));
                                            },
                                            buttonText: "Rate Carrier");
                                      } else {
                                        return RatingBar.builder(
                                          ignoreGestures: true,
                                          initialRating: double.parse(
                                              '${snapshot.data!.docs[0]['rating']}'),
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {},
                                        );
                                      }
                                    },
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    widget.isCustomer
                        ? SizedBox()
                        : selectedLine == -1
                            ? Container()
                            : Container(
                                margin: EdgeInsets.only(top: 30, right: 10),
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.topRight,
                                child: Container(
                                  alignment: Alignment.topRight,
                                  decoration: BoxDecoration(
                                      color: Colors.tealAccent,
                                      borderRadius: BorderRadius.circular(15)),
                                  height: 40,
                                  width: 150,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        resultLine[selectedLine]
                                                .distanceTime
                                                ?.duration
                                                ?.text
                                                .toString() ??
                                            "no confirmed",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      Icon(Icons.directions_walk_outlined)
                                    ],
                                  ),
                                ),
                              ),
                    if (model.appUser?.role == UserType.carrier.index &&
                        widget.showDetail)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 52.h,
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order ID:',
                                    style:
                                        R.textStyles.poppinsTitle1().copyWith(
                                              fontSize: 12.sp,
                                            ),
                                  ),
                                  Text(
                                    '#${widget.order.id}',
                                    style: R.textStyles
                                        .poppinsTitle1()
                                        .copyWith(
                                            fontSize: 12.sp,
                                            color: const Color(0xff667C8A)),
                                  ),
                                ],
                              ),
                              R.sizedBox.sizedBox1h(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order Detail:',
                                    style:
                                        R.textStyles.poppinsTitle1().copyWith(
                                              fontSize: 12.sp,
                                            ),
                                  ),
                                  Text(
                                    '${widget.order.orderDetail}',
                                    style: R.textStyles
                                        .poppinsTitle1()
                                        .copyWith(
                                            fontSize: 12.sp,
                                            color: const Color(0xff667C8A)),
                                  ),
                                ],
                              ),
                              R.sizedBox.sizedBox1h(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Time:',
                                    style:
                                        R.textStyles.poppinsTitle1().copyWith(
                                              fontSize: 12.sp,
                                            ),
                                  ),
                                  Text(
                                    ' ${DateFormat('yyyy-MM-dd – hh:mm a').format(((widget.order.createdAt)?.toDate())!)}',
                                    style: R.textStyles
                                        .poppinsTitle1()
                                        .copyWith(
                                            fontSize: 12.sp,
                                            color: const Color(0xff667C8A)),
                                  ),
                                ],
                              ),
                              R.sizedBox.sizedBox1h(),
                              FutureBuilder(
                                  future: FBCollections.users
                                      .doc(widget.order.customerId)
                                      .get(),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                      return MyLoader();
                                    } else {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Customer:${snapshot.data['fullName'] ?? ""}',
                                            style: R.textStyles
                                                .poppinsTitle1()
                                                .copyWith(
                                                  fontSize: 12.sp,
                                                ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _makePhoneCall(
                                                      'tel:${snapshot.data['phoneNo']}');
                                                });
                                              },
                                              icon: Icon(Icons.phone)),
                                        ],
                                      );
                                    }
                                  }),
                              R.sizedBox.sizedBox1h(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Payment status ${orderVm.streamOrder?.paymentStatus == 0 ? 'Not Paid' : orderVm.streamOrder?.paymentStatus == 1 ? 'Bill Exported' : 'Paid'}',
                                    style:
                                        R.textStyles.poppinsTitle1().copyWith(
                                              fontSize: 12.sp,
                                            ),
                                  ),
                                  StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("chats")
                                        .where('roomId',
                                            isEqualTo: widget.order.id)
                                        .where('receiver',
                                            isEqualTo: model.appUser?.email)
                                        .where('isSeen', isEqualTo: false)
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) {
                                        return SizedBox();
                                      } else if (snapshot.data!.docs.isEmpty) {
                                        return IconButton(
                                            onPressed: () {
                                              Get.to(() => ChatView(
                                                    price: widget.order.price,
                                                    peerId:
                                                        widget.order.carrierId,
                                                    orderId: (orderVm
                                                        .streamOrder?.id)!,
                                                  ));
                                            },
                                            icon: Image.asset(
                                                R.images.commentIcon));
                                      } else {
                                        return Badge(
                                          position: BadgePosition.topEnd(
                                              end: 0, top: 6),
                                          badgeContent: Text(
                                            '${snapshot.data!.docs.length}',
                                            style: R.textStyles
                                                .robotoRegular()
                                                .copyWith(
                                                    fontSize: 8,
                                                    color: R.colors.white),
                                          ),
                                          child: IconButton(
                                              onPressed: () {
                                                Get.to(() => ChatView(
                                                      price: widget.order.price,
                                                      peerId: widget
                                                          .order.carrierId,
                                                      orderId: (orderVm
                                                          .streamOrder?.id)!,
                                                    ));
                                              },
                                              icon: Image.asset(
                                                  R.images.commentIcon)),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              R.sizedBox.sizedBox1h(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Pick up order",
                                    style: R.textStyles
                                        .poppinsHeading1()
                                        .copyWith(fontSize: 12.sp),
                                  ),
                                  Text(
                                    widget.order.pickAddress ?? "",
                                    style: R.textStyles.robotoMedium(),
                                  ),
                                ],
                              ),
                              R.sizedBox.sizedBox1h(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Deliver to",
                                    style: R.textStyles
                                        .poppinsHeading1()
                                        .copyWith(fontSize: 12.sp),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.order.dropAddress ?? "",
                                      style: R.textStyles.robotoMedium(),
                                    ),
                                  ),
                                ],
                              ),
                              R.sizedBox.sizedBox1h(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Distance",
                                        style: R.textStyles
                                            .poppinsHeading1()
                                            .copyWith(fontSize: 12.sp),
                                      ),
                                      R.sizedBox.sizedBox3w(),
                                      Text(
                                        resultLine[0]
                                                .distanceTime
                                                ?.distance
                                                ?.text ??
                                            "",
                                        style: R.textStyles.robotoMedium(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Duration",
                                        style: R.textStyles
                                            .poppinsHeading1()
                                            .copyWith(fontSize: 12.sp),
                                      ),
                                      R.sizedBox.sizedBox3w(),
                                      Text(
                                        resultLine[0]
                                                .distanceTime
                                                ?.duration
                                                ?.text ??
                                            "",
                                        style: R.textStyles.robotoMedium(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              R.sizedBox.sizedBox1h(),
                              statusWidget(orderVm, model),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
          // floatingActionButton: FloatingActionButton.extended(
          //   onPressed: _goStore,
          //   label: const Text('To the Store!'),
          //   icon: const Icon(Icons.store),
          // ),
        ),
      );
    });
  }

  Future<void> _goStore() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kStore));
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> goToPickup(Order order, AuthVM authVm) async {
    setState(() {
      isLoading = true;
    });
    await FBCollections.orders.doc(order.id).update({
      'status': OrderStatus.goingToPickup.index,
    });
    AppNotification notify = AppNotification(
        title: "going for pickup",
        message:
            "${authVm.appUser?.fullName}  is going to pickup your order no ${order.id}",
        isSeen: false,
        notificationType: NotificationType.goingToPickup,
        sender: authVm.appUser?.email,
        receiver: order.customerId,
        createdAt: Timestamp.now());
    await fbNotification.notifyUser(notify, sendPush: true, sendInApp: true);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> pickOrder(Order order, authVm) async {
    setState(() {
      isLoading = true;
    });
    await FBCollections.orders.doc(order.id).update({
      'status': OrderStatus.pickedFood.index,
    });
    AppNotification notify = AppNotification(
        title: "Picked your order",
        message:
            "${authVm.appUser?.fullName} has pickup your order no ${order.id}",
        isSeen: false,
        notificationType: NotificationType.pickedFood,
        sender: authVm.appUser?.email,
        receiver: order.customerId,
        createdAt: Timestamp.now());
    await fbNotification.notifyUser(notify, sendPush: true, sendInApp: true);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deliverOrder(Order order, authVm) async {
    setState(() {
      isLoading = true;
    });
    await FBCollections.orders.doc(order.id).update({
      'status': OrderStatus.delivered.index,
    });
    await FBCollections.users.doc(order.carrierId).update({
      'onRide': false,
    });
    authVm.appUser?.onRide = false;
    authVm.update();
    AppNotification notify = AppNotification(
        title: "Order Delivered",
        message: "${authVm.appUser?.fullName}  has delivered your order",
        isSeen: false,
        notificationType: NotificationType.delivered,
        sender: authVm.appUser?.email,
        receiver: order.customerId,
        createdAt: Timestamp.now());
    await fbNotification.notifyUser(notify, sendPush: true, sendInApp: true);
    setState(() {
      isLoading = false;
    });
    Get.offAll(SuccessPage(
      title: 'Order Delivered \nSuccessfully',
    ));
  }

  Future<void> cancelOrder(Order order, authVm) async {
    setState(() {
      isLoading = true;
    });
    await FBCollections.orders.doc(order.id).update({
      'status': OrderStatus.canceled.index,
    });
    AppNotification notify = AppNotification(
        title: "Order Canceled",
        message: "${authVm.appUser?.fullName}  has canceled your order",
        isSeen: false,
        notificationType: NotificationType.canceledOrder,
        sender: authVm.appUser?.email,
        receiver: order.customerId,
        createdAt: Timestamp.now());
    await fbNotification.notifyUser(notify, sendPush: true, sendInApp: true);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> cancelOrderByCustomer(Order order, authVm) async {
    setState(() {
      isLoading = true;
    });
    await FBCollections.orders.doc(order.id).update({
      'status': OrderStatus.canceled.index,
    });
    AppNotification notify = AppNotification(
        title: "Order Canceled",
        message: "${authVm.appUser?.fullName}  has canceled your order",
        isSeen: false,
        notificationType: NotificationType.canceledOrder,
        sender: authVm.appUser?.email,
        receiver: order.carrierId,
        createdAt: Timestamp.now());
    await fbNotification.notifyUser(notify, sendPush: true, sendInApp: true);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> reachDropLocation(Order order, authVm) async {
    setState(() {
      isLoading = true;
    });
    await FBCollections.orders.doc(order.id).update({
      'status': OrderStatus.arrivedAtDrop.index,
    });
    AppNotification notify = AppNotification(
        title: "Arrived at drop",
        message: "${authVm.appUser?.fullName}  have arrived at pickup location",
        isSeen: false,
        notificationType: NotificationType.arrivedAtDrop,
        sender: authVm.appUser?.email,
        receiver: order.customerId,
        createdAt: Timestamp.now());
    await fbNotification.notifyUser(notify, sendPush: true, sendInApp: true);
    setState(() {
      isLoading = false;
    });
  }

  Widget statusWidget(OrderVM orderVM, AuthVM authVm) {
    switch (orderVM.streamOrder?.status) {
      case 1:
        return Row(
          children: [
            Expanded(
              child: MyButton(
                  onTap: () {
                    goToPickup(orderVM.streamOrder!, authVm);
                  },
                  buttonText: "Go To Pickup"),
            ),
            R.sizedBox.sizedBox3w(),
            Expanded(
              child: MyButton(
                  onTap: () {
                    Get.bottomSheet(
                      AcceptRejectSheet(
                        accept: false,
                        cancel: true,
                        onTap: () async {
                          Get.back();
                          await cancelOrder(widget.order, authVm);
                        },
                      ),
                    );
                  },
                  buttonText: "Cancel"),
            )
          ],
        );
      case 2:
        return Row(
          children: [
            Expanded(
              child: MyButton(
                  onTap: () {
                    pickOrder(orderVM.streamOrder!, authVm);
                  },
                  buttonText: "Pick Order"),
            ),
            R.sizedBox.sizedBox3w(),
            Expanded(
              child: MyButton(
                  onTap: () {
                    cancelOrder(orderVM.streamOrder!, authVm);
                  },
                  buttonText: "Cancel"),
            )
          ],
        );
      case 3:
        return MyButton(
            onTap: () {
              reachDropLocation(orderVM.streamOrder!, authVm);
            },
            buttonText: "I have Arrived");
      case 4:
        return MyButton(
            onTap: () {
              switch (orderVM.streamOrder?.paymentStatus) {
                case 0:
                  ShowMessage.toast('Please export bill to customer first');
                  break;
                case 1:
                  ShowMessage.toast('Please ask customer to pay bill first');
                  break;
                case 2:
                  deliverOrder(orderVM.streamOrder!, authVm);
                  break;
              }
            },
            buttonText: "Delivered");
      case 5:
        return StreamBuilder(
          stream: FBCollections.ratings
              .where('rate_by', isEqualTo: authVm.appUser?.email)
              .where('order_id', isEqualTo: orderVM.streamOrder?.id)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: MyLoader(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyButton(onTap: () {}, buttonText: "Delivered"),
                  MyButton(
                      onTap: () {
                        Get.to(() => RateUser(
                              orderId: orderVM.streamOrder?.id,
                              userId: orderVM.streamOrder?.customerId,
                            ));
                      },
                      buttonText: "Rate Customer")
                ],
              );
            } else {
              return Column(
                children: [
                  MyButton(onTap: () {}, buttonText: "Delivered"),
                  RatingBar.builder(
                    ignoreGestures: true,
                    initialRating:
                        double.parse('${snapshot.data!.docs[0]['rating']}'),
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                  )
                ],
              );
            }
          },
        );

      default:
        return SizedBox();
    }
  }
}
