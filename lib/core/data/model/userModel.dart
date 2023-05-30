class UserModel {
  final String name;
  final String dob;
  final String email;
  final String phone;
  final String imageLink;
  UserModel(
      {required this.dob,
      required this.email,
      required this.imageLink,
      required this.name,
      required this.phone});
}
