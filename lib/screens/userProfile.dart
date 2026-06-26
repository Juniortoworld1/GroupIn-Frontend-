import 'package:flutter/material.dart';
import 'package:groupin/constants/heighWidth.dart';
import 'package:groupin/provider/Global.provider.dart';
import 'package:provider/provider.dart';

import '../provider/userlogin.provider.dart';
import '../routes/routes.dart';
class userProfile extends StatefulWidget {
  const userProfile({super.key});

  @override
  State<userProfile> createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {
  @override
  Widget build(BuildContext context) {
    final watch = context.watch<UserLoginProvider>();
    final _isDark = context.watch<GlobalValueProvider>().getisDarkMode() ;
    final data = watch.user;
    final screenWidth = MediaQuery.sizeOf(context).width ;
    return PopScope(
      canPop: false,
      // Prevents Flutter from doing the default browser back behavior
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // Force the browser to navigate to the exact URL you want
        Navigator.of(context).pushReplacementNamed('/user/${data!.username}');
      },

      child: Scaffold(
        backgroundColor: _isDark?Colors.black:Colors.white,
        body: Center(
          child: AnimatedContainer(
            duration: Duration(seconds: 2),
            width: screenWidth>800?screenWidth*0.6:screenWidth,
            child: Column(
              children: [
                Expanded(child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Icon(Icons.add, size: 30, color: _isDark?Colors.white:Colors.black,) ,
                          Expanded(child: Center(child: Text(data!.username , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold , color: _isDark?Colors.white:Colors.black), overflow: TextOverflow.ellipsis,))) ,
                          InkWell(
                            borderRadius: BorderRadius.circular(4.0),
                            onTap: () {
                              // 🛠️ Add your custom action here!
                              // Example: Scaffold.of(context).openDrawer();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.menu, // 👈 The three-line hamburger icon
                                size: 30,
                                color: _isDark?Colors.white:Colors.black,// Slightly bumped from 15 so the three lines are crisp/readable
                              ),
                            ),
                          ),
                        ],) ,
                        // coverImage and avatar
                        Stack(
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 200,
                                  child: data?.coverImage==""?Container(color: _isDark?Colors.white70:Colors.black12, child: Icon(Icons.person , color: _isDark?Colors.black12:Colors.white,)):Image.network(data!.coverImage , fit: BoxFit.cover, ),
                                ),
                              ),
                            ) ,
                            Positioned(
                              bottom: 0,
                                right: 20,
                                child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey[200], // Background color while loading
                              backgroundImage: (data?.avatar != null && data!.avatar!.isNotEmpty)
                                  ? NetworkImage(data.avatar!)
                                  : const NetworkImage('https://via.placeholder.com/150'), // Fallback image
                            ))
                          ],
                        ) ,

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Bio - Everything is all right inshallah" , overflow:TextOverflow.ellipsis  , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold),),
                            ],
                          ),
                        )

                      ],
                    )
                  ],
                )) ,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(child: Icon(Icons.home ,)) ,
                    CircleAvatar(child: Icon(Icons.message)) ,
                    CircleAvatar(child: Icon(Icons.add)) ,
                    CircleAvatar(child: Icon(Icons.search)) ,
                    InkWell(
                      child: CircleAvatar(backgroundImage: (data?.avatar != null && data!.avatar!.isNotEmpty)
                          ? NetworkImage(data.avatar!)
                          : const NetworkImage('https://via.placeholder.com/150'),),
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}