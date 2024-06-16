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
      // Query to find the chat document
      var querySnapshot = await chatsCollection
          .where('participants', isEqualTo: participants)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var docSnapshot = querySnapshot.docs.first;
        print("Successfully completed");
        print('${docSnapshot.id} => ${docSnapshot.data()}');
        // Assuming you have a constructor in ChatRaw that takes a Map
        return AppResultRaw(netData: ChatRaw.fromJson(docSnapshot.data()));
      } else {
        print("No chat session found");
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

    // Query to find the chat document
    var querySnapshot = await chatsCollection
        .where('participants', isEqualTo: participants)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If a chat document is found, get its reference
      var chatRef = querySnapshot.docs.first.reference;

      // Perform the same logic as in addMessage
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
        (value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) =>
            {Logs.e("FirebaseFirestore Error updating document: $e")},
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
  }
}
