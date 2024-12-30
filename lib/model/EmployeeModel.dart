
class EmployeeModel {
  List<EmpData>? data;
  Meta? meta;

  EmployeeModel({this.data, this.meta});

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <EmpData>[];
      json['data'].forEach((v) {
        data!.add(new EmpData.fromJson(v));
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

class EmpData {
  dynamic uId;
  String? fullName;
  int? mobileNo;
  String? gender;
  String? designation;
  String? createdDate;
  String? status;

  EmpData(
      {this.uId,
        this.fullName,
        this.mobileNo,
        this.gender,
        this.designation,
        this.createdDate,
        this.status});

  EmpData.fromJson(Map<String, dynamic> json) {
    uId = json['id'];
    fullName = json['full_name'];
    mobileNo = json['mobile_no'];
    gender = json['gender'];
    designation = json['designation'];
    createdDate = json['created_date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.uId;
    data['full_name'] = this.fullName;
    data['mobile_no'] = this.mobileNo;
    data['gender'] = this.gender;
    data['designation'] = this.designation;
    data['created_date'] = this.createdDate;
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