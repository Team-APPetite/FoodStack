// Unused class, for user profile

class User {
  String firstName;
  String lastName;
  String email;
  String password;

  User({this.firstName, this.lastName, this.email, this.password});

  String getFullName() {
    return firstName + lastName;
  }
}
