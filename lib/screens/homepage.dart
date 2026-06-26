import 'package:flutter/material.dart';
import 'package:groupin/provider/Global.provider.dart';
import 'package:groupin/provider/userlogin.provider.dart';
import 'package:provider/provider.dart';

//  1. FIX: Import your actual routes file instead of aliasing the dio client
import '../routes/routes.dart';

class Homepage extends StatefulWidget {
  final String userId;
  const Homepage({super.key, required this.userId});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _postMessage = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _postMessage.dispose(); //  2. FIX: Dispose of post message controller too
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final watch = context.watch<UserLoginProvider>();
    final watch2 = context.watch<GlobalValueProvider>();
    final _isDark = watch2.getisDarkMode();
    final data = watch.user;

    final Color adaptiveTextColor = _isDark ? Colors.white : Colors.black;
    final Color adaptiveSubtextColor = _isDark ? Colors.white70 : Colors.black54;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: _isDark ? Colors.black : Colors.white,
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          height: double.infinity,
          width: screenWidth > 800 ? screenWidth * 0.6 : screenWidth,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _showLogoutConfirmation(context),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: (data?.avatarUrl != null && data!.avatarUrl!.isNotEmpty)
                              ? NetworkImage(data.avatarUrl!)
                              : const NetworkImage('https://via.placeholder.com/150'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _searchController,
                          style: TextStyle(color: adaptiveTextColor),
                          decoration: InputDecoration(
                            hintText: 'Search or type here...',
                            hintStyle: TextStyle(color: adaptiveSubtextColor),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: Icon(Icons.notifications_none_outlined, color: adaptiveTextColor),
                        onPressed: () => print("Search text: ${_searchController.text}"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 18,
                    width: double.infinity,
                    child: Divider(thickness: 2, color: _isDark ? Colors.white24 : Colors.grey[300]),
                  ),

                  // --- Feed Content ---
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(child: Icon(Icons.person, color: Colors.white)),
                                  const SizedBox(width: 5),
                                  Text(
                                      data?.fullName ?? "Guest User",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: adaptiveTextColor)
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "20/10/2026 5 PM",
                                  style: TextStyle(fontSize: 15, color: adaptiveSubtextColor),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: _isDark ? Colors.white10 : Colors.grey[100],
                                    border: Border.all(color: _isDark ? Colors.white24 : Colors.black12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "This is adaptive layout text matching the dark or light system theme configuration settings seamlessly.",
                                          style: TextStyle(fontSize: 16, color: adaptiveTextColor),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Icon(Icons.favorite_border, color: adaptiveTextColor, size: 26),
                                            const SizedBox(width: 16),
                                            InkWell(
                                              onTap: () => _showCommentsBottomSheet(context, _isDark),
                                              child: Icon(Icons.chat_bubble_outline, color: adaptiveTextColor, size: 26),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
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

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (alertContext) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(alertContext), child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                Navigator.pop(alertContext);

                // 1. Wipe state session
                Provider.of<UserLoginProvider>(context, listen: false).logout();

                // 2. Erase the route history and go back to login screen safely
                Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, //  3. FIX: Keep behind container clip rounded
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.white, //  4. FIX: Adaptive bottom sheet theme
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                        "Comments",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.person)),
                          title: Text("User $index", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                          subtitle: Text("Wow, this UI really is beautiful!", style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}