
class NoteModel {
  String? id;
  String? title;
  String? description;
  String? time;
  String? timeStamp;

  NoteModel({this.id, this.title, this.description, this.time, this.timeStamp});

  NoteModel.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["title"] is String) {
      title = json["title"];
    }
    if(json["description"] is String) {
      description = json["description"];
    }
    if(json["time"] is String) {
      time = json["time"];
    }
    if(json["timeStamp"] is String) {
      timeStamp = json["timeStamp"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["title"] = title;
    _data["description"] = description;
    _data["time"] = time;
    _data["timeStamp"] = timeStamp;
    return _data;
  }
}