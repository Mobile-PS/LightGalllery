class ProjectTaskListModel {
  List<ProjectData>? data;
  Meta? meta;

  ProjectTaskListModel({this.data, this.meta});

  ProjectTaskListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ProjectData>[];
      json['data'].forEach((v) {
        data!.add(new ProjectData.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class ProjectData {
  int? id;
  String? title;
  String? description;
  String? createdBy;
  String? date;
  String? priority;
  String? status;

  ProjectData(
      {this.id,
        this.title,
        this.description,
        this.createdBy,
        this.date,
        this.priority,
        this.status});

  ProjectData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    createdBy = json['created_by'];
    date = json['date'];
    priority = json['priority'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['created_by'] = this.createdBy;
    data['date'] = this.date;
    data['priority'] = this.priority;
    data['status'] = this.status;
    return data;
  }
}

class Meta {
  String? status;
  String? message;

  Meta({this.status, this.message});

  Meta.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}