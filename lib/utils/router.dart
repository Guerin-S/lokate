import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
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
import '../screens/owner/edit_property_screen.dart';
import '../screens/subscription/subscription_screen.dart';
import '../models/models.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  debugLogDiagnostics: false,
  redirect: (context, state) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final isLoggedIn = authService.isLoggedIn;
    final loggingIn = state.matchedLocation.startsWith('/auth') ||
        state.matchedLocation == '/splash' ||
        state.matchedLocation == '/onboarding';

    if (!isLoggedIn && !loggingIn) return '/auth/login';
    if (isLoggedIn && loggingIn && state.matchedLocation != '/splash') {
      return '/home';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),

    // Auth routes
    GoRoute(path: '/auth/login', builder: (_, __) => const LoginScreen()),
    GoRoute(
      path: '/auth/register',
      builder: (_, state) => RegisterScreen(
        initialAuthMethod:
            state.uri.queryParameters['method'] == 'phone' ? 1 : 0,
      ),
    ),
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
        GoRoute(
            path: '/owner/dashboard',
            builder: (_, __) => const OwnerDashboardScreen()),
      ],
    ),

    // Property
    GoRoute(
      path: '/property/:id',
      builder: (_, state) =>
          PropertyDetailScreen(propertyId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/property/:id/tour',
      builder: (_, state) =>
          VirtualTourScreen(propertyId: state.pathParameters['id']!),
    ),
    GoRoute(path: '/filters', builder: (_, __) => const FilterScreen()),

    // Booking
    GoRoute(
      path: '/booking/:propertyId',
      builder: (_, state) =>
          BookingScreen(propertyId: state.pathParameters['propertyId']!),
    ),
    GoRoute(
      path: '/payment/:reservationId',
      builder: (_, state) =>
          PaymentScreen(reservationId: state.pathParameters['reservationId']!),
    ),
    GoRoute(
      path: '/contract/:reservationId',
      builder: (_, state) =>
          ContractScreen(reservationId: state.pathParameters['reservationId']!),
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
    GoRoute(
        path: '/owner/add-property',
        builder: (_, __) => const AddPropertyScreen()),
    GoRoute(
        path: '/owner/edit-property',
        builder: (_, state) => EditPropertyScreen(property: state.extra as Property)),
    GoRoute(
        path: '/owner/reservations',
        builder: (_, __) => const OwnerReservationsScreen()),
    GoRoute(path: '/subscription', builder: (_, __) => const SubscriptionScreen()),
  ],
);
