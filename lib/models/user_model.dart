class UserModel {
  final String name;
  final String uid;
  final String profilePic;
  final bool isOnline;
  final String phoneNumber;
  final List<String> groupId;
  final String? state;
  final String? cityDistrict;
  final String? designation;
  final String? profession;

  UserModel({
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.isOnline,
    required this.phoneNumber,
    required this.groupId,
    required this.state,
    required this.cityDistrict,
    required this.designation,
    required this.profession,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
      'state': state,
      'cityDistrict': cityDistrict,
      'designation': designation,
      'profession': profession,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'] ?? '',
      isOnline: map['isOnline'] ?? false,
      phoneNumber: map['phoneNumber'] ?? '',
      groupId: List<String>.from(map['groupId']),
      state: map['state'] ?? '',
      cityDistrict: map['cityDistrict'] ?? '',
      designation: map['designation'] ?? '',
      profession: map['profession'] ?? '',
    );
  }
  @override
  String toString() {
    return toMap().toString();
  }
}



