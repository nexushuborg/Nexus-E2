class SignupData {
  String? fullName;
  String? gender;
  String? email;
  String? password;
  String? regNo;
  String? slno;
  String? phoneNo;
  String? degree;
  String? branch;
  int? batch;

  SignupData({
    this.fullName,
    this.gender,
    this.email,
    this.password,
    this.regNo,
    this.slno,
    this.phoneNo,
    this.degree,
    this.branch,
    this.batch,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'password': password,
      'reg_no': regNo,
      'slno': slno != null ? int.parse(slno!) : null,
      'email': email,
      'phoneNo': phoneNo,
      'degree': degree,
      'branch': branch,
      'batch': batch,
      'gender': gender, // Already converted to lowercase when setting
    };
  }

  factory SignupData.fromJson(Map<String, dynamic> json) {
    return SignupData(
      fullName: json['full_name'],
      gender: json['gender'],
      email: json['email'],
      password: json['password'],
      regNo: json['reg_no'],
      slno: json['slno']?.toString(),
      phoneNo: json['phoneNo'],
      degree: json['degree'],
      branch: json['branch'],
      batch: json['batch'],
    );
  }
}
