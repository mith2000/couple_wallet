part of 'base_remote_data_source.dart';

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
  @override
  Future<AppResultRaw<ChatRaw>> getChatSession({
    required List<String> participants,
  }) async {
    var chatsCollection = FirebaseFirestore.instance.collection(chatCollection);

    try {
      // Query for the first participant
      var querySnapshot1 = await chatsCollection
          .where('participants', arrayContains: participants[0])
          .get();

      // Query for the second participant
      var querySnapshot2 = await chatsCollection
          .where('participants', arrayContains: participants[1])
          .get();

      // Find documents that exist in both query results
      var commonDocs = querySnapshot1.docs
          .where((doc) => querySnapshot2.docs.any((doc2) => doc2.id == doc.id))
          .toList();

      if (commonDocs.isNotEmpty) {
        var docSnapshot = commonDocs.first;
        return AppResultRaw(netData: ChatRaw.fromJson(docSnapshot.data()));
      } else {
        return AppResultRaw(netData: ChatRaw.empty());
      }
    } catch (e) {
      Logs.e("FirebaseFirestore Error completing: $e");
      // TODO return AppException
      return AppResultRaw(netData: ChatRaw.empty());
    }
  }

  @override
  Future<AppResultRaw<EmptyRaw>> sendMessage({
    required List<String> participants,
    required Map<String, dynamic>? request,
  }) async {
    var chatsCollection = FirebaseFirestore.instance.collection(chatCollection);

    try {
      // Query for the first participant
      var querySnapshot1 = await chatsCollection
          .where('participants', arrayContains: participants[0])
          .get();

      // Query for the second participant
      var querySnapshot2 = await chatsCollection
          .where('participants', arrayContains: participants[1])
          .get();

      // Find documents that exist in both query results
      var commonDocs = querySnapshot1.docs
          .where((doc) => querySnapshot2.docs.any((doc2) => doc2.id == doc.id))
          .toList();

      if (commonDocs.isNotEmpty) {
        var docSnapshot = commonDocs.first;
        // If a chat document is found, get its reference
        var chatRef = docSnapshot.reference;

        FirebaseFirestore.instance.runTransaction((transaction) async {
          var chatSnapshot = await transaction.get(chatRef);
          var messages = List.from(chatSnapshot.data()?['messages'] ?? []);

          // If there are already 30 messages, remove the oldest one
          if (messages.length >= 30) {
            messages.removeAt(0); // Remove the first message in the list
          }

          // Add the new message map to the array
          messages.add(request);

          // Update the document with the new list of messages
          transaction.update(chatRef, {'messages': messages});
        }).then(
          (value) => {},
          onError: (e) =>
              Logs.e("FirebaseFirestore Error updating document: $e"),
        );
        return AppResultRaw(netData: EmptyRaw());
      } else {
        // If no chat document is found, create a new one with the initial message
        chatsCollection.add({
          'participants': participants,
          'messages': [request] // Start with the new message in an array
        });
        return AppResultRaw(netData: EmptyRaw());
      }
    } catch (e) {
      Logs.e("FirebaseFirestore Error completing: $e");
      // TODO return AppException
      return AppResultRaw(netData: EmptyRaw());
    }
  }
}
