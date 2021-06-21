import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/services/userAuth.dart';
import 'package:mockito/mockito.dart';

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User> authStateChanges() {
    return Stream.fromIterable([
      _mockUser,
    ]);
  }
}

void main() {
  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  final UserAuth userAuth = UserAuth(auth: mockFirebaseAuth);
  setUp(() {});
  tearDown(() {});

  group("Login", () {
    test("valid details", () async {
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
            email: "charisma.kausar@gmail.com", password: "123456"),
      ).thenAnswer((realInvocation) => null);

      expect(await userAuth.login("charisma.kausar@gmail.com", "123456"),
          "Success");
    });

    test("empty form", () async {
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(email: "", password: ""),
      ).thenAnswer((realInvocation) =>
          throw FirebaseAuthException(message: "Please fill in your details"));

      expect(await userAuth.login("", ""), "Please fill in your details");
    });

    test("no email address", () async {
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
            email: "", password: "111111"),
      ).thenAnswer((realInvocation) => throw FirebaseAuthException(
          message: "Please enter your email address"));

      expect(await userAuth.login("", "111111"),
          "Please enter your email address");
    });

    test("no password", () async {
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
            email: "appfoodstack@gmail.com", password: ""),
      ).thenAnswer((realInvocation) =>
          throw FirebaseAuthException(message: "Enter password"));

      expect(
          await userAuth.login("appfoodstack@gmail.com", ""), "Enter password");
    });

    test("invalid email address", () async {
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
            email: "appfoodstack", password: "111111"),
      ).thenAnswer((realInvocation) => throw FirebaseAuthException(
          message: "Email address is badly formatted"));

      expect(await userAuth.login("appfoodstack", "111111"),
          "Email address is badly formatted");
    });

    test("invalid password", () async {
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
            email: "charisma.kausar@gmail.com", password: "111111"),
      ).thenAnswer((realInvocation) =>
          throw FirebaseAuthException(message: "Incorrect password"));

      expect(await userAuth.login("charisma.kausar@gmail.com", "111111"),
          "Incorrect password");
    });
  });

  group("Signup", () {

    test("valid details", () async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
            email: "nicole.joseph2122@gmail.com", password: "sample123"),
      ).thenAnswer((realInvocation) => null);

      expect(await userAuth.signup("Nicole", "Joseph", "nicole.joseph2122@gmail.com", "sample123", "sample123"),
          "Success");
    });

    test("empty form", () async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(email: "", password: ""),
      ).thenAnswer((realInvocation) =>
      throw FirebaseAuthException(message: "Please fill in your details"));

      expect(await userAuth.signup("","","","", ""), "Please fill in your details");
    });

    test("no first name", () async  {
      when (
        mockFirebaseAuth.createUserWithEmailAndPassword(email: "nicole.joseph2122@gmail.com", password: "sample123"),
      ).thenAnswer((realInvocation) =>
      throw FirebaseAuthException(message: "Please enter your first name"));

      expect(await userAuth.signup("","Joseph","nicole.joseph2122@gmail.com","sample123", "sample123"), "Please enter your first name");
    });

    test("no last name", () async  {
      when (
        mockFirebaseAuth.createUserWithEmailAndPassword(email: "nicole.joseph2122@gmail.com", password: "sample123"),
      ).thenAnswer((realInvocation) =>
      throw FirebaseAuthException(message: "Please enter your last name"));

      expect(await userAuth.signup("Nicole","","nicole.joseph2122@gmail.com","sample123", "sample123"), "Please enter your last name");
    });

    test("no email", () async  {
      when (
        mockFirebaseAuth.createUserWithEmailAndPassword(email: "", password: "sample123"),
      ).thenAnswer((realInvocation) =>
      throw FirebaseAuthException(message: "Please enter your email address"));

      expect(await userAuth.signup("Nicole","Joseph","","sample123", "sample123"), "Please enter your email address");
    });

    test("no password", () async  {
      when (
        mockFirebaseAuth.createUserWithEmailAndPassword(email: "nicole.joseph2122@gmail.com", password: ""),
      ).thenAnswer((realInvocation) =>
      throw FirebaseAuthException(message: "Please enter a password"));

      expect(await userAuth.signup("Nicole","Joseph","nicole.joseph2122@gmail.com","", ""), "Please enter a password");
    });

    test("passwords do not match", () async  {
      when (
        mockFirebaseAuth.createUserWithEmailAndPassword(email: "nicole.joseph2122@gmail.com", password: "sample123"),
      ).thenAnswer((realInvocation) =>
      throw FirebaseAuthException(message: "Passwords do not match"));

      expect(await userAuth.signup("Nicole","Joseph","nicole.joseph2122@gmail.com","sample123", "sample321"), "Passwords do not match");
    });

    test("invalid email address", () async  {
      when (
        mockFirebaseAuth.createUserWithEmailAndPassword(email: "appfoodstack", password: "sample123"),
      ).thenAnswer((realInvocation) =>
      throw FirebaseAuthException(message: "Email address is badly formatted"));

      expect(await userAuth.signup("Nicole","Joseph","appfoodstack","sample123", "sample321"), "Email address is badly formatted");
    });

    }
  );
}
