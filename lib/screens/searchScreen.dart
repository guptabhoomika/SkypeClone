import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/resources/firebase-repo.dart';
import 'package:skype_clone/screens/ChatScreen.dart';
import 'package:skype_clone/utils/universal_vars.dart';
import 'package:skype_clone/widgets/chatTile.dart';
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Firebaserepo _firebaserepo = Firebaserepo();
  List<User> _users = List<User>();
  String query = "";
  TextEditingController _searchcontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaserepo.getUser().then((FirebaseUser user){

        _firebaserepo.fetchAll(user).then((List<User> list){
              setState(() {
                _users = list;

              });
              
        });
    });
    print(_users.length);
  }
  searchBar(BuildContext context)
  {
    return GradientAppBar(
       backgroundColorStart: UniversalVariables.gradientColorStart,
       backgroundColorEnd: UniversalVariables.gradientColorEnd,
       leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){Navigator.pop(context);}),
       elevation: 0.0,
       bottom: PreferredSize(
         preferredSize: const Size.fromHeight(kToolbarHeight + 20),
         child: Padding(padding: EdgeInsets.only(left: 20),
         child: TextField(
           controller: _searchcontroller,
           onChanged: (val)
           {
             setState(() {
               query = val;

             });
           },
           cursorColor: UniversalVariables.blackColor,
           autofocus: true,
           style: TextStyle(
             fontWeight: FontWeight.bold,
             fontSize: 35,
             color: Colors.white
           ),
           decoration: InputDecoration(
             suffixIcon: IconButton(icon: Icon(Icons.close,color: Color(0x88ffffff),), onPressed: (){  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _searchcontroller.clear());}),
             border: InputBorder.none,
             hintText: "Search",
             hintStyle: TextStyle(
               fontSize: 35,
               fontWeight: FontWeight.bold,
               color: Color(0x88ffffff),

             )

           ),

         ),),
       ),
    );
  }
  buidSuggestion(String query)
  {
    final List<User> _suggestionList = query.isEmpty ? [] 
    :  _users.where((User user) {
            String _getUsername = user.username.toLowerCase();
            String _query = query.toLowerCase();
            String _getName = user.name.toLowerCase();
            bool matchesUsername = _getUsername.contains(_query);
            bool matchesName = _getName.contains(_query);

            return (matchesUsername || matchesName);

            // (User user) => (user.username.toLowerCase().contains(query.toLowerCase()) ||
            //     (user.name.toLowerCase().contains(query.toLowerCase()))),
          }).toList();
    return ListView.builder(
      itemCount: _suggestionList.length,
      itemBuilder: ((context,index){
        User searchedUser = User(
          uid: _suggestionList[index].uid,
          profilePhoto: _suggestionList[index].profilePhoto,
          name: _suggestionList[index].name,
          username: _suggestionList[index].username
        );
        return ChatTile(
          mini: false,
          onTap: (){
            Navigator.push(context, 
            MaterialPageRoute(builder: (context)=> ChatScreen(reciever: searchedUser,)));
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchedUser.profilePhoto),
            backgroundColor: Colors.grey,
          ),
          title: Text(searchedUser.name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),),
          subtitle: Text(
            searchedUser.name,style: TextStyle(
              color: UniversalVariables.greyColor
            ),
          ),
        );
      }),
    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: searchBar(context),
      body: Container(
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 20),
        child: buidSuggestion(query),),
      ),
      
    );
  }
}