import 'package:flutter/material.dart';
import 'package:jollypodcast/theme/theme.dart';
import 'package:jollypodcast/ui/components/category_card.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> categories = [
    {'title': 'ARTS', 'image': 'assets/images/arts.jpg'},
    {'title': 'BUSINESS', 'image': 'assets/images/business.jpg'},
    {'title': 'COMEDY', 'image': 'assets/images/comedy.jpg'},
    {'title': 'EDUCATION', 'image': 'assets/images/education.jpg'},
    {'title': 'HEALTH & FITNESS', 'image': 'assets/images/health_fitness.jpg'},
    {'title': 'MUSIC', 'image': 'assets/images/music.jpg'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.forestGreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Text(
              'All podcast categories',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search keyword or name',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Categories Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryCard(
                    title: categories[index]['title']!,
                    imagePath: categories[index]['image']!,
                    onTap: () {
                      print('Tapped on ${categories[index]['title']}');
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
