part of 'base_firestore_data_source.dart';

const String userIdField = "id";

abstract class UserRemoteDataSource {
  Future<AppResultRaw<UserRaw>> getUserInfo({
    required String userId,
  });

  Future<AppResultRaw<EmptyRaw>> registerUser({
    required Map<String, dynamic> request,
  });
}

class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  @override
  Future<AppResultRaw<UserRaw>> getUserInfo({
    required String userId,
  }) async {
    try {
      // Query for the first user matches the userId
      var querySnapshot = await usersCollection.where(userIdField, isEqualTo: userId).get();
      var queryDocs = querySnapshot.docs;

      if (queryDocs.isNotEmpty) {
        var docSnapshotData = queryDocs.first.data();
        Logs.i(docSnapshotData);
        return AppResultRaw(netData: UserRaw.fromJson(docSnapshotData));
      } else {
        Logs.i("No user document found");
        throw FirestoreHandleError.notFound(message: 'User not found');
      }
    } on FirebaseException catch (e) {
      throw FirestoreHandleError.handleFirestoreException(e);
    } catch (e) {
      FirestoreExceptionLogs.onError(e);
      if (e is AppException && e.errorCode == ErrorCode.notFoundError) {
        rethrow;
      }
      throw FirestoreHandleError.unknown(e);
    }
  }

  @override
  Future<AppResultRaw<EmptyRaw>> registerUser({
    required Map<String, dynamic> request,
  }) async {
    try {
      // Query for the first user matches the userId
      var querySnapshot =
          await usersCollection.where(userIdField, isEqualTo: request[userIdField]).get();
      var queryDocs = querySnapshot.docs;

      if (queryDocs.isNotEmpty) {
        // If a user document is found, throw an error
        Logs.i("User document already existed");
        throw FirestoreHandleError.alreadyExisted(message: 'User already existed');
      } else {
        // If no user document is found, create a new one
        usersCollection.add(request);
      }
      return AppResultRaw(netData: EmptyRaw());
    } on FirebaseException catch (e) {
      throw FirestoreHandleError.handleFirestoreException(e);
    } catch (e) {
      FirestoreExceptionLogs.onError(e);
      if (e is AppException && e.errorCode == ErrorCode.alreadyExistedError) {
        rethrow;
      }
      throw FirestoreHandleError.unknown(e);
    }
  }
}
