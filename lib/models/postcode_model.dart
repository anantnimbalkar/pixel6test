
class PostCodeModel {
  String? status;
  int? statusCode;
  int? postcode;
  List<City>? city;
  List<State>? state;

  PostCodeModel({this.status, this.statusCode, this.postcode, this.city, this.state});

  PostCodeModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    statusCode = json["statusCode"];
    postcode = json["postcode"];
    city = json["city"] == null ? null : (json["city"] as List).map((e) => City.fromJson(e)).toList();
    state = json["state"] == null ? null : (json["state"] as List).map((e) => State.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["statusCode"] = statusCode;
    _data["postcode"] = postcode;
    if(city != null) {
      _data["city"] = city?.map((e) => e.toJson()).toList();
    }
    if(state != null) {
      _data["state"] = state?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class State {
  int? id;
  String? name;

  State({this.id, this.name});

  State.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    return _data;
  }
}

class City {
  int? id;
  String? name;

  City({this.id, this.name});

  City.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    return _data;
  }
}