import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/image_data.dart';
import 'package:flutter_clone_instagram/src/controller/bottom_nav_controller.dart';
import 'package:flutter_clone_instagram/src/pages/active_history.dart';
import 'package:flutter_clone_instagram/src/pages/mypage.dart';
import 'package:get/get.dart';

import 'pages/home.dart';
import 'pages/search.dart';

class App extends GetView<BottomNavController> {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope( //뒤로가기 버튼 등을 임의로 조정하기 위해 넣은 것. onwillpop 참조
        child: Obx(() => Scaffold( //OBX로 감싸서 상태 변경시 실제로 반영이 될 수 있도록 해준다.
          body: IndexedStack( //한 번에 하나의 하위 항목만 보여주지만 모든 항목의 상태는 유지시켜줌. 채널을 변환하는 TV와 비슷한 역할
            index: controller.pageIndex.value, //현재 무슨 페이지인지 값을 받아옴
            children: [
              const Home(),
              Navigator(
                key: controller.searchPageNavigationKey,
                onGenerateRoute: (routeSetting){
                  return MaterialPageRoute(builder: (context)=>const Search(),);
                },
              ),
              //const Search(),
              Container(),
              const ActiveHistory(),
             const MyPage(),

            ],
          ),
          bottomNavigationBar: BottomNavigationBar( //하단바 추가
            type: BottomNavigationBarType.fixed, //여기서 밑으로 3줄 + elevation은 아래쪽 아이콘들 깔끔하게 정렬하기 위한 것
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: controller.pageIndex.value, //bottom_nav_controller에 있는 페이지 번호값을 불러오는 역 할
            onTap: controller.changeBottomNav, //눌러서 bottom_nav_controller에 있는 changepage 함수를 통해 페이지 번호값을 변경
            elevation: 0,
            items: [
              //iamgedata에 미리 이미지 사이즈의 형식이나 이런 걸 설정해 놓고 짧게 불러올 수 있게 해줌
              BottomNavigationBarItem( // 홈 아이콘,클릭시 아이콘 변경
                icon: ImageData(IconsPath.homeOff),
                activeIcon: ImageData(IconsPath.homeOn),
                label: 'home',
              ),
              BottomNavigationBarItem( // 서치 아이콘,클릭시 아이콘 변경
                icon: ImageData(IconsPath.searchOff),
                activeIcon: ImageData(IconsPath.searchOn),
                label: 'home',
              ),
              BottomNavigationBarItem( // 업로드 아이콘,누르면 다른 창으로 보낼 거라 클릭시 아이콘은 없음
                icon: ImageData(IconsPath.uploadIcon),
                label: 'home',
              ),
              BottomNavigationBarItem( // 액티브 아이콘,클릭시 아이콘
                icon: ImageData(IconsPath.activeOff),
                activeIcon: ImageData(IconsPath.activeOn),
                label: 'home',
              ),
              BottomNavigationBarItem( // 아바타(프로필) 등이 들어갈 자리라 따로 아이콘 넣을 필요가 없음
                icon: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey),
                ),
                label: 'home',
              ),
            ],
          ),
        ),),
        onWillPop: controller.willPopAction, //뒤로가기 버튼 눌렀을 때 해당 이벤트가 호출. 컨트롤러에서 관리한다.
    );
  }
}
