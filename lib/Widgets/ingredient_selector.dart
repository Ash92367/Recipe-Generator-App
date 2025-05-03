// lib/widgets/ingredient_selector.dart
import 'package:flutter/material.dart';
import '../globals.dart'; // to use selectedIngredients

class IngredientSelector extends StatefulWidget {
  final VoidCallback onNext;

  const IngredientSelector({Key? key, required this.onNext}) : super(key: key);

  @override
  State<IngredientSelector> createState() => _IngredientSelectorState();
}

class _IngredientSelectorState extends State<IngredientSelector> {
  final List<Map<String, String>> ingredients = [
    {"label": "Cabbage", "image": "assets/ingredients/cabbage.jpg"},
    {"label": "Chicken", "image": "assets/ingredients/chicken.jpg"},
    {"label": "Meat", "image": "assets/ingredients/meat.jpg"},
    {"label": "Egg", "image": "assets/ingredients/egg.jpg"},
    {"label": "Broccoli", "image": "assets/ingredients/broccoli.jpg"},
    {"label": "Corn", "image": "assets/ingredients/corn.jpg"},
    {"label": "Carrot", "image": "assets/ingredients/carrot.jpg"},
    {"label": "Sweet Potato", "image": "assets/ingredients/sweet_potato.jpg"},
    {"label": "Lettuce", "image": "assets/ingredients/lettuce.jpg"},
  ];

  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Lets Start..",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const LinearProgressIndicator(value: 0.5),
            const SizedBox(height: 20),
            const Text(
              "What ingredients you love the most",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "You can choose more than 1 answer",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: ingredients.map((ingredient) {
                  final isSelected = _selected.contains(ingredient['label']);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selected.remove(ingredient['label']);
                        } else {
                          _selected.add(ingredient['label']!);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.lightGreen[100] : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.green : Colors.grey[300]!,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                ingredient['image']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            ingredient['label']!,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.green : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                selectedIngredients = _selected.toList(); // Save globally
                widget.onNext(); // Call callback
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Next", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
