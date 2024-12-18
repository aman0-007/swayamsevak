import 'package:flutter/material.dart';
import 'package:swayamsevak/services/po/approveevent.dart';

class PoApproveEventPage extends StatefulWidget {
  @override
  _PoApproveEventPageState createState() => _PoApproveEventPageState();
}

class _PoApproveEventPageState extends State<PoApproveEventPage> {
  late Future<List<Map<String, dynamic>>> _eventsFuture;
  final NotDoneEvents _eventService = NotDoneEvents();

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  void _fetchEvents() {
    setState(() {
      _eventsFuture = _eventService.fetchNotDoneEvents();
    });
  }

  Future<void> _showApprovalDialog(BuildContext context, String eventId) async {
    final theme = Theme.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Approve Event",
            style: theme.textTheme.titleMedium,
          ),
          content: Text(
            "Are you sure you want to approve this event?",
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel", style: theme.textTheme.labelLarge),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Approve", style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary)),
            ),
          ],
        );
      },
    );

    if (result == true) {
      try {
        await _eventService.updateEventStatus(eventId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Event status updated successfully!")),
        );
        _fetchEvents(); // Refresh events after updating
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating event: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Not Done Events"),
        backgroundColor: theme.colorScheme.primary,
        titleTextStyle: theme.appBarTheme.titleTextStyle,
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: theme.textTheme.bodyLarge,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No events found',
                style: theme.textTheme.titleMedium,
              ),
            );
          }

          final events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: theme.cardTheme.shape,
                elevation: theme.cardTheme.elevation,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Icon(Icons.event, color: theme.colorScheme.primary),
                  title: Text(
                    event['name'] ?? 'No Name',
                    style: theme.textTheme.titleMedium,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        "Teacher Incharge: ${event['teacher_incharge'] ?? 'N/A'}",
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        "Venue: ${event['venue']?.isNotEmpty == true ? event['venue'] : 'No Venue'}",
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        "Project: ${event['projectName'] ?? 'N/A'}",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: theme.colorScheme.onSurface),
                  onTap: () {
                    final eventId = event['event_id']?.toString();
                    if (eventId != null) {
                      _showApprovalDialog(context, eventId);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Invalid event data")),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
