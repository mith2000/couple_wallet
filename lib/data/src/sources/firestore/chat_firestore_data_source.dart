part of 'base_firestore_data_source.dart';

const String participantsField = "participants";
const String messagesField = "messages";
const int maxMessagesInSession = 30;

abstract class ChatRemoteDataSource {
  Future<AppResultRaw<ChatRaw>> getChatSession({
    required List<String> participants,
  });

  Future<AppResultRaw<EmptyRaw>> sendMessage({
    required List<String> participants,
    required Map<String, dynamic>? request,
  });
}

class ChatRemoteDataSourceImpl extends ChatRemoteDataSource {
  final chatsCollection = _instance.collection(chatCollection);

  @override
  Future<AppResultRaw<ChatRaw>> getChatSession({
    required List<String> participants,
  }) async {
    try {
      // Find documents with participants
      var queryDocs = await _queryDocuments(participants);

      if (queryDocs.isNotEmpty) {
        var docSnapshotData = queryDocs.first.data();
        Logs.i(docSnapshotData);
        return AppResultRaw(netData: ChatRaw.fromJson(docSnapshotData));
      } else {
        Logs.i("No chat document found");
        return AppResultRaw(netData: ChatRaw.empty());
      }
    } catch (e) {
      FirestoreException.onError(e);
      throw NetworkException(
        code: ErrorCode.code9999,
        message: 'Something went wrong: ${e.toString()}',
        errorCode: ErrorCode.unknownNetworkServiceError,
      );
    }
  }

  @override
  Future<AppResultRaw<EmptyRaw>> sendMessage({
    required List<String> participants,
    required Map<String, dynamic>? request,
  }) async {
    try {
      // Find documents with participants
      var queryDocs = await _queryDocuments(participants);

      if (queryDocs.isNotEmpty) {
        var docSnapshot = queryDocs.first;
        // If a chat document is found, get its reference
        var chatRef = docSnapshot.reference;

        _instance.runTransaction((transaction) async {
          var chatSnapshot = await transaction.get(chatRef);
          var messages = List.from(chatSnapshot.data()?[messagesField] ?? []);

          // If there are already 30 messages, remove the oldest one
          if (messages.length >= maxMessagesInSession) {
            messages.removeAt(0); // Remove the first message in the list
          }

          // Add the new message map to the array
          messages.add(request);

          // Update the document with the new list of messages
          transaction.update(chatRef, {messagesField: messages});
        }).then(
          (value) =>
              Logs.i("Document updated successfully with new message $request"),
          onError: (e) =>
              Logs.e("FirebaseFirestore Error updating document: $e"),
        );
      } else {
        // If no chat document is found, create a new one with the initial message
        chatsCollection.add({
          participantsField: participants,
          messagesField: [request] // Start with the new message in an array
        });
      }
      return AppResultRaw(netData: EmptyRaw());
    } catch (e) {
      FirestoreException.onError(e);
      throw NetworkException(
        code: ErrorCode.code9999,
        message: 'Something went wrong: ${e.toString()}',
        errorCode: ErrorCode.unknownNetworkServiceError,
      );
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _queryDocuments(
    List<String> participants,
  ) async {
    // Query for the first participant
    var querySnapshot1 = await chatsCollection
        .where(participantsField, arrayContains: participants[0])
        .get();

    // Query for the second participant
    var querySnapshot2 = await chatsCollection
        .where(participantsField, arrayContains: participants[1])
        .get();

    // Find documents that exist in both query results
    return querySnapshot1.docs
        .where((doc1) => querySnapshot2.docs.any((doc2) => doc2.id == doc1.id))
        .toList();
  }
}
