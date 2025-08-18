import 'package:get/get.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/presentation/profile/logic/profile_logic.dart';
import 'package:flutter/material.dart';
import 'package:tcs_flutter/feature/presentation/user_list/controller/user_controller.dart';
import 'package:tcs_flutter/router/one_signal_service.dart';
import 'package:tcs_flutter/src/Api/api_service.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tcs_flutter/feature/presentation/user_list/user_list_screen.dart';
import 'package:tcs_flutter/feature/presentation/profile/view/profile_screen.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/view/leave_request_list_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // final controllerTaskCreate = Get.lazyPut(() => TaskCreateController());

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => UserController());
    Get.put(ProfileLogic());
    
  }

  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    LeaveScreen(
      onUpdateCallback: (bool) {},
    ),
    ProfileScreen(),
  ];

  final List<SalomonBottomBarItem> selectedItem = [
    // SalomonBottomBarItem(
    //   icon: Icon(Icons.person, size: 24),
    //   title: Text("Task",
    //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    //   selectedColor: Colors.blueAccent,
    // ),
    SalomonBottomBarItem(
      icon: Icon(Icons.list, size: 24),
      title: Text("Xin phép",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      selectedColor: Colors.green,
    ),
    // SalomonBottomBarItem(
    //   icon: Icon(Icons.support_agent_rounded, size: 24),
    //   title: Text("Hỗ trợ",
    //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    //   selectedColor: Colors.orange,
    // ),
    // SalomonBottomBarItem(
    //   icon: Icon(Icons.people, size: 24),
    //   title: Text("Nhân viên",
    //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    //   selectedColor: Colors.purple,
    // ),
    SalomonBottomBarItem(
      icon: Icon(Icons.person, size: 24),
      title: Text("Cá nhân",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      selectedColor: AppColors.primary,
    ),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _screens,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 16.0,
        ),
        child: Container(
          margin: EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(30),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.5),
            //     spreadRadius: 2,
            //     blurRadius: 7,
            //     offset: Offset(0, 3),
            //   ),
            // ]
          ),
          child: SalomonBottomBar(
            currentIndex: _selectedIndex,
            onTap: _onTabTapped,
            unselectedItemColor: Colors.grey,
            itemPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10.w),
            items: selectedItem,
          ),
        ),
      ),
    );
  }
}
