Map<String, dynamic> notificationBody({
  required String senderName,
  required String receiverToken,
  required String messageBody,
  required Map<String, dynamic> model,
}) {
  return {
    "to": receiverToken,
    "notification": {
      "title": senderName,
      "body": messageBody,
      "sound": "default"
    },
    "android": {
      "priority": "HIGH",
      "notification": {
        "notification_priority": "PRIORITY_MAX",
        "sound": "default",
        "default_sound": "true",
        "default_vibrate_timings": "true",
        "default_light_settings": "true"
      }
    },
    "data": {
      "type": "order",
      "id": "87",
      "click_action": "FLUTTER_NOTIFICATOIN_CLICK",
      "model": model,
    }
  };
}

enum NotificationType {
  message,
  friendRequest,
  general,
}

class NotificationBody {
  NotificationType? notificationType;
  String? type;
  int? conversationId;
  int? index;
  String? image;
  String? name;
  String? receiverType;

  NotificationBody({
    this.notificationType,
    this.type,
    this.conversationId,
    this.index,
    this.image,
    this.name,
    this.receiverType,
  });

  NotificationBody.fromJson(Map<String, dynamic> json) {
    notificationType = convertToEnum(json['order_notification']);

    type = json['type'];
    conversationId = json['conversation_id'];
    index = json['index'];
    image = json['image'];
    name = json['name'];
    receiverType = json['receiver_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_notification'] = notificationType.toString();
    data['type'] = type;
    data['conversation_id'] = conversationId;
    data['index'] = index;
    data['image'] = image;
    data['name'] = name;
    data['receiver_type'] = receiverType;
    return data;
  }

  NotificationType convertToEnum(String? enumString) {
    if (enumString == NotificationType.general.toString()) {
      return NotificationType.general;
    } else if (enumString == NotificationType.friendRequest.toString()) {
      return NotificationType.friendRequest;
    } else if (enumString == NotificationType.message.toString()) {
      return NotificationType.message;
    }
    return NotificationType.general;
  }
}
