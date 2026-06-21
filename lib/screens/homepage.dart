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
