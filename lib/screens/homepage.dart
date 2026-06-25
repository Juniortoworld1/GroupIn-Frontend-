import 'package:flutter/material.dart';
import 'package:groupin/provider/Global.provider.dart';
import 'package:groupin/provider/userlogin.provider.dart';
import 'package:groupin/utils/inputfield.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  final String userId;
  const Homepage({super.key, required this.userId});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;
  // Initialize the controller cleanly
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _postMessage = TextEditingController() ;

  @override
  void initState() {
    super.initState();
  }

  // CRITICAL: Always dispose of text controllers to prevent memory leaks
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final watch = context.watch<UserLoginProvider>();
    final watch2 = context.watch<GlobalValueProvider>();
    final _isDark = watch2.getisDarkMode();
    final data = watch.user;

    final screenHeight = MediaQuery.sizeOf(context).height ;
    final screenWidth = MediaQuery.sizeOf(context).width;
    print("\n\n\n\n\n\n\n${data?.avatarUrl}\n\n\n\n\n\n") ;
    return Scaffold(
      backgroundColor: _isDark ? Colors.black : Colors.white,
      // FIX 1: Wrap in SafeArea to protect your widgets from notches and status bars
      body: Center(
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          height: double.infinity,
          width: screenWidth>800?screenWidth*0.6:screenWidth,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: data?.avatarUrl != null
                              ? NetworkImage(data!.avatarUrl!)
                              : const NetworkImage('https://placeholder.com'),
                        ),
                      ),

                      // Horizontal spacer between avatar and text field
                      const SizedBox(width: 12),

                      // 2. Middle Text Form Field
                      Expanded(
                        child: TextFormField(
                          // FIX 3: Linked your declared controller to the actual field
                          controller: _searchController,
                          style: TextStyle(color: _isDark ? Colors.white : Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Search or type here...',
                            hintStyle: TextStyle(color: _isDark ? Colors.white54 : Colors.black54),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),

                      // Horizontal spacer between text field and notification icon
                      const SizedBox(width: 12),

                      // 3. Notification Icon (Right aligned)
                      IconButton(
                        icon: Icon(
                          Icons.notifications_none_outlined,
                          // FIX 4: Ensured the icon respects your dark mode value
                          color: _isDark ? Colors.white : Colors.black,
                        ),
                        onPressed: () {
                          // Handle your notification tap logic here
                          print("Search text: ${_searchController.text}");
                        },
                      ),
                    ],
                  ) ,
                  SizedBox(height: 18, width: double.infinity, child: Divider(thickness: 2 ,indent: 0, color: _isDark?Colors.white70:Colors.grey,),),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 8,) ,
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  // FIX 3: Linked your declared controller to the actual field
                                  controller: _postMessage,
                                  style: TextStyle(color: _isDark ? Colors.white : Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "What's in your mind ? ",
                                    hintStyle: TextStyle(color: _isDark ? Colors.white54 : Colors.black54),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 5,) ,
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: _isDark?Colors.white:Colors.black ,


                                ),
                                  child: Icon(Icons.add , color: _isDark?Colors.black :Colors.white,))
                            ],
                          ),


                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8,) ,
                              Row(
                                children: [
                                  CircleAvatar(child: Icon(Icons.person , color: Colors.white,),),
                                  SizedBox(width: 5,) ,
                                  Text("Soyeb Akhtar " , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold, color: Colors.white))
                                ],
                              ) ,
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("20/10/2026   5 PM" , style: TextStyle(fontSize: 15 , color: Colors.white),),
                              ) ,
                              SizedBox(height: 3,) ,
                              Center(
                                child: Container(
                                  child: Image.asset('asserts/images/screenshot2.png'),
                                ),
                              ) ,

                              SizedBox(height: 8,) ,

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20) ,
                                      color: Colors.black12,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1.0, // Optional: defaults to 1.0
                                      ),
                                    boxShadow: [BoxShadow(
                                      blurRadius: 4 ,
                                      blurStyle: BlurStyle.outer ,
                                      spreadRadius: 3
                                    )]
                                  ),

                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            child: Text("This is the most beautiful ui i have created without the use of ai ",
                                              softWrap: true, overflow: TextOverflow.clip,style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold , color: Colors.white,) ,
                                            )
                                        ) ,

                                        Row(
                                          children: [
                                            Container(
                                                child: Icon(Icons.heart_broken , color: Colors.white, size: 30,)
                                            ),
                                            SizedBox(width: 16,) ,
                                            Container(child : Icon(Icons.message, color: Colors.white, size: 30,))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ) ,

                            ],
                          ) ,


                        ],
                      ),
                    ),
                  )


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
