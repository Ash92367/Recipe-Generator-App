import 'package:flutter/material.dart';
import '../globals.dart';
import '../widgets/ingredient_selector.dart';
import 'meal_plan.dart'; // your actual page

class MealPlanWrapper extends StatefulWidget {
  const MealPlanWrapper({Key? key}) : super(key: key);

  @override
  State<MealPlanWrapper> createState() => _MealPlanWrapperState();
}

class _MealPlanWrapperState extends State<MealPlanWrapper> {
  @override
  Widget build(BuildContext context) {
    if (selectedIngredients.isEmpty) {
      return IngredientSelector(
        onNext: () {
          setState(() {}); // Refresh the widget to go to MealPlanPage
        },
      );
    } else {
      return const MealPlanPage();
    }
  }
}
