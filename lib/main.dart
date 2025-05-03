import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'appview.dart'; // You must have this
import 'favorites.dart'; // <-- We will define this below
import 'meal_plan.dart';
import 'meal_plan_wrapper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        },
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset("assets/foodbg.jpg", fit: BoxFit.cover),
            Container(color: Colors.black.withOpacity(0.2)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Cook Like a Chef",
                  style: GoogleFonts.bebasNeue(
                    fontSize: 50,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [Colors.orange, Colors.yellow],
                      ).createShader(Rect.fromLTWH(0.0, 0.0, 300.0, 70.0)),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    "Transform Your Ingredients into Culinary Magic!\nDiscover, Create, and Share Recipes Tailored Just for You!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Icon(Icons.arrow_downward, size: 40, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  List<Map<String, dynamic>> favoriteRecipes = [];

  void toggleFavorite(Map<String, dynamic> recipe) {
    setState(() {
      final exists = favoriteRecipes.any((r) => r['name'] == recipe['name']);
      if (exists) {
        favoriteRecipes.removeWhere((r) => r['name'] == recipe['name']);
      } else {
        favoriteRecipes.add(recipe);
      }
    });
  }

  bool isFavorite(Map<String, dynamic> recipe) {
    return favoriteRecipes.any((r) => r['name'] == recipe['name']);
  }


  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      Appview(
        onToggleFavorite: toggleFavorite,
        isFavorite: isFavorite,
      ),
      FavoritesPage(
        favorites: favoriteRecipes,
        onToggleFavorite: toggleFavorite,
      ),
      MealPlanWrapper(),
      navBarPage(Iconsax.calendar),
      navBarPage(Iconsax.add),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconSize: 28,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.yellowAccent[200],
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(color: Colors.black),
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(selectedIndex == 0 ? Icons.home : Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(selectedIndex == 1 ? Icons.favorite : Icons.favorite_border),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(selectedIndex == 2 ? Icons.calendar_today : Icons.calendar_today_outlined),
            label: 'Meal Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(selectedIndex == 3 ? Icons.create : Icons.create_outlined),
            label: 'Custom Recipe',
          ),
        ],
      ),
      body: pages[selectedIndex],
    );
  }

  Widget navBarPage(IconData icon) {
    return Center(
      child: Icon(icon, size: 100, color: Colors.black),
    );
  }
}
