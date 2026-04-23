import 'dart:convert';
import 'dart:developer';

import 'package:chat_app_with_pusher/core/helpers/pusher_config.dart';
import 'package:chat_app_with_pusher/features/chat/data/models/chat_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../../core/helpers/navigator_utils.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';


class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  ScrollController scrollController = ScrollController();

  late PusherConfig pusherConfig;

  ChatDetailsModel? chatDetailsModel;

  int currentUser = 2; // here you add the current user id

  initilizeRoom(roomID) async {
    pusherConfig = PusherConfig();

    pusherConfig.initPusher(
      onEvent,
      roomId: roomID,
    );
  }

  animateListToTheEnd({int time = 500}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: time),
        curve: Curves.easeInOut,
      );
    });
  }

  void onEvent(PusherEvent event) {
    log("event came: " + event.data.toString());
    try {
      log(event.eventName.toString());
      if (event.eventName == r"App\Events\PushChatMessageEvent") {
        log("here");
        Message? message;
        message = Message.fromJson(jsonDecode(event.data)["data"]);

        chatDetailsModel!.messages!.add(message);
      }

      setState(() {});
      animateListToTheEnd();
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    ChatCubit.get(context).getChatDetails(firstUser: 1, secondUser: 2);

    super.initState();
  }

  @override
  void dispose() {
    pusherConfig.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xff168AFF),
        title: const Text("Chat Room",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
            onPressed: () {
              pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_sharp,
              color: Colors.white,
            )),
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state.chatState == ChatStates.success) {
            chatDetailsModel = state.chatDetailsModel;
            initilizeRoom(chatDetailsModel!.chats!.roomId);
            animateListToTheEnd();
          }
        },
        builder: (context, state) {
          if (state.chatState == ChatStates.loading) {
            return const LoadingWidget();
          }

          if (state.chatState == ChatStates.success) {
            log("i am here");
            return MessagesListWidget(
                scrollController: scrollController,
                chatDetailsModel: chatDetailsModel,
                currentUser: currentUser);
          }
          return const ErrorAlertWidget();
        },
      ),
    );
  }
}