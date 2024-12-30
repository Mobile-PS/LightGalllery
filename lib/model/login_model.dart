class LoginModel {
  Data? data;
  Meta? meta;

  LoginModel({this.data, this.meta});

  LoginModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int? id;
  String? uId;
  String? fullName;
  int? mobileNo;
  String? email;
  String? gender;
  String? designation;
  dynamic dob;
  dynamic fatherName;
  dynamic motherName;
  dynamic address;
  dynamic state;
  String? dswp;
  dynamic city;
  dynamic pincode;
  dynamic panNo;
  dynamic aadhaarNo;
  String? password;
  String? image;
  String? status;
  String? apiToken;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  Data(
      {this.id,
        this.uId,
        this.fullName,
        this.mobileNo,
        this.email,
        this.gender,
        this.designation,
        this.dob,
        this.fatherName,
        this.motherName,
        this.address,
        this.state,
        this.dswp,
        this.city,
        this.pincode,
        this.panNo,
        this.aadhaarNo,
        this.password,
        this.image,
        this.status,
        this.apiToken,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uId = json['u_id'];
    fullName = json['full_name'];
    mobileNo = json['mobile_no'];
    email = json['email'];
    gender = json['gender'];
    designation = json['designation'];
    dob = json['dob'];
    fatherName = json['father_name'];
    motherName = json['mother_name'];
    address = json['address'];
    state = json['state'];
    dswp = json['dswp'];
    city = json['city'];
    pincode = json['pincode'];
    panNo = json['pan_no'];
    aadhaarNo = json['aadhaar_no'];
    password = json['password'];
    image = json['image'];
    status = json['status'];
    apiToken = json['api_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['u_id'] = this.uId;
    data['full_name'] = this.fullName;
    data['mobile_no'] = this.mobileNo;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['designation'] = this.designation;
    data['dob'] = this.dob;
    data['father_name'] = this.fatherName;
    data['mother_name'] = this.motherName;
    data['address'] = this.address;
    data['state'] = this.state;
    data['dswp'] = this.dswp;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['pan_no'] = this.panNo;
    data['aadhaar_no'] = this.aadhaarNo;
    data['password'] = this.password;
    data['image'] = this.image;
    data['status'] = this.status;
    data['api_token'] = this.apiToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Meta {
  String? token;
  String? status;
  String? message;

  Meta({this.token, this.status, this.message});

  Meta.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}