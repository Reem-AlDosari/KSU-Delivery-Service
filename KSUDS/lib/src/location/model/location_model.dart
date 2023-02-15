import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

const university = [
  {
    "label": "university",
    "lat": 12.0,
    "long": 12.0,
    "id": "u1",
    "level": 0,
    "selected": 0
  }
];
const building = [
  {
    "label": "College of Computer",
    "lat": 24.723353960500027,
    "long": 46.63682819868038,
    "id": "b1",
    "pid": "u1",
    "level": 1,
    "underLevel": 2,
    "selected": 0
  },
  {
    "label": "College of Medicine",
    "lat": 24.72412625311403,
    "long": 46.63825133502794,
    "id": "b2",
    "pid": "u1",
    "level": 1,
    "underLevel": 2,
    "selected": 0
  },
  {
    "label": "College of Nursing",
    "lat": 24.723374672807104,
    "long": 46.63791246889696,
    "id": "b3",
    "pid": "u1",
    "level": 1,
    "underLevel": 2,
    "selected": 0
  },
];
const hallway = [
  {
    "label": "Floors",
    "lat": 24.723353960500027,
    "long": 46.63682819868038,
    "id": "h1",
    "pid": "b1",
    "level": 2,
    "underLevel": 3,
    "selected": 0
  },
  {
    "label": "Floors",
    "lat": 24.72412625311403,
    "long": 46.63825133502794,
    "id": "h2",
    "pid": "b2",
    "level": 2,
    "underLevel": 3,
    "selected": 0
  },
  {
    "label": "Floors",
    "lat": 24.723374672807104,
    "long": 46.63791246889696,
    "id": "h3",
    "pid": "b3",
    "level": 2,
    "underLevel": 4,
    "selected": 0
  },
];
const rows = [
  {
    "label": "Floor-G",
    "lat": 24.723353960500027,
    "long": 46.63682819868038,
    "id": "r1",
    "pid": "h1",
    "level": 3,
    "underLevel": 4,
    "selected": 0
  },
  {
    "label": "Floor-1",
    "lat": 24.723353960500027,
    "long": 46.63682819868038,
    "id": "r1",
    "pid": "h1",
    "level": 3,
    "underLevel": 4,
    "selected": 0
  },
  {
    "label": "Floor-2",
    "lat": 24.723353960500027,
    "long": 46.63682819868038,
    "id": "r1",
    "pid": "h1",
    "level": 3,
    "underLevel": 4,
    "selected": 0
  },
  {
    "label": "Floor-G",
    "lat": 24.72412625311403,
    "long": 46.63825133502794,
    "id": "r2",
    "pid": "h2",
    "level": 3,
    "underLevel": 4,
    "selected": 0
  },
  {
    "label": "Floor-1",
    "lat": 24.72412625311403,
    "long": 46.63825133502794,
    "id": "r2",
    "pid": "h2",
    "level": 3,
    "underLevel": 4,
    "selected": 0
  },
  {
    "label": "Floor-2",
    "lat": 24.72412625311403,
    "long": 46.63825133502794,
    "id": "r2",
    "pid": "h2",
    "level": 3,
    "underLevel": 4,
    "selected": 0
  },
  {
    "label": "Floor-g",
    "lat": 24.723374672807104,
    "long": 46.63791246889696,
    "id": "r3",
    "pid": "h3",
    "level": 3,
    "underLevel": 4,
    "selected": 0
  },
  {
    "label": "Floor-1",
    "lat": 24.723374672807104,
    "long": 46.63791246889696,
    "id": "r3",
    "pid": "h3",
    "level": 3,
    "underLevel": 4,
    "selected": 0
  },
  {
    "label": "Floor-2",
    "lat": 24.723374672807104,
    "long": 46.63791246889696,
    "id": "r3",
    "pid": "h3",
    "level": 3,
    "underLevel": 4,
    "selected": 0
  },
];

const fixPosition = [
  {
    "label": "Dunkin' Donuts",
    "lat": 24.72436116827677,
    "long": 46.63655713656367,
    "id": "fixed1",
    "pid": "r1",
    "level": 4,
    "underLevel": -1,
    "selected": 0
  },
  {
    "label": "Subway",
    "lat": 24.72874666614328,
    "long": 46.636161305505986,
    "id": "fixed2",
    "pid": "r1",
    "level": 4,
    "underLevel": -1,
    "selected": 0
  },
];

class Detail {
  String? label;
  double? lat;
  double? long;
  String? id;
  String? pid;
  int? level;
  int? underLevel;
  int? selected;

  Detail(
      {this.label,
      this.lat,
      this.long,
      this.id,
      this.pid,
      this.level,
      this.underLevel,
      this.selected});

  Detail.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    lat = json['lat'];
    long = json['long'];
    id = json['id'];
    pid = json['pid'];
    level = json['level'];
    underLevel = json['underLevel'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['id'] = this.id;
    data['pid'] = this.pid;
    data['level'] = this.level;
    data['underLevel'] = this.underLevel;
    data['selected'] = this.selected;
    return data;
  }
}

class GetRouteByMap {
  static const String base_url_of_map =
      "https://maps.googleapis.com/maps/api/directions/json?alternatives=true&key=AIzaSyDSWRJiMePnSP3XAITuPxMoVjq7nyZojXw";
  Future<List<EachLine>> getRoutesList(
      LatLng _originlatlng, LatLng _destinationlatlng, String mode) async {
    String _origin = "${_originlatlng.latitude},${_originlatlng.longitude}";
    String _destination =
        "${_destinationlatlng.latitude},${_destinationlatlng.longitude}";
    List<List<LatLng>> _latlnglist = [];
    List<DistanceTime> distanceTime = [];
    List<EachLine> resultLine = [];
    String endpoint = "&origin=$_origin&destination=$_destination&mode=$mode";
    String url = base_url_of_map + endpoint;
    print(url);
    try {
      var response = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json"
      }); // http request to get route info
      Map data = json.decode(response.body);
      print(["response.body:", response.body]);
      for (var route in data["routes"]) {
        List<LatLng> _oneroutelatlngs = [];

        //getting route points from hashcode
        _oneroutelatlngs =
            _convertToLatLng(_decodePoly(route['overview_polyline']['points']));
        _latlnglist.add(_oneroutelatlngs);
        print(["tmpDisTime:", route['legs'].length]);
        DistanceTime tmpDisTime =
            DistanceTime.fromJson(jsonDecode(jsonEncode(route['legs'][0])));
        print(["tmpDisTime:", tmpDisTime.toJson()]);
        distanceTime.add(tmpDisTime);
        EachLine tmpEachLine =
            EachLine(distanceTime: tmpDisTime, points: _oneroutelatlngs);
        resultLine.add(tmpEachLine);
      }
    } catch (e) {
      print(e.toString());
    }
    return resultLine;
  }

//getting routes points from hashcode
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = [];
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];
    return lList;
  }

//getting LatLng from points
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }
}

class DistanceTime {
  Distance? distance;
  Distance? duration;

  DistanceTime({this.distance, this.duration});

  DistanceTime.fromJson(Map<String, dynamic> json) {
    distance = json['distance'] != null
        ? new Distance.fromJson(json['distance'])
        : null;
    duration = json['duration'] != null
        ? new Distance.fromJson(json['duration'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.distance != null) {
      data['distance'] = this.distance!.toJson();
    }
    if (this.duration != null) {
      data['duration'] = this.duration!.toJson();
    }
    return data;
  }
}

class Distance {
  String? text;
  int? value;

  Distance({this.text, this.value});

  Distance.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['value'] = this.value;
    return data;
  }
}

class EachLine {
  DistanceTime? distanceTime;
  List<LatLng>? points;

  EachLine({this.distanceTime, this.points});
}
