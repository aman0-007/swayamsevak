import 'package:flutter/material.dart';
import 'package:swayamsevak/services/po/approveevent.dart';

class PoApproveEventPage extends StatefulWidget {
  @override
  _PoApproveEventPageState createState() => _PoApproveEventPageState();
}

class _PoApproveEventPageState extends State<PoApproveEventPage> {
  late Future<List<Map<String, dynamic>>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = NotDoneEvents().fetchNotDoneEvents();
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
                        "Level: ${event['level'] ?? 'N/A'}",
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        "Venue: ${event['venue']?.isNotEmpty == true ? event['venue'] : 'No Venue'}",
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        "Leader: ${event['leader_id'] ?? 'N/A'}",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: theme.colorScheme.onSurface),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
