import 'package:flutter/material.dart';
import 'package:skype_clone/resources/firebase-repo.dart';
import 'package:skype_clone/utils/universal_vars.dart';
import 'package:skype_clone/widgets/appbar.dart';
import 'package:skype_clone/widgets/chatTile.dart';
import '../utils/username.dart';
class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}
 Firebaserepo fr = Firebaserepo();

class _ChatListState extends State<ChatList> {
  String cuid;
  String name;
 
  @override
  void initState() {

    super.initState();
    fr.getUser().then((user){
      setState(() {
        cuid = user.uid;
        name = Utils.getInitials(user.displayName);

      });
    });

  }

  CustomAppBar _customAppBar(BuildContext context)
  {
    return CustomAppBar(
      leading: IconButton(icon: Icon(Icons.notifications,color: Colors.white,), onPressed: (){}),
      title: UserCircle(text: name),
      centerTile: true,
      actions: <Widget>[
        IconButton(icon: Icon(Icons.search), onPressed: (){}),
        IconButton(icon: Icon(Icons.more_vert), onPressed: (){})
      ],


    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: _customAppBar(context),
      floatingActionButton: NewChatButton(),
      body: ChatTileList()

    );

  }

 
}
class ChatTileList extends StatefulWidget {
  @override
  _ChatTileListState createState() => _ChatTileListState();
}

class _ChatTileListState extends State<ChatTileList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: 2,
        itemBuilder: (context,index){
          return ChatTile(
            mini: false,
              title: Text(
              "Bhoomika",
              style: TextStyle(
                  color: Colors.white, fontFamily: "Arial", fontSize: 19),
            ),
            subtitle: Text(
              "Hello",
              style: TextStyle(
                color: UniversalVariables.greyColor,
                fontSize: 14,
              ),
            ),
            leading: Container(
              constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    maxRadius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage("https://lh3.googleusercontent.com/a-/AOh14GhvmMXVo4sIlgFMjHqkXMtgAgsOMJrX0-wSkZSq=s96-c"),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 13,
                      width: 13,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: UniversalVariables.onlineDotColor,
                        border: Border.all(
                          color: UniversalVariables.blackColor,
                          width: 2
                        )
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      
    );
  }
}
 class UserCircle extends StatelessWidget {
   final String text;
   UserCircle({this.text});
    @override
    Widget build(BuildContext context) {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: UniversalVariables.separatorColor
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: UniversalVariables.lightBlueColor,
                  fontSize: 13
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: UniversalVariables.blackColor,
                    width: 2
                  ),
                  color: UniversalVariables.onlineDotColor
                ),
              ),

            )

        ],),
        
      );
    }
  }
  class NewChatButton extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          gradient: UniversalVariables.fabGradient,
          borderRadius: BorderRadius.circular(50),
          
        ),
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 25,
        ),
        padding: EdgeInsets.all(15),
      );
    }
  }
