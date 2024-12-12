import 'package:flutter/material.dart';
import 'package:swayamsevak/services/volunteer/getdata.dart';

class ApplyLeaderPage extends StatefulWidget {
  const ApplyLeaderPage({Key? key}) : super(key: key);

  @override
  _ApplyLeaderPageState createState() => _ApplyLeaderPageState();
}

class _ApplyLeaderPageState extends State<ApplyLeaderPage> {
  final VolunteerService _leaderService = VolunteerService();
  bool _isLoading = false;
  Map<String, String>? _userDetails;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  void _fetchUserDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final details = await _leaderService.getUserDetails();
      setState(() {
        _userDetails = details;
      });
    } catch (e) {
      _showSnackbar(e.toString(), Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleApplyForLeader() async {
    if (_userDetails == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _leaderService.applyForLeader(
        _userDetails!['clgDbId']!,
        _userDetails!['stud_id']!,
      );

      final snackBarMessage =
      success ? "Application submitted successfully!" : "Failed to apply!";
      _showSnackbar(snackBarMessage, success ? Colors.green : Colors.red);
    } catch (e) {
      _showSnackbar(e.toString(), Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Apply for Leader"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userDetails == null
          ? const Center(child: Text("Unable to fetch user details"))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name: ${_userDetails!['name']} ${_userDetails!['surname']}",
              style: theme.textTheme.bodyLarge,
            ),
            Text(
              "Email: ${_userDetails!['email']}",
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              "Gender: ${_userDetails!['gender']}",
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              "Current Year: ${_userDetails!['currentYear']}",
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              "NSS Batch: ${_userDetails!['nssBatch']}",
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              "Leader Status: ${_userDetails!['isLeader']}",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: theme.elevatedButtonTheme.style,
                onPressed: _handleApplyForLeader,
                child: const Text("Apply for Leader"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
