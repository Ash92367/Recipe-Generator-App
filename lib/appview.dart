import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'Widgets/banner.dart';
import 'all_recipes.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Appview extends StatefulWidget {
  final Function(Map<String, dynamic>) onToggleFavorite;
  final bool Function(Map<String, dynamic>) isFavorite;

  const Appview({
    super.key,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  @override
  State<Appview> createState() => _AppviewState();
}

class _AppviewState extends State<Appview> {
  final List<Map<String, dynamic>> categories = [
    {'label': 'All', 'isSelected': true},
    {'label': 'Continental', 'isSelected': false},
    {'label': 'Chinese', 'isSelected': false},
    {'label': 'Breakfast', 'isSelected': false},
    {'label': 'Dessert', 'isSelected': false},
    {'label': 'Pakistani', 'isSelected': false},
  ];

  List<Map<String, dynamic>> recipeItems = [];
  String selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadRecipeItems();
  }

  void loadRecipeItems() async {
    try {
      final String jsonStr = await rootBundle.loadString('assets/recipes.json');
      final List<dynamic> data = json.decode(jsonStr);
      setState(() {
        recipeItems = data.map((item) => Map<String, dynamic>.from(item)).toList();
      });
    } catch (e) {
      print('Error loading JSON: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        title: Text(
          "What are you cooking today?",
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.notification, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: recipeItems.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              const BannerWidget(),
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.trim().toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search ... ",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildCategories(),
              const SizedBox(height: 20),
              _buildSectionTitle(context),
              const SizedBox(height: 10),
              _buildRecipeList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Categories",
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      for (var cat in categories) {
                        cat['isSelected'] = false;
                      }
                      category['isSelected'] = true;
                      selectedCategory = category['label'];
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: category['isSelected'] ? Colors.yellow : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      category['label'],
                      style: TextStyle(
                        color: category['isSelected'] ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Quick & Easy",
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllRecipesPage(
                  recipes: recipeItems,
                  isFavorite: widget.isFavorite,
                  onToggleFavorite: widget.onToggleFavorite,
                ),
              ),
            );
          },
          child: Text(
            "See All",
            style: GoogleFonts.lato(
              fontSize: 14,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeList() {
    List<Map<String, dynamic>> filteredRecipes = recipeItems.where((recipe) {
      final recipeCategory = recipe['category']?.toString().toLowerCase().trim() ?? '';
      final recipeName = recipe['name']?.toString().toLowerCase().trim() ?? '';
      final selected = selectedCategory.toLowerCase().trim();

      final matchesCategory = selected == 'all' || recipeCategory == selected;
      final matchesSearch = searchQuery.isEmpty ||
          recipeName.contains(searchQuery) ||
          recipeCategory.contains(searchQuery);

      return matchesCategory && matchesSearch;
    }).toList();

    if (selectedCategory == 'All' && searchQuery.isEmpty) {
      filteredRecipes = filteredRecipes.take(5).toList(); // Limit to 5 by default
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredRecipes.length,
      itemBuilder: (context, index) {
        final recipe = filteredRecipes[index];
        final isFav = widget.isFavorite(recipe);

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                recipe['image'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              recipe['name'],
              style: GoogleFonts.lato(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${recipe['calories']} • ${recipe['time']}'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                isFav ? Iconsax.heart5 : Iconsax.heart,
                color: isFav ? Colors.red : Colors.black,
              ),
              onPressed: () {
                widget.onToggleFavorite(recipe);
                setState(() {});
              },
            ),
          ),
        );
      },
    );
  }
}
