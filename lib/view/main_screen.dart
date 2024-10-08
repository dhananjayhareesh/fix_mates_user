import 'package:fix_mates_user/bloc/BottomNav/bloc/bottom_nav_bloc.dart';
import 'package:fix_mates_user/view/booking_screens/booking_detail_list_screen.dart';
import 'package:fix_mates_user/view/chat_screens/chat_screen.dart';
import 'package:fix_mates_user/view/homescreen.dart';
import 'package:fix_mates_user/view/profile_screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final List<Widget> _pages = [
    HomeScreen(),
    BookingDetailListScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavBloc(),
      child: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          return Scaffold(
            body: _pages[state.selectedIndex],
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: BottomNavigationBar(
                  currentIndex: state.selectedIndex,
                  onTap: (index) {
                    context
                        .read<BottomNavBloc>()
                        .add(BottomNavItemSelected(index));
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                      ),
                      label: 'Bookings',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.chat,
                        color: Colors.white,
                      ),
                      label: 'Support',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      label: 'Profile',
                    ),
                  ],
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white60,
                  selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelStyle:
                      TextStyle(fontWeight: FontWeight.normal),
                  backgroundColor: Colors.blueAccent,
                  type: BottomNavigationBarType.fixed,
                  elevation: 10,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  selectedFontSize: 14,
                  unselectedFontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
