class RouteHelper {
  static const String chatRoom = '/messenger_screen';
  static const String friendRequest = '/friend_request_screen';
  static const String notifications = '/notifications_screen';

  static String getChatRoomRoute({required String userUid}) => chatRoom;

  static String getFriendRequestRoute() => friendRequest;

  static String getNotificationsRoute() => notifications;
}
