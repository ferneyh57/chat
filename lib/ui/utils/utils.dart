String getConversationId(String senderId, String receiverId) {
  final ids = [senderId, receiverId];
  ids.sort();
  final concatenatedIds = ids.join();
  return concatenatedIds;
}
