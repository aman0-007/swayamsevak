import 'package:flutter/material.dart';
import 'package:swayamsevak/pages/popages/addGroupName.dart';
import 'package:swayamsevak/pages/popages/approveevent_page.dart';
import 'package:swayamsevak/pages/popages/adddepartment_page.dart';
import 'package:swayamsevak/pages/popages/addpo_page.dart';
import 'package:swayamsevak/pages/popages/addproject_page.dart';
import 'package:swayamsevak/pages/popages/addteacher_page.dart';
import 'package:swayamsevak/pages/popages/makeleader_page.dart';
import 'package:swayamsevak/pages/popages/notselectedstudents_page.dart';

class POOptionsPage extends StatelessWidget {
  POOptionsPage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> options =  [
    {"title": "Approve Event", "widget": PoApproveEventPage(), "icon": Icons.event_available},
    {"title": "Make Leader", "widget": AppliedLeadersPage(), "icon": Icons.add},
    {"title": "Confirm Students", "widget": NotSelectedStudents(), "icon": Icons.volunteer_activism},
    {"title": "Add Project", "widget": AddProjectPage(), "icon": Icons.add_box},
    {"title": "Add Teacher", "widget": AddTeacherPage(), "icon": Icons.person_add},
    {"title": "Add PO", "widget": AddPoPage(), "icon": Icons.account_circle},
    {"title": "Approve Leader", "widget": AddPoPage(), "icon": Icons.supervisor_account},
    {"title": "All Events", "widget": AddPoPage(), "icon": Icons.event},
    {"title": "All Students", "widget": AddPoPage(), "icon": Icons.person},
    {"title": "All Groups", "widget": AddPoPage(), "icon": Icons.groups},
    {"title": "Stats", "widget": AddPoPage(), "icon": Icons.bar_chart},
    {"title": "Add Department", "widget": AddDepartmentPage(), "icon": Icons.add},
    {"title": "Add Group", "widget": AddGroupPage(), "icon": Icons.add},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: options.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of items per row
            mainAxisSpacing: 20, // Space between rows
            crossAxisSpacing: 20, // Space between columns
            childAspectRatio: 1.2, // Aspect ratio for rectangular boxes with more height
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => options[index]['widget'] as Widget,
                  ),
                );
              },
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        options[index]['icon'] as IconData,
                        size: 40,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        options[index]['title'] ?? '',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
