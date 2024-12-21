import 'package:go_router/go_router.dart';
import 'package:swayamsevak/main.dart';
import 'package:swayamsevak/pages/enrollment_page.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const EnrollmentPage(),
    ),
  ],
);
