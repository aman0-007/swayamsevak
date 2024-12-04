import 'package:go_router/go_router.dart';
import 'package:swayamsevak/pages/leaderpages/allstudents.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/allStudents',
      builder: (context, state) => const AllStudentsPage(),
    ),
  ],
);
