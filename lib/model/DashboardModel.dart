import 'TaskListModel.dart';

class DashboardModel {
  DashData? data;
  Meta? meta;

  DashboardModel({this.data, this.meta});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new DashData.fromJson(json['data']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class DashData {
  int? openTask;
  int? completedTask;
  int? open_project;
  int? completed_project;
  DashData({this.openTask, this.completedTask,this.open_project,this.completed_project});

  DashData.fromJson(Map<String, dynamic> json) {
    openTask = json['open_task'];
    completedTask = json['completed_task'];
    open_project = json['open_project'];
    completed_project = json['completed_project'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['open_task'] = this.openTask;
    data['completed_task'] = this.completedTask;
    data['open_project'] = this.open_project;
    data['completed_project'] = this.completed_project;

    return data;
  }
}

