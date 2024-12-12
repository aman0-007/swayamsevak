import 'package:go_router/go_router.dart';
import 'package:swayamsevak/components/bottomnav/bottomnavigation.dart';
import 'package:swayamsevak/main.dart';
import 'package:swayamsevak/pages/enrollment_page.dart';
import 'package:swayamsevak/pages/leaderpages/addevent_page.dart';
import 'package:swayamsevak/pages/leaderpages/allstudents.dart';
import 'package:swayamsevak/pages/popages/addGroupName.dart';
import 'package:swayamsevak/pages/popages/adddepartment_page.dart';
import 'package:swayamsevak/pages/popages/addpo_page.dart';
import 'package:swayamsevak/pages/popages/addproject_page.dart';
import 'package:swayamsevak/pages/popages/addteacher_page.dart';
import 'package:swayamsevak/pages/popages/makeleader_page.dart';
import 'package:swayamsevak/pages/popages/notselectedstudents_page.dart';
import 'package:swayamsevak/pages/volunteerpages/applyleader.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const CheckLoginState(),
    ),

    //=============================== Leader =================================================

    GoRoute(
      path: '/leaderAddEvent',
      builder: (context, state) => const AddEventPage(),
    ),

    GoRoute(
      path: '/applyforleader',
      builder: (context, state) => const ApplyLeaderPage(),
    ),

    //=============================== Volunteer =================================================

    GoRoute(
      path: '/applyforleader',
      builder: (context, state) => const ApplyLeaderPage(),
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
    GoRoute(
      path: '/poAddDepartment',
      builder: (context, state) => const AddDepartmentPage(),
    ),
    GoRoute(
      path: '/poAddGroup',
      builder: (context, state) =>  AddGroupPage(),
    ),
    GoRoute(
      path: '/poAddTeacher',
      builder: (context, state) =>  AddTeacherPage(),
    ),
    GoRoute(
      path: '/poAddPO',
      builder: (context, state) =>  AddPoPage(),
    ),
    GoRoute(
      path: '/poConfirmStudents',
      builder: (context, state) =>  NotSelectedStudents(),
    ),
    GoRoute(
      path: '/poAppliedLeadersPage',
      builder: (context, state) =>  AppliedLeadersPage(),
    ),
  ],
);
