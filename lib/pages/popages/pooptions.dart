import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class POOptionsPage extends StatelessWidget {
  const POOptionsPage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> options = const [
    {"title": "Approve Event", "route": "/poApproveEvent", "icon": Icons.event_available},
    {"title": "Confirm Volunteer", "route": "/poConfirmVolunteer", "icon": Icons.volunteer_activism},
    {"title": "Add Project", "route": "/poAddProject", "icon": Icons.add_box},
    {"title": "Add Teacher", "route": "/poAddTeacher", "icon": Icons.person_add},
    {"title": "Add PO", "route": "/poAddPO", "icon": Icons.account_circle},
    {"title": "Approve Leader", "route": "/poApproveLeader", "icon": Icons.supervisor_account},
    {"title": "All Events", "route": "/poAllEvents", "icon": Icons.event},
    {"title": "All Students", "route": "/poAllStudents", "icon": Icons.person},
    {"title": "All Groups", "route": "/poAllGroups", "icon": Icons.groups},
    {"title": "Stats", "route": "/poStats", "icon": Icons.bar_chart},
    {"title": "Add Department", "route": "/poAddDepartment", "icon": Icons.add},

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
                GoRouter.of(context).go(options[index]['route'] ?? '');
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
