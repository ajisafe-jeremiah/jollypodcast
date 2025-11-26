import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jollypodcast/constants.dart';
import 'package:jollypodcast/models/app_page.dart';
import 'package:jollypodcast/repo/auth_repository.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key, required this.child}) : super(key: key);
  final Widget child;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final List<AppPage> pages = [
    const AppPage(
      label: "Discover",
      icon: "assets/icons/hotspot.png",
      routeName: kHomePath,
    ),
    const AppPage(
      label: "Categories",
      icon: "assets/icons/category.png",
      routeName: kCategoryPath,
    ),
    const AppPage(
      label: "Your Library",
      icon: "assets/icons/library.png",
      routeName: kLibraryPath,
    ),
  ];

  int _getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;

    if (location.startsWith(kHomePath)) return 0;
    if (location.startsWith(kCategoryPath)) return 1;
    if (location.startsWith(kLibraryPath)) return 2;

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF0A1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1E1E),
        elevation: 0,
        title: Image.asset('assets/images/jolly.png', height: 32),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF8B9D9D),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile Avatar
                GestureDetector(
                  onTap: () async {
                    final authRepo = context
                        .read<AuthRepository>(); 

                    await authRepo.logout();

                    if (context.mounted) {
                      context.go(
                        '/login',
                      );
                    }
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFF8B9D9D),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/profile.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            color: Color(0xFF8B9D9D),
                            size: 16,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Notification Bell
                GestureDetector(
                  onTap: () {
                    // TODO: Implement notifications
                  },
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                // Search Icon
                GestureDetector(
                  onTap: () {
                    // TODO: Implement search
                  },
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: _buildBottomNavBar(context, currentIndex),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F2626),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: pages.asMap().entries.map((entry) {
              final index = entry.key;
              final page = entry.value;
              return _buildNavItem(context, page, index, currentIndex == index);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    AppPage page,
    int index,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          context.go(page.routeName);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon from asset
            Image.asset(
              page.icon,
              width: 24,
              height: 24,
              color: isSelected ? const Color(0xFF88D66C) : Colors.white54,
            ),
            const SizedBox(height: 4),
            Text(
              page.label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF88D66C) : Colors.white54,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
