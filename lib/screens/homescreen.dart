import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/screens/chatlistScreen.dart';
import 'package:skype_clone/utils/universal_vars.dart';
import '../resources/firebase-repo.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
      Firebaserepo fr = Firebaserepo();
      PageController _pageController;
      int index = 0;
       double _labelFontSize = 10;
      @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }
  void onPAgeCHanged(int page)
  {
    setState(() {
      index = page;
    });
  }
  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: PageView(
        children: <Widget>[
          Center(child: ChatList(),),
          Center(child: Text("Call Logs"),),
          Center(child: Text("Contacts"),),

        ],
        controller: _pageController,
        onPageChanged: onPAgeCHanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: Container(
        child: Padding(padding: EdgeInsets.symmetric(vertical: 10),
        child: CupertinoTabBar(
          backgroundColor: UniversalVariables.blackColor,
          items: <BottomNavigationBarItem>[
             BottomNavigationBarItem(
                icon: Icon(Icons.chat,
                    color: (index == 0)
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor),
                title: Text(
                  "Chats",
                  style: TextStyle(
                      fontSize: _labelFontSize,
                      color: (index == 0)
                          ? UniversalVariables.lightBlueColor
                          : Colors.grey),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.call,
                    color: (index == 1)
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor),
                title: Text(
                  "Calls",
                  style: TextStyle(
                      fontSize: _labelFontSize,
                      color: (index == 1)
                          ? UniversalVariables.lightBlueColor
                          : Colors.grey),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.contact_phone,
                    color: (index == 2)
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor),
                title: Text(
                  "Contacts",
                  style: TextStyle(
                      fontSize: _labelFontSize,
                      color: (index == 2)
                          ? UniversalVariables.lightBlueColor
                          : Colors.grey),
                ),
              ),
            
          ],
               onTap: navigationTapped,
            currentIndex: index,
        ),),
      ),

      
    );
  }
}