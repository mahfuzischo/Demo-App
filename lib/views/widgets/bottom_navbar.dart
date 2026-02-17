import 'package:demo_app/viewModels/authentication_view_model.dart';
import 'package:demo_app/views/community_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavbar extends ConsumerStatefulWidget {
  const BottomNavbar({super.key});

  @override
  ConsumerState<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends ConsumerState<BottomNavbar> {
  int currentScreen = 0;
  List<Widget> screens = [CommunityView()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          if (value == 1) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Logout"),
                  content: Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        ref
                            .read(authenticationViewModelProvider.notifier)
                            .logout();
                        Navigator.pop(context);
                      },
                      child: Text("Yes"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("No"),
                    ),
                  ],
                );
              },
            );
          } else {
            setState(() {
              currentScreen = value;
            });
          }
        },
        currentIndex: currentScreen,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
        ],
      ),
      body: screens[currentScreen],
    );
  }
}
