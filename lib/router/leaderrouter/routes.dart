import 'package:go_router/go_router.dart';
import 'package:swayamsevak/components/bottomnav/bottomnavigation.dart';
import 'package:swayamsevak/pages/leaderpages/allstudents.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const BottomNavApp(),
    ),
    GoRoute(
      path: '/addEvent',
      builder: (context, state) => const AllStudentsPage(),
    ),
    GoRoute(
      path: '/addEvent',
      builder: (context, state) => const AllStudentsPage(),
    ),
    GoRoute(
      path: '/confirmStudent',
      builder: (context, state) => const AllStudentsPage(),
    ),
  ],
);
