class UserModel {
  final String id, fname, lname, phonenumber, district, state, country;

  UserModel({
    required this.id,
    required this.fname,
    required this.lname,
    required this.phonenumber,
    required this.district,
    required this.state,
    required this.country,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fname': fname,
      'lname': lname,
      'phonenumber': phonenumber,
      'district': district,
      'state': state,
      'country': country,
    };
  }

  factory UserModel.fromDoc(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      fname: data['fname'],
      lname: data['lname'],
      phonenumber: data['phonenumber'],
      district: data['district'],
      state: data['state'],
      country: data['country'],
    );
  }
}
