class ProjectListModel {
  List<ProjectData>? data;
  Meta? meta;

  ProjectListModel({this.data, this.meta});

  ProjectListModel.fromJson(Map<String, dynamic> json) {
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
  String? priority;
  String? status;
  int? taskStatus;
  String? assign_to;
  String? assign_to_names;

  ProjectData(
      {this.id,
        this.title,
        this.description,
        this.createdBy,
        this.priority,
        this.status,
        this.taskStatus,
        this.assign_to,
        this.assign_to_names
      });

  ProjectData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    createdBy = json['created_by'];
    priority = json['priority'];
    status = json['status'];
    taskStatus = json['task_status'];
    assign_to = json['assign_to'];
    assign_to_names = json['assign_to_names'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['created_by'] = this.createdBy;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['task_status'] = this.taskStatus;
    data['assign_to'] = this.assign_to;
    data['assign_to_names'] = this.assign_to_names;

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