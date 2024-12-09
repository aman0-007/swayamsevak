import 'package:go_router/go_router.dart';
import 'package:swayamsevak/components/bottomnav/bottomnavigation.dart';
import 'package:swayamsevak/main.dart';
import 'package:swayamsevak/pages/enrollment_page.dart';
import 'package:swayamsevak/pages/leaderpages/allstudents.dart';
import 'package:swayamsevak/pages/popages/addproject_page.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const CheckLoginState(),
    ),
    GoRoute(
      path: '/addEvent',
      builder: (context, state) => const AllStudentsPage(),
    ),
    GoRoute(
      path: '/addEvent',
      builder: (context, state) => const AllStudentsPage(),
    ),




    //=============================== PO =================================================
    GoRoute(
      path: '/poAddProject',
      builder: (context, state) => const AddProjectPage(),
    ),
  ],
);
