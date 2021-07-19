import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodstack/src/services/firestoreRestaurants.dart';
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

  final FirebaseFirestore fakeFirebaseFirestore = FakeFirebaseFirestore();
  final FirestoreRestaurants firestoreRestaurants = FirestoreRestaurants(
      firestore: fakeFirebaseFirestore, fireauth: mockFirebaseAuth);
  group('Firestore restaurants', () {
    test('Add restaurant', () async {});

    test('Get restaurant', () async {});

    test('Delete restaurant', () async {});

    test('Get restaurants list', () async {});

    test('Filter restaurants list', () async {});

    test('Load nearby order restaurants list', () async {});

    test('Get favourite restaurants list', () async {});

    test('Add rating for a restaurant', () async {});
  });
}
