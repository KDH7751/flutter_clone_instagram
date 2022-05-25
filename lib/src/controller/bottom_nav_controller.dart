import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/controller/upload_controller.dart';
import 'package:get/get.dart';

import '../components/message_popup.dart';
import '../pages/upload.dart';

enum PageName { HOME, SEARCH, UPLOAD, ACTIVITY, MYPAGE } //페이지 이름을 emum으로 정의해줌

class BottomNavController extends GetxController {
  static BottomNavController get to => Get.find();
  RxInt pageIndex = 0.obs; //페이지 번호값. 변경할 수 있게 obs를 붙였다.
  GlobalKey<NavigatorState> searchPageNavigationKey =
      GlobalKey<NavigatorState>();
  List<int> bottomHistory = [0]; //history 기록. 최초는 0으로.

  void changeBottomNav(int value, {bool hasGesture = true}) { //페이지 번호값을 변경시켜주는 역할, 디폴트값이 true
    //hasgesture가 true = 선택으로 페이지를 변경하는 방식. 스택이 쌓인다.
    //hasgetture가 false = 뒤로 가기로 페이지를 변경하는 방식. 스택이 쌓이지 않게 한다.
    var page = PageName.values[value]; //enum으로 정의한 페이지 이름과 페이지 번호를 연동
    switch (page) { //업로드의 경우 페이지 전환이 아니라 팝업이라서 이렇게 씀
      case PageName.UPLOAD:
        Get.to(() => Upload(),binding: BindingsBuilder((){ //getx를 통해 팝업 형식으로 새로운 페이지로 보냄
          Get.put(UploadController());
        }));
        break;
      case PageName.HOME: //홈, 서치, 액티비티, 마이페이지는 페이지 전환임
      case PageName.SEARCH:
      case PageName.ACTIVITY:
      case PageName.MYPAGE:
        _changePage(value, hasGesture: hasGesture); //페이지 전환시 필요한 페이지 번호를 아래에서 받아옴. hasgesture값도 동일
        break; //changepage랑 break는 위쪽 4개 공통이라 이런 방식으로 씀
    }
  }

  void _changePage(int value, {bool hasGesture = true}) { //페이지 체인지 기능을 일괄관리. hasgesture 값을 받아오는 기능
    pageIndex(value); //페이지 번호
    if (!hasGesture) return; //hasgesture가 false일 떄 리턴해 버림으로서 아래 스택 쌓이는 이벤트가 일어나지 않도록 함
    if (bottomHistory.last != value) { //가장 최근 페이지랑 같은 페이지가 아닐 때만 스택이 쌓이도록 value를 확인해서 조건 체크
      bottomHistory.add(value); //페이지 전환시 history의 값을 +1해준다.
    }
  }

  Future<bool> willPopAction() async { //뒤로가기 버튼을 눌렀을 때 발생할 이벤트를 해당 컨트롤러가 관리.
    if (bottomHistory.length == 1) { //쌓인 스택이 1개일 때
      showDialog(
          context: Get.context!,
          builder: (context) => MessagePopup( //종료시 메시지 팝업 띄우는 용도, message_popup이 담당.
                message: '종료하시겠습니까?',
                okCallback: () {
                  exit(0);
                },
            cancelCallback: Get.back,
                title: '시스템',
              ));
      return true;
    } else { //스택이 1 이상일 때
      var page = PageName.values[bottomHistory.last];
      if(page == PageName.SEARCH){
        var value = await searchPageNavigationKey.currentState!.maybePop();
        if(value) return false;
      }


      bottomHistory.removeLast(); // 가장 최근의 스택을 1 줄여줌
      var index = bottomHistory.last; //스택 줄어든 걸 index에 집어넣고
      changeBottomNav(index, hasGesture: false); // changebottomnav로 변경된 값을 보내주고, hasgesture 값을 false로 바꿈
      return false;
    }
  }
}
