import 'package:nutriscan/features/auth/presentation/onboarding_allergies_page.dart';
import 'package:nutriscan/features/auth/presentation/onboarding_finishing_page.dart';
import 'package:nutriscan/features/auth/presentation/sign_in_page.dart';
import 'package:nutriscan/features/auth/presentation/sign_up_page.dart';
import 'package:nutriscan/features/common/presentation/pages/splash_page.dart';
import 'package:nutriscan/features/donation/presentation/pages/add_donation/add_donation_page.dart';
import 'package:nutriscan/features/donation/presentation/pages/donation_page.dart';
import 'package:nutriscan/features/foods/presentation/pages/food_detail/food_detail_page.dart';
import 'package:nutriscan/features/foods/presentation/pages/home/home_page.dart';
import 'package:go_router/go_router.dart';
import 'package:nutriscan/features/foods/presentation/pages/scan/scan_page.dart';

// GoRouter configuration
final app_router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'splash',
      path: '/',
      builder: (context, state) => SplashPage(),
    ),
    GoRoute(
      name: 'sign-in',
      path: '/sign-in',
      builder: (context, state) => SignInPage(),
    ),
    GoRoute(
      name: 'sign-up',
      path: '/sign-up',
      builder: (context, state) => SignUpPage(),
    ),
    GoRoute(
      name: 'onboarding-allergies',
      path: '/onboarding-allergies',
      builder: (context, state) => OnboardingAllergiesPage(),
    ),
    GoRoute(
      name: 'onboarding-finishing',
      path: '/onboarding-finishing',
      builder: (context, state) => OnboardingFinishing(),
    ),
    GoRoute(
      name: 'home',
      path: '/home',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      name: 'food_details',
      path: '/food/:id',
      builder: (context, state) =>
          FoodDetailsPage(foodId: int.parse(state.pathParameters["id"] ?? "1")),
    ),
    GoRoute(
      name: 'scan',
      path: '/scan',
      builder: (context, state) => ScanPage(),
    ),
    GoRoute(
      name: 'donation',
      path: '/donation',
      builder: (context, state) => DonationPage(),
    ),
    GoRoute(
      name: 'add-donation',
      path: '/add-donation',
      builder: (context, state) => AddDonationPage(),
    ),
  ],
);
