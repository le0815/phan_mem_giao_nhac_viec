class ModelMessage {
  final String message;
  final int timeSend;
  final String senderUID;

  ModelMessage({
    required this.message,
    // required this.chatCollectionID,
    // required this.messageCollection,
    required this.timeSend,
    required this.senderUID,
  });

  factory ModelMessage.fromMap(Map object) {
    return ModelMessage(
        message: object["message"],
        // chatCollectionID: object["chatCollectionID"],
        // messageCollection: object["messageCollection"],
        timeSend: object["timeSend"],
        senderUID: object["senderUID"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "timeSend": timeSend,
      "senderUID": senderUID,
    };
  }
}
