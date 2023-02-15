import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kcds/utils/show_message.dart';
import 'package:provider/provider.dart';

import '../model/location_model.dart';
import '../view_model/location_viewmodal.dart';
import 'location_map.dart';

class LocationView extends StatefulWidget {
  static String route = '/location';

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  List<Detail> buildingM = [];
  List<Detail> hallwayM = [];
  List<Detail> rowsM = [];
  List<Detail> roomsM = [];
  List<Detail> selectedRooms = [];
  double sysWidth = 0.0;
  String roomName = "";
  String selectedBuilding = "";
  String selectedHallway = "";
  String selectedFloor = "";
  Detail? pickedRoom;
  Detail? selectedRow;

  late RoomProvider _roomProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _roomProvider = Provider.of<RoomProvider>(context, listen: false);

    print(_roomProvider.selectedRoom.length);

    for (var element in building) {
      buildingM.add(Detail.fromJson(element));
    }
    for (var element in hallway) {
      hallwayM.add(Detail.fromJson(element));
    }
    for (var element in rows) {
      rowsM.add(Detail.fromJson(element));
    }
  }

  @override
  Widget build(BuildContext context) {
    sysWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Location View"),
        backgroundColor: Color(0xff78BBD5),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ...buildingM
                      .asMap()
                      .map((key, valueB) => MapEntry(
                          key,
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    buildingM[key].selected == 0
                                        ? buildingM[key].selected = 1
                                        : buildingM[key].selected = 0;
                                    _roomProvider.selectedBuilding =
                                        valueB.label.toString();
                                    _roomProvider.update();
                                  });
                                },
                                child: Container(
                                    width: sysWidth,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey,
                                                style: BorderStyle.solid,
                                                width: 1))),
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: Row(
                                      children: [
                                        Icon(Icons.home_filled),
                                        Text(valueB.label.toString(),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.black))
                                      ],
                                    )),
                              ),
                              valueB.selected != 1
                                  ? SizedBox(height: 0)
                                  : Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          25, 5, 0, 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ...hallwayM
                                              .asMap()
                                              .map((key, valueC) => MapEntry(
                                                  key,
                                                  valueC.pid != valueB.id
                                                      ? Container()
                                                      : Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  hallwayM[key]
                                                                              .selected ==
                                                                          0
                                                                      ? hallwayM[key]
                                                                              .selected =
                                                                          1
                                                                      : hallwayM[
                                                                              key]
                                                                          .selected = 0;
                                                                });
                                                                _roomProvider
                                                                        .selectedHallway =
                                                                    valueC.label
                                                                        .toString();
                                                                _roomProvider
                                                                    .update();
                                                              },
                                                              child: Row(
                                                                  children: [
                                                                    Icon(Icons
                                                                        .sensor_door_outlined),
                                                                    Container(
                                                                        child: Text(valueC
                                                                            .label
                                                                            .toString()))
                                                                  ]),
                                                            ),
                                                            valueC.selected != 1
                                                                ? SizedBox(
                                                                    height: 0)
                                                                : Container(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            25,
                                                                            5,
                                                                            0,
                                                                            5),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        ...rowsM
                                                                            .asMap()
                                                                            .map((key, valueD) => MapEntry(
                                                                                key,
                                                                                valueD.pid != valueC.id
                                                                                    ? Container()
                                                                                    : Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          GestureDetector(
                                                                                            onTap: () {
                                                                                              List<Detail> tmpRows = rowsM;
                                                                                              List<Detail> tmpRowss = [];
                                                                                              for (var room in tmpRows) {
                                                                                                room.selected = 0;
                                                                                                tmpRowss.add(room);
                                                                                              }
                                                                                              roomsM = tmpRowss;
                                                                                              rowsM[key].selected = 1;
                                                                                              selectedRow = Detail(label: rowsM[key].label, lat: rowsM[key].lat, long: rowsM[key].long, level: rowsM[key].level, id: rowsM[key].id, pid: rowsM[key].pid);
                                                                                              setState(() {});
                                                                                            },
                                                                                            child: Row(children: [
                                                                                              Icon(Icons.account_tree_outlined),
                                                                                              Container(child: Text(valueD.label.toString()))
                                                                                            ]),
                                                                                          ),
                                                                                          valueD.selected != 1
                                                                                              ? SizedBox(height: 0)
                                                                                              : Container(
                                                                                                  padding: const EdgeInsets.fromLTRB(25, 5, 0, 5),
                                                                                                  child: TextField(
                                                                                                    onChanged: (value) {
                                                                                                      setState(() {
                                                                                                        roomName = value;
                                                                                                      });
                                                                                                    },
                                                                                                    onSubmitted: (value) {
                                                                                                      confirm();
                                                                                                    },
                                                                                                    style: TextStyle(height: 2),
                                                                                                    decoration: InputDecoration(contentPadding: EdgeInsets.all(2)),
                                                                                                  ),
                                                                                                )
                                                                                        ],
                                                                                      )))
                                                                            .values
                                                                            .toList()
                                                                      ],
                                                                    ),
                                                                  )
                                                          ],
                                                        )))
                                              .values
                                              .toList()
                                        ],
                                      ),
                                    )
                            ],
                          )))
                      .values
                      .toList()
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.only(right: 20, bottom: 20),
            child: GestureDetector(
              child: Container(
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedRow != null) {
                      FocusScope.of(context).unfocus();
                      confirm();
                      Get.back();
                    } else {
                      ShowMessage.toast('Please select a building and floor');
                    }
                  },
                  child: Text("Done"),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MapPage()));
        },
        child: Icon(Icons.map),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  confirm() {
    pickedRoom = selectedRow;
    pickedRoom?.label = roomName;
    _roomProvider.selectedRoom = [pickedRoom!];
    _roomProvider.update();
  }
}
