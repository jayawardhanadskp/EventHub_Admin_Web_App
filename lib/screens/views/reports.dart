import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportsPage extends StatelessWidget {
  static const String routeName = '/reports';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('reports').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          var reports = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              var report = reports[index];
              var userId = report['userId'];
              var reportText = report['report'];
              var timestamp = report['timestamp'] as Timestamp;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('customers').doc(userId).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text('User ID: $userId'),
                      subtitle: const Text('Loading...'),
                    );
                  }

                  if (userSnapshot.hasError || !userSnapshot.hasData) {
                    return ListTile(
                      title: Text('User ID: $userId'),
                      subtitle: const Text('User not found'),
                    );
                  }

                  var userData = userSnapshot.data!;
                  var userName = userData['name'];

                  return Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10, top: 5, bottom: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.blue.shade50,
                      ),
                      child: ListTile(
                        title: Text('Report: $reportText',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$userName'),
                            const SizedBox(height: 5,),
                            Text('${_formatDateTime(timestamp.toDate())}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.message, color: Colors.black45,),
                          onPressed: () {
                            _showMessageDialog(context, userId);
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }
}

// function to show message dialog
void _showMessageDialog(BuildContext context, String customerId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String message = '';

      return AlertDialog(
        title: Text('Send Message'),
        content: TextField(
          onChanged: (value) {
            message = value;
          },
          decoration: InputDecoration(hintText: 'Type your message'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Get current timestamp
              var timestamp = DateTime.now();

              // Save message to Firebase collection
              try {
                await FirebaseFirestore.instance.collection('admin_messages').add({
                  'userId': customerId,
                  'message': message,
                  'timestamp': timestamp,
                });
                print('Message sent successfully.');
              } catch (error) {
                print('Error sending message: $error');
              }

              Navigator.of(context).pop(); // Close dialog
            },
            child: Text('Send'),
          ),
        ],
      );
    },
  );
}