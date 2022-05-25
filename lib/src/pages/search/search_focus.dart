import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/image_data.dart';
import 'package:flutter_clone_instagram/src/controller/bottom_nav_controller.dart';
import 'package:get/get.dart';

class SearchFocus extends StatefulWidget {
  const SearchFocus({Key? key}) : super(key: key);

  @override
  State<SearchFocus> createState() => _SearchFocusState();
}

class _SearchFocusState extends State<SearchFocus>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() { //initstate 사용해서 컨트롤러 처음으로 불러옴
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 5, vsync: this);
  }

  Widget _tabMenuOne(String menu){ //탭 메뉴에 실질적으로 들어갈 내용인 text의 양식을 일괄 정의
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0), //글자 부분만이 아니라 주변 어디를 눌러도 선택되게
      child: Text(
        menu,
        style: TextStyle(fontSize: 15, color: Colors.black),
      ),
    );
  }

  PreferredSizeWidget _tabMenu(){ //appbar 아래쪽, body 위쪽에 넣어줄 부분.
    return PreferredSize(
      child: Container(
        height: AppBar().preferredSize.height,
        width: Size.infinite.width,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffe4e4e4))) //희미한 회색 선
        ),
        child: TabBar(
          controller: tabController,
          indicatorColor: Colors.black, //선택시 이름 하단에 검은 선
          tabs: [
            _tabMenuOne('인기'),
            _tabMenuOne('계정'),
            _tabMenuOne('오디오'),
            _tabMenuOne('태그'),
            _tabMenuOne('장소'),
          ],
        ),
      ),
      preferredSize: Size.fromHeight(AppBar().preferredSize.height),//앱바 사이즈 만큼의 height를 주는 방법
    );
  }
  
  Widget _body(){ //body에 들어갈 부분. 누르는거에 따라서 다른 페이지를 보여주는 게 원 용도...긴 한데 일단은 그냥 텍스트만 띄우고 있음.
    return TabBarView(
      controller: tabController,
      children: const [
        Center(child: Text('인기페이지')),
        Center(child: Text('계정페이지')),
        Center(child: Text('오디오페이지')),
        Center(child: Text('태그페이지')),
        Center(child: Text('장소페이지')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( //상단에 있는 앱바 부분. 이 하위항목은 전부 앱바 디자인 부분이라서 상관없음.
        elevation: 0,
        leading: GestureDetector(
            onTap: BottomNavController.to.willPopAction,
            //Get.back,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ImageData(IconsPath.backBtnIcon),
            )),
        titleSpacing: 0,
        title: Container(
          margin: const EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: const Color(0xffefefef),
          ),
          child: const TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '검색',
                contentPadding: EdgeInsets.only(left: 15, top: 7, bottom: 7),
                isDense: true),
          ),
        ),
        bottom: _tabMenu(),
      ),
      body: _body(),
    );
  }
}
