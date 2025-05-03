# Recipe generator app

A new Flutter project.

1. Main Page (Splash Screen and Navigation)
SplashScreen: Displays a splash screen with a background image, a title ("Cook Like a Chef"), and a tagline. This screen responds to tap or swipe gestures, transitioning to the home screen.

HomeScreen: Contains a bottom navigation bar for navigating between different sections (Home, Favorites, Meal Plan, Diet Meal). The screen allows the user to interact with these sections and toggle favorite recipes.

2. Appview Page (Recipe Categories and Search)
Displays a list of recipes categorized by types like Continental, Chinese, etc.

Allows users to search for recipes, and filter them by category.

Displays a banner widget, and allows toggling favorites for recipes.

3. Favorites Page
Displays a list of favorite recipes.

Allows the user to view and remove recipes from the favorites list.

4. Meal Plan Wrapper and Meal Plan Page
MealPlanWrapper: If no ingredients are selected, it shows the IngredientSelector widget to choose ingredients. After selecting, it proceeds to the MealPlanPage.

MealPlanPage: Displays a meal plan for the week, allowing users to select meals for each day of the week. It uses the selected ingredients to recommend meals.

5. Ingredient Selector Widget
Allows users to choose ingredients they like, displaying images and labels for each ingredient. This helps tailor the meal plan based on the user's preferences.

6. Diet Plan Page
Shows a weekly diet plan with meals for each day of the week.

Allows users to set a weekly calorie goal and generates a diet plan based on that goal.

Displays breakfast, lunch, and dinner recipes based on the selected ingredients and calorie intake.

7. Recipe Detail Page
Displays detailed information about a recipe, including ingredients, instructions, and user reviews.

Users can add reviews and rate the recipe.

8. Banner Widget
Displays a banner at the top of the recipe list to encourage users to explore more recipes. It includes a button to navigate to the full list of recipes.
