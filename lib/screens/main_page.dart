
import 'package:eventhub_admin/screens/views/banners.dart';
import 'package:eventhub_admin/screens/views/dashbord.dart';
import 'package:eventhub_admin/screens/views/service_providers.dart';
import 'package:eventhub_admin/screens/views/service_seekers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import 'views/bookings.dart';
import 'views/feedbacks.dart';
import 'views/reports.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget _selectedItem = const DashbordScreen();
  String _selectedRoute = DashbordScreen.routeName;
  bool _isSidebarOpen = true;

  ScreenSelector(item) {
    switch (item.route) {
      case DashbordScreen.routeName:
        setState(() {
          _selectedItem = const DashbordScreen();
          _selectedRoute = DashbordScreen.routeName;
        });
        break;
      case ServiceSeekersScreen.routeName:
        setState(() {
          _selectedItem = const ServiceSeekersScreen();
          _selectedRoute = ServiceSeekersScreen.routeName;
        });
        break;
      case ServiceprovidersScreen.routeName:
        setState(() {
          _selectedItem = const ServiceprovidersScreen();
          _selectedRoute = ServiceprovidersScreen.routeName;
        });
        break;
      case BookingScreen.routeName:
        setState(() {
          _selectedItem = const BookingScreen();
          _selectedRoute = BookingScreen.routeName;
        });
        break;
      case BannerUploadScreen.routeName:
        setState(() {
          _selectedItem = BannerUploadScreen();
          _selectedRoute = BannerUploadScreen.routeName;
        });
        break;

      case FeedbackPage.routeName:
        setState(() {
          _selectedItem = FeedbackPage();
          _selectedRoute = FeedbackPage.routeName;
        });
        break;

        case ReportsPage.routeName:
        setState(() {
          _selectedItem = ReportsPage();
          _selectedRoute = ReportsPage.routeName;
        });
        break;

    }
  }

  void toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: toggleSidebar,
          icon: Icon(_isSidebarOpen ? Icons.menu : Icons.menu, color: Colors.white,),
        ),
        title: const Text('E V E N T   H U B', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isSidebarOpen ? 230 : 0,
            child: Visibility(
              visible: _isSidebarOpen,
              child: SideBar(
                items: const [
                  AdminMenuItem(
                    title: 'Dashboard',
                    icon: Icons.dashboard,
                    route: DashbordScreen.routeName,
                  ),
                  AdminMenuItem(
                    title: 'Service Seekers',
                    icon: CupertinoIcons.person_3,
                    route: ServiceSeekersScreen.routeName,
                  ),
                  AdminMenuItem(
                    title: 'Service Providers',
                    icon: CupertinoIcons.person_3_fill,
                    route: ServiceprovidersScreen.routeName,
                  ),
                  AdminMenuItem(
                    title: 'Bookings',
                    icon: CupertinoIcons.shopping_cart,
                    route: BookingScreen.routeName,
                  ),
                  AdminMenuItem(
                    title: 'Banner Upload',
                    icon: CupertinoIcons.add,
                    route: BannerUploadScreen.routeName,
                  ),
                  AdminMenuItem(
                    title: 'Feedbacks',
                    icon: Icons.feedback,
                    route: FeedbackPage.routeName,
                  ),
                  AdminMenuItem(
                    title: 'Reports',
                    icon: Icons.report,
                    route: ReportsPage.routeName,
                  ),
                ],
                selectedRoute: _selectedRoute,
                onSelected: (item) {
                  ScreenSelector(item);
                },
              ),
            ),
          ),
          Expanded(
            flex: _isSidebarOpen ? 5 : 5,
            child: _selectedItem,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleSidebar,
        child: Icon(_isSidebarOpen ? Icons.arrow_back : Icons.menu),
      ),
    );
  }
}

class SideBar extends StatelessWidget {
  final List<AdminMenuItem> items;
  final String selectedRoute;
  final Function(AdminMenuItem) onSelected;

  const SideBar({
    required this.items,
    required this.selectedRoute,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              
            ),
            child: Text('Admin Menu'),
          ),
          for (var item in items)
            Container(
              decoration: BoxDecoration(
                color: item.route == selectedRoute ? Colors.blue.shade200 : Colors.transparent,
              ),
              child: ListTile(
                title: Text(item.title),
                leading: Icon(item.icon),
                onTap: () => onSelected(item),
              ),
            ),
        ],
      ),
    );
  }
}


