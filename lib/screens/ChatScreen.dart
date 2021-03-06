import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:skype_clone/models/message.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/resources/firebase-repo.dart';
import 'package:skype_clone/utils/universal_vars.dart';
import 'package:skype_clone/widgets/appbar.dart';
import 'package:skype_clone/widgets/chatTile.dart';
class ChatScreen extends StatefulWidget {
  final User reciever;
  ChatScreen({this.reciever});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  Firebaserepo _firebaserepo = Firebaserepo();
  bool isWriting = false;
  User sender = User();
  FocusNode _textfocus = FocusNode();
  String _currentUserId = "";
  bool isEmoji = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaserepo.getUser().then((user){
      _currentUserId = user.uid;
      setState(() {
        sender = User(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoUrl
        );


      });
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column(children: <Widget>[
        Flexible(child: messageList(),),
        chatControl(),
        isEmoji ? Container(child: emojiContainer(),) : Container()
      ],),
    );
  }
  emojiContainer()
  {
    return EmojiPicker(
      bgColor: UniversalVariables.separatorColor,
      indicatorColor: UniversalVariables.blueColor,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji,category){},
    );
  }
  Widget messageList()
  {
    return StreamBuilder(
      stream: Firestore.instance.collection("messages").document(_currentUserId).collection(widget.reciever.uid).orderBy("timestamp",descending: true).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.data == null)
        {
          return Center(child: CircularProgressIndicator(),);
        }
        
        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: snapshot.data.documents.length,
          reverse: true,
          controller: _scrollController,
          itemBuilder: (context,index){
            return chatMessageItem(snapshot.data.documents[index]);
          },

        );
      },
    );

  }
  showKeyBoard() => _textfocus.requestFocus();
  hideKeyBorad() => _textfocus.unfocus();
  hideEmojiContainer(){
    setState(() {
      isEmoji = false;
    });
  }
  showEmojiContainer()
  {
    setState(() {
      isEmoji = true;
    });
  }
  Widget chatMessageItem(DocumentSnapshot snapshot)
  {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: snapshot['senderId']==_currentUserId ? Alignment.centerRight : Alignment.centerLeft,
        child:  snapshot['senderId']==_currentUserId ? senderLayout(snapshot) : receiverLayout(snapshot),
      ),
    );
  }
  Widget senderLayout(DocumentSnapshot snapshot) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: UniversalVariables.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getText(snapshot)
      ),
    );
  }
  getText(DocumentSnapshot snapshot)
  {
    return Text(
      snapshot['message'],
      style: TextStyle(
        color: Colors.white,
        fontSize: 16
      ),

    );
  }
  Widget receiverLayout(DocumentSnapshot snapshot) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: UniversalVariables.receiverColor,
        borderRadius: BorderRadius.only(
          bottomRight: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: getText(snapshot)
      ),
    );
  }
    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: UniversalVariables.blackColor,
          builder: (context) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        child: Icon(
                          Icons.close,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Content and tools",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      ModalTile(
                        title: "Media",
                        subtitle: "Share Photos and Video",
                        icon: Icons.image,
                      ),
                      ModalTile(
                        title: "File",
                        subtitle: "Share files",
                        icon: Icons.tab),
                    ModalTile(
                        title: "Contact",
                        subtitle: "Share contacts",
                        icon: Icons.contacts),
                    ModalTile(
                        title: "Location",
                        subtitle: "Share a location",
                        icon: Icons.add_location),
                    ModalTile(
                        title: "Schedule Call",
                        subtitle: "Arrange your calls",
                        icon: Icons.schedule),
                    ModalTile(
                        title: "Create Poll",
                        subtitle: "Share polls",
                        icon: Icons.poll)
                    ],
                  ),
                ),
              ],
            );
          });
    }
    sendMessage(){
        var text = _controller.text;
        Message message = Message(
          receiverId: widget.reciever.uid,
          senderId: sender.uid,
          message: text,
          timestamp: FieldValue.serverTimestamp(),
          type: 'text'

        );
        setState(() {
          isWriting = false;
        });
        _controller.text = "";
        _firebaserepo.addMessageToDb(message, sender, widget.reciever);
    }

  
  Widget chatControl()
  {
     setWritingTo(bool val)
     {
       setState(() {
         isWriting = val;
       });
     }
    return Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
              GestureDetector(
             onTap: () => addMediaModal(context),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    gradient: UniversalVariables.fabGradient,
                    shape: BoxShape.circle
                  ),
                  child: Icon(Icons.add),
                ),
              ),
              SizedBox(width: 5,),
              Expanded(child: Stack(
                children: <Widget>[
    TextField(
  
                    controller: _controller,
                    focusNode: _textfocus,
                    onTap: () => hideEmojiContainer(),
  
                    style: TextStyle(
  
                      color: Colors.white
  
                    ),
  
                    onChanged: (val){
  
                      (val.length > 0 && val.trim() != "") ? setWritingTo(true) : setWritingTo(false);
  
                    },
  
                    decoration: InputDecoration(
  
                      hintText: "Type a message",
                      
  
                      hintStyle: TextStyle(
  
                        color: UniversalVariables.greyColor
  
                      ),
  
                      border: OutlineInputBorder(
  
                        borderRadius: const BorderRadius.all(
  
                          const Radius.circular(50)
  
                        ),
  
                        borderSide: BorderSide.none,
  
  
  
                      ),
  
                      contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
  
                      filled: true,
  
                      fillColor: UniversalVariables.separatorColor,
  
                      //suffixIcon: 
  
                    ),
  
  
  
                  ),
                  IconButton( onPressed: (){
                    if(!isEmoji)
                    {
                      hideKeyBorad();
                      showEmojiContainer();
                    }
                    else
                    {
                      showKeyBoard();
                      hideEmojiContainer();
                    }
                  },
                  icon: Icon(Icons.face),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
  
                       
                      )
],
              )
              
              ),
              isWriting ? Container() : Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: Icon(Icons.record_voice_over),),
              isWriting ? Container() : Icon(Icons.camera_alt),
              isWriting ?
              Container(
                margin: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  gradient: UniversalVariables.fabGradient,
                  shape: BoxShape.circle
                ),
                child: IconButton(
                  icon: Icon(Icons.send,size: 15,),
                  onPressed: ()=>sendMessage() ,

                )
              ) : Container(),
          ],),
    );
  }
  CustomAppBar customAppBar(BuildContext context)
{
  
    return CustomAppBar(
      leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){Navigator.pop(context);},),
      centerTile: false,
     title: Text(
       widget.reciever.name
       
     ),
     actions: <Widget>[
       IconButton(icon: Icon(Icons.video_call), onPressed: (){}),
       IconButton(icon: Icon(Icons.phone), onPressed: (){}),
     ],


    );
} 
}
class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const ModalTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: ChatTile(
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
