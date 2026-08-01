import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/auth/splash_screen.dart';
import '../screens/auth/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/home/main_shell.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/map_screen.dart';
import '../screens/property/property_detail_screen.dart';
import '../screens/property/virtual_tour_screen.dart';
import '../screens/property/filter_screen.dart';
import '../screens/booking/booking_screen.dart';
import '../screens/booking/payment_screen.dart';
import '../screens/booking/contract_screen.dart';
import '../screens/chat/chat_list_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/review_screen.dart';
import '../screens/owner/add_property_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final loggingIn = state.matchedLocation.startsWith('/auth') ||
        state.matchedLocation == '/splash' ||
        state.matchedLocation == '/onboarding';

    if (user == null && !loggingIn) return '/auth/login';
    if (user != null && loggingIn && state.matchedLocation != '/splash') {
      return '/home';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),

    // Auth routes
    GoRoute(path: '/auth/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/auth/register', builder: (_, __) => const RegisterScreen()),
    GoRoute(
      path: '/auth/otp',
      builder: (_, state) => OtpScreen(phone: state.extra as String),
    ),

    // Main shell with bottom nav
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (_, __, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/map', builder: (_, __) => const MapScreen()),
        GoRoute(path: '/messages', builder: (_, __) => const ChatListScreen()),
        GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
        GoRoute(path: '/owner/dashboard', builder: (_, __) => const OwnerDashboardScreen()),
      ],
    ),

    // Property
    GoRoute(
      path: '/property/:id',
      builder: (_, state) => PropertyDetailScreen(propertyId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/property/:id/tour',
      builder: (_, state) => VirtualTourScreen(propertyId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/filters', builder: (_, __) => const FilterScreen()),

    // Booking
    GoRoute(
      path: '/booking/:propertyId',
      builder: (_, state) => BookingScreen(propertyId: state.pathParameters['propertyId']!),
    ),
    GoRoute(
      path: '/payment/:reservationId',
      builder: (_, state) => PaymentScreen(reservationId: state.pathParameters['reservationId']!),
    ),
    GoRoute(
      path: '/contract/:reservationId',
      builder: (_, state) => ContractScreen(reservationId: state.pathParameters['reservationId']!),
    ),

    // Chat
    GoRoute(
      path: '/chat/:chatId',
      builder: (_, state) => ChatScreen(
        chatId: state.pathParameters['chatId']!,
        otherUserName: (state.extra as Map?)?['name'] ?? '',
      ),
    ),

    // Reviews
    GoRoute(
      path: '/review/:targetId',
      builder: (_, state) => ReviewScreen(
        targetId: state.pathParameters['targetId']!,
        targetType: (state.extra as Map?)?['type'] ?? 'property',
      ),
    ),

    // Owner
    GoRoute(path: '/owner/add-property', builder: (_, __) => const AddPropertyScreen()),
    GoRoute(path: '/owner/reservations', builder: (_, __) => const OwnerReservationsScreen()),
  ],
);
