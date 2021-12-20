import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_arduino/api.dart';
import 'package:flutter_arduino/model/data.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'api_event.dart';
part 'api_state.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  ApiBloc() : super(LoadingState()) {
    on<ApiEvent>((event, emit) async {
      if (event is GetMessagesEvent) {
        List<String> messages = await API.recieveMessages();
        emit(MessagesLoaded(messages));
      } else if (event is SendMessageEvent) {
        await API.sendMessage(event.message);
        emit(SendingMessageInProgress());
        List<String> messages = await API.recieveMessages();
        emit(MessagesLoaded(messages));
      } else if (event is SetPinsValue) {
        emit(LoadingState());
        List<dynamic> pinList = await API.getPinsStatus();
        List<PinsData> pinDataList = [];
        for (int i = 0; i < pinList.length; i++) {
          pinDataList
              .add(PinsData(name: 'D' + i.toString(), value: pinList[i]));
        }
        print(pinList);
        emit(PinsValueLoaded(pinDataList));
      }
    });
  }
}
