class UserModel {
  final String id, fname, lname, phonenumber, district, state, country;
  final int updatedAt,isSynced,isDeleted;

  UserModel({
    required this.id,
    required this.fname,
    required this.lname,
    required this.phonenumber,
    required this.district,
    required this.state,
    required this.country,
    required this.updatedAt,
    required this.isSynced,
    required this.isDeleted,
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
      'updatedAt' : updatedAt,
      'isSynced' : isSynced,
      'isDeleted' : isDeleted
    };
  }

  factory UserModel.fromMap(
  Map<String, dynamic> data, {
  String? docId,
}) {
  return UserModel(
    id: (data['id'] as String?)?.isNotEmpty == true
        ? data['id']
        : (docId ?? ''),
    fname: data['fname']?.toString() ?? '',
    lname: data['lname']?.toString() ?? '',
    phonenumber: data['phonenumber']?.toString() ?? '',
    district: data['district']?.toString() ?? '',
    state: data['state']?.toString() ?? '',
    country: data['country']?.toString() ?? '',
    updatedAt: data['updatedAt'] is int ? data['updatedAt'] : 0,
    isSynced: data['isSynced'] is int ? data['isSynced'] : 0,
    isDeleted: data['isDeleted'] is int ? data['isDeleted'] : 0,
  );
}



  UserModel copyWith({
    String? id,
    String? fname,
    String? lname,
    String? phonenumber,
    String? district,
    String? state,
    String? country,
    int? updatedAt,
    int? isSynced,
    int? isDeleted,
  }) {
    return UserModel(
      id: id ?? this.id,
      fname: fname ?? this.fname,
      lname: lname ?? this.lname,
      phonenumber: phonenumber ?? this.phonenumber,
      district: district ?? this.district,
      state: state ?? this.state,
      country: country ?? this.country,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
