import 'package:flutter/material.dart';
import 'package:groupin/screens/signup.dart';
import 'package:provider/provider.dart';
import '../provider/Global.dart';
import 'login.dart';

class Auth_Login_Signup extends StatefulWidget {
  const Auth_Login_Signup({super.key});

  @override
  State<Auth_Login_Signup> createState() => _Auth_Login_Signup();
}

class _Auth_Login_Signup extends State<Auth_Login_Signup> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final providerValue = context.watch<GlobalValueProvider>();
    final _isDark = providerValue.getisDarkMode() ;

    return Scaffold(
        backgroundColor: _isDark?Color(0xFF0B0F19):Color(0xFFB1D3B9)  ,
        body: SafeArea(

           // Ensures the white container bleeds cleanly to the absolute bottom edge
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: FloatingActionButton(onPressed: (){
                    context.read<GlobalValueProvider>().modeChanger() ;
                  } , child: _isDark?Icon(Icons.dark_mode , color: Color(0xFFB1D3B9),):Icon(Icons.light_mode , color: Color(0xFF0B0F19),) ,),
                ),
              ) ,

              const SizedBox(height: 40),

              // 1. Top Circle Icon
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color:_isDark? Color(0xFFB1D3B9):Color(0xFF0B0F19),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.group , color: _isDark?Color(0xFF0B0F19):Color(0xFFB1D3B9)),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Connect Your Friend "  , style: TextStyle(fontSize: 20 , color: _isDark?Colors.white:Colors.black , fontWeight: FontWeight.bold),),
                      SizedBox(width: 10,) ,
                      Icon(Icons.group , color: _isDark?Color(0xFFB1D3B9):Color(0xFF0B0F19),)
                    ],
                  ) ,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Connect You Future" , style: TextStyle(fontSize: 18 , color: _isDark?Colors.white:Colors.black , fontWeight: FontWeight.bold )),
                      SizedBox(width: 10,) ,
                      Icon(Icons.next_plan , color: _isDark?Color(0xFFB1D3B9):Color(0xFF0B0F19))
                    ],
                  )
                ],
              ) ,

              // 2. The Invisible Spring - Pushes everything below it down

              // 3. The Form Container Card
              Expanded( // CRITICAL: This gives FractionallySizedBox the defined space it needs!
                child: AnimatedFractionallySizedBox(
                  duration: Duration(seconds: 1),
                  heightFactor: _currentIndex==0?0.67:0.8, // Adjust this decimal (0.0 to 1.0) to change how high the white sheet goes
                  widthFactor: 1.0,   // Keeps it full width so your input textfields aren't squished
                  alignment: Alignment.bottomCenter, // Keeps the card stuck to the bottom of the screen
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: _isDark?Color(0xFF1F2937):Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _Controller("Login", 0),
                              _Controller("Signup", 1)
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Expanded + SingleChildScrollView handles the long list of inputs when the keyboard appears
                          Expanded(
                            child: _currentIndex == 0
                                ? Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: IndexedStack(
                                index: _currentIndex,
                                children: const [
                                  LoginForm(),
                                  SignupForm(),
                                ],
                              ),
                            )
                                : SingleChildScrollView(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: IndexedStack(
                                index: _currentIndex,
                                children: const [
                                  LoginForm(),
                                  SignupForm(),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }

  Widget _Controller(String title , int index){
    bool _isselected = _currentIndex == index;
    return GestureDetector(
      onTap: (){
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15) ,
            color: _isselected?Colors.yellowAccent:Colors.transparent
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(title, style: TextStyle(fontSize: 22, fontWeight: _isselected ? FontWeight.bold : FontWeight.w500),),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 4,
                width: 40,
                color: _isselected ? Colors.blue : Colors.transparent,
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Keep your LoginForm and SignupForm classes exactly as they are.
