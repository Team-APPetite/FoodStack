// Unused class, for user profile

class User {
  String _firstName;
  String _lastName;
  String _username;
  String _password;

  User(String _first, String _last, String _email, String _pass) {
    _firstName = _first;
    _lastName = _last;
    _username = _email;
    _password = _pass;
  }

  String getFullName() {
    return _firstName + _lastName;
  }
}