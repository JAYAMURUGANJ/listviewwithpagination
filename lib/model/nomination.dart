class NominationDetails {
  int? nominationId;
  String? examName;
  int? departmentId;
  int? postId;
  int? categoryId;
  String? effortFromDate;
  String? effectToDate;
  List<Pdfs>? pdfs;

  NominationDetails(
      {this.nominationId,
      this.examName,
      this.departmentId,
      this.postId,
      this.categoryId,
      this.effortFromDate,
      this.effectToDate,
      this.pdfs});

  NominationDetails.fromJson(Map<String, dynamic> json) {
    nominationId = json['nomination_id'];
    examName = json['exam_name'];
    departmentId = json['department_id'];
    postId = json['post_id'];
    categoryId = json['category_id'];
    effortFromDate = json['effort_from_date'];
    effectToDate = json['effect_to_date'];
    if (json['pdfs'] != null) {
      pdfs = <Pdfs>[];
      json['pdfs'].forEach((v) {
        pdfs!.add(new Pdfs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nomination_id'] = this.nominationId;
    data['exam_name'] = this.examName;
    data['department_id'] = this.departmentId;
    data['post_id'] = this.postId;
    data['category_id'] = this.categoryId;
    data['effort_from_date'] = this.effortFromDate;
    data['effect_to_date'] = this.effectToDate;
    if (this.pdfs != null) {
      data['pdfs'] = this.pdfs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pdfs {
  int? nominationChildId;
  int? nominationId;
  String? pdfName;
  String? attachment;
  int? status;

  Pdfs(
      {this.nominationChildId,
      this.nominationId,
      this.pdfName,
      this.attachment,
      this.status});

  Pdfs.fromJson(Map<String, dynamic> json) {
    nominationChildId = json['nomination_child_id'];
    nominationId = json['nomination_id'];
    pdfName = json['pdf_name'];
    attachment = json['attachment'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nomination_child_id'] = this.nominationChildId;
    data['nomination_id'] = this.nominationId;
    data['pdf_name'] = this.pdfName;
    data['attachment'] = this.attachment;
    data['status'] = this.status;
    return data;
  }
}
