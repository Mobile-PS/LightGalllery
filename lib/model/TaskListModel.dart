class TaskListModel {
  List<TaskData>? data;
  Meta? meta;

  TaskListModel({this.data, this.meta});

  TaskListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TaskData>[];
      json['data'].forEach((v) {
        data!.add(new TaskData.fromJson(v));
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

class TaskData {
  String? date;
  List<Tasks>? tasks;

  TaskData({this.date, this.tasks});

  TaskData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['tasks'] != null) {
      tasks = <Tasks>[];
      json['tasks'].forEach((v) {
        tasks!.add(new Tasks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.tasks != null) {
      data['tasks'] = this.tasks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tasks {
  int? id;
  String? title;
  String? description;
  String? createdBy;
  String? date;
  String? datetime;
  String? dueDate;
  String? assignedTo;
  String? priority;
  String? specificday;
  String? status;
  String? repeat;
  String? repeatType;
  String? repeatTime;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? assignedid;
  String? assignedBy;

  Tasks(
      {this.id,
        this.title,
        this.description,
        this.createdBy,
        this.date,
        this.datetime,
        this.dueDate,
        this.assignedTo,
        this.priority,
        this.specificday,
        this.status,
        this.repeat,
        this.repeatType,
        this.repeatTime,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.assignedid,
        this.assignedBy
      });

  Tasks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    createdBy = json['created_by'];
    date = json['date'];
    datetime = json['datetime'];
    dueDate = json['due_date'];
    assignedTo = json['assigned_to'];
    priority = json['priority'];
    specificday = json['specificday'];
    status = json['status'];
    repeat = json['repeat'];
    repeatType = json['repeat_type'];
    repeatTime = json['repeat_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    assignedid = json['assigned_id'];
    assignedBy = json['assigned_by'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['created_by'] = this.createdBy;
    data['date'] = this.date;
    data['datetime'] = this.datetime;
    data['due_date'] = this.dueDate;
    data['assigned_to'] = this.assignedTo;
    data['priority'] = this.priority;
    data['specificday'] = this.specificday;
    data['status'] = this.status;
    data['repeat'] = this.repeat;
    data['repeat_type'] = this.repeatType;
    data['repeat_time'] = this.repeatTime;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['assigned_id'] = this.assignedid;
    data['assigned_by'] = this.assignedBy;

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