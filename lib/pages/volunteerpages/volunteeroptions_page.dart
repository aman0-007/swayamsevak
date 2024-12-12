import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudentOptionsPage extends StatelessWidget {
  const StudentOptionsPage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> options = const [
    {"title": "Add Event", "route": "/addEvent", "icon": Icons.event},
    // {"title": "Confirm Student", "route": "/confirmStudent", "icon": Icons.check_circle},
    // {"title": "Assign Group", "route": "/assignGroup", "icon": Icons.group_add},
    // {"title": "All Groups", "route": "/allGroups", "icon": Icons.group},
    // {"title": "Previous Events", "route": "/previousEvents", "icon": Icons.history},
    {"title": "Apply-Leader", "route": "/applyforleader", "icon": Icons.person},
    // {"title": "Marks Attendance", "route": "/marksAttendance", "icon": Icons.checklist},
    // {"title": "Update Student ID", "route": "/updateStudentID", "icon": Icons.edit},
    // {"title": "Complete Event", "route": "/completeEvent", "icon": Icons.done_all},
    // {"title": "Live Events", "route": "/liveEvents", "icon": Icons.live_tv},
    // {"title": "Completed Events", "route": "/completedEvents", "icon": Icons.check_circle_outline},
    // {"title": "My Attendance", "route": "/myAttendance", "icon": Icons.assignment},
    // {"title": "Mark My Attendance", "route": "/markMyAttendance", "icon": Icons.mark_chat_read},
    // {"title": "Update Password", "route": "/updatePassword", "icon": Icons.lock},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      //backgroundColor: theme.colorScheme.secondaryContainer,
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
                elevation: 6, // Increased elevation for better shadow effect
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer, // Light background color for each card
                    borderRadius: BorderRadius.circular(16), // Rounded corners on the card
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Soft shadow
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
