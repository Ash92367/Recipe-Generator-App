import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../globals.dart';
import 'Widgets/ingredient_selector.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class MealPlanPage extends StatefulWidget {
  const MealPlanPage({super.key});

  @override
  State<MealPlanPage> createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  bool showSelector = selectedIngredients.isEmpty;
  String selectedMeal = 'Breakfast';
  final List<String> meals = ['Breakfast', 'Lunch', 'Dinner'];

  List<Map<String, dynamic>> allRecipes = [];

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  Future<void> loadRecipes() async {
    final String data = await rootBundle.loadString('assets/meals.json');
    final List<dynamic> jsonResult = json.decode(data);
    setState(() {
      allRecipes = List<Map<String, dynamic>>.from(jsonResult);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSelector) {
      return IngredientSelector(onNext: () {
        setState(() {
          showSelector = false;
        });
      });
    }

    final filtered = allRecipes.where((recipe) {
      return recipe['meal'] == selectedMeal;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Meal Plan",
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Recommended for You Based on the ingredients of your choice........",
              style:
              GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: allRecipes
                  .where((recipe) => recipe['ingredients'].any(
                      (ing) => selectedIngredients.contains(ing)))
                  .map((recipe) => _buildRecommendedCard(recipe))
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
          _buildMealTabs(),
          const SizedBox(height: 10),
          ...filtered.map((meal) => _buildMealCard(meal)).toList(),
        ],
      ),
    );
  }

  Widget _buildRecommendedCard(Map<String, dynamic> recipe) {
    return SizedBox(
      width: 200,
      height: 220,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset(
                recipe['image'] ?? 'assets/placeholder.jpg',
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe['name'],
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${recipe['calories']} Cal",
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

// tapping each recipe anywhere in the app should open the specific recipe page for that speciifc recipe ,
// that widget can be stored and reused again and again but for that the recipe.json file should have
// the required contenct for that page, all we aim to make is a ui, basically mam needs to know k what we
// intend to do with this app and i think doing this  will work for now
  Widget _buildMealTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: meals.map((meal) {
        final isSelected = meal == selectedMeal;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedMeal = meal;
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Text(
              meal,
              style: GoogleFonts.lato(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(
              meal['image'] ?? 'assets/placeholder.jpg',
              height: 200,
              width: 400,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal['name'],
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _nutrientStat("Calories", "${meal['calories']}"),
                    _nutrientStat("Protein", "${meal['protein']}g"),
                    _nutrientStat("Carbs", "${meal['carbs']}g"),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _nutrientStat(String label, String value) {
    return Column(
      children: [
        Text(value,
            style:
            GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: GoogleFonts.lato(color: Colors.grey[600])),
      ],
    );
  }
}
