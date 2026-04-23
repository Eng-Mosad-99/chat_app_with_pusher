import 'package:chat_app_with_pusher/features/chat/presentation/views/widgets/receiver_msg_item_widget.dart';
import 'package:chat_app_with_pusher/features/chat/presentation/views/widgets/send_message_widget.dart';
import 'package:flutter/widgets.dart';
import '../../../data/models/chat_details_model.dart';

class MessagesListWidget extends StatelessWidget {
  const MessagesListWidget({
    super.key,
    required this.scrollController,
    required this.chatDetailsModel,
    required this.currentUser,
  });

  final ScrollController scrollController;
  final ChatDetailsModel? chatDetailsModel;
  final int currentUser;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
            itemCount: chatDetailsModel!.messages!.length,
            itemBuilder: (context, i) {
              Message message = chatDetailsModel!.messages![i];
              if (currentUser != message.sender!.id) {
                return ReceiverMsgItemWidget(
                  message: message,
                );
              } else {
                return SenderMsgItemWidget(
                  message: message,
                );
              }
            }),
      ),
      SendMessageWidget(
        userId: currentUser,
        roomId: chatDetailsModel!.chats!.roomId!,
      ),
    ]);
  }
}