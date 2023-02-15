import 'package:flutter/cupertino.dart';
import 'package:kcds/src/location/model/location_model.dart';

class RoomProvider extends ChangeNotifier {
  List<Detail> _selectedRoom = [];
  String selectedBuilding = "";
  String selectedHallway = "";
  String selectedFloor = "";
  int _selectedStore = 0;

  get selectedRoom => _selectedRoom;
  set selectedRoom(value) {
    _selectedRoom = value;
  }

  get selectedStore => _selectedStore;
  set selectedStore(value) {
    _selectedStore = value;
  }

  void update() {
    notifyListeners();
  }
}
