class LeadListModel {
  List<LeadData>? data;
  Meta? meta;

  LeadListModel({this.data, this.meta});

  LeadListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <LeadData>[];
      json['data'].forEach((v) {
        data!.add(new LeadData.fromJson(v));
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

class LeadData {
  String? date;
  List<Leads>? leads;

  LeadData({this.date, this.leads});

  LeadData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['leads'] != null) {
      leads = <Leads>[];
      json['leads'].forEach((v) {
        leads!.add(new Leads.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.leads != null) {
      data['leads'] = this.leads!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Leads {
  int? id;
  String? companyName;
  String? fullName;
  int? mobileNo;
  int? createdBy;
  String? assignedBy;
  String? assignedId;
  String? source;
  dynamic specifier;
  String? followupDate;
  dynamic followupTime;
  String? assignedTo;
  String? priority;
  String? address;
  String? city;
  String? state;
  dynamic pincode;
  String? notes;
  String? status;
  List<Records>? records;

  Leads(
      {this.id,
        this.companyName,
        this.fullName,
        this.mobileNo,
        this.createdBy,
        this.assignedBy,
        this.assignedId,
        this.source,
        this.specifier,
        this.followupDate,
        this.followupTime,
        this.assignedTo,
        this.priority,
        this.address,
        this.city,
        this.state,
        this.pincode,
        this.notes,
        this.status,
        this.records});

  Leads.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    fullName = json['full_name'];
    mobileNo = json['mobile_no'];
    createdBy = json['created_by'];
    assignedBy = json['assigned_by'];
    assignedId = json['assigned_id'];
    source = json['source'];
    specifier = json['specifier'];
    followupDate = json['followup_date'];
    followupTime = json['followup_time'];
    assignedTo = json['assigned_to'];
    priority = json['priority'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    notes = json['notes'];
    status = json['status'];
    if (json['records'] != null) {
      records = <Records>[];
      json['records'].forEach((v) {
        records!.add(new Records.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_name'] = this.companyName;
    data['full_name'] = this.fullName;
    data['mobile_no'] = this.mobileNo;
    data['created_by'] = this.createdBy;
    data['assigned_by'] = this.assignedBy;
    data['assigned_id'] = this.assignedId;
    data['source'] = this.source;
    data['specifier'] = this.specifier;
    data['followup_date'] = this.followupDate;
    data['followup_time'] = this.followupTime;
    data['assigned_to'] = this.assignedTo;
    data['priority'] = this.priority;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['notes'] = this.notes;
    data['status'] = this.status;
    if (this.records != null) {
      data['records'] = this.records!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Records {
  int? id;
  int? leadId;
  int? employeeId;
  String? comment;
  int? assignedTo;
  String? datetime;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? empName;

  Records(
      {this.id,
        this.leadId,
        this.employeeId,
        this.comment,
        this.assignedTo,
        this.datetime,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.empName
      });

  Records.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leadId = json['lead_id'];
    employeeId = json['employee_id'];
    comment = json['comment'];
    assignedTo = json['assigned_to'];
    datetime = json['datetime'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    empName = json['employee_name'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lead_id'] = this.leadId;
    data['employee_id'] = this.employeeId;
    data['comment'] = this.comment;
    data['assigned_to'] = this.assignedTo;
    data['datetime'] = this.datetime;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['employee_name'] = this.empName;

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