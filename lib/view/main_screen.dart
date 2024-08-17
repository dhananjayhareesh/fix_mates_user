import 'package:fix_mates_user/bloc/BottomNav/bloc/bottom_nav_bloc.dart';
import 'package:fix_mates_user/view/booking_screens/booking_detail_screen.dart';
import 'package:fix_mates_user/view/chat_screens/chat_screen.dart';
import 'package:fix_mates_user/view/homescreen.dart';
import 'package:fix_mates_user/view/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final List<Widget> _pages = [
    HomeScreen(),
    BookingDetailScreen(),
    ChatScreen(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavBloc(),
      child: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          return Scaffold(
            body: _pages[state.selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.selectedIndex,
              onTap: (index) {
                context.read<BottomNavBloc>().add(BottomNavItemSelected(index));
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: Color.fromARGB(255, 2, 66, 176),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.calendar_month,
                    color: Color.fromARGB(255, 2, 66, 176),
                  ),
                  label: 'Bookings',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat,
                    color: Color.fromARGB(255, 2, 66, 176),
                  ),
                  label: 'Support',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    color: Color.fromARGB(255, 2, 66, 176),
                  ),
                  label: 'Profile',
                ),
              ],
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              backgroundColor: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
