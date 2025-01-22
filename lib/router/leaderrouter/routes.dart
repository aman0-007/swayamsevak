import 'package:go_router/go_router.dart';
import 'package:swayamsevak/main.dart';
import 'package:swayamsevak/pages/enrollment_page.dart';

import '../../pages/leaderpages/leader_dashboard/leader_dashboard.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const EnrollmentPage(),
      //builder: (context, state) => const LeaderDashboard(),
    ),
  ],
);
