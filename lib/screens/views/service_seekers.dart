import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceSeekersScreen extends StatefulWidget {
  static const String routeName = '/ServiceSeekersScreen';

  const ServiceSeekersScreen({Key? key}) : super(key: key);

  @override
  _ServiceSeekersScreenState createState() => _ServiceSeekersScreenState();
}

class _ServiceSeekersScreenState extends State<ServiceSeekersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Seekers'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('customers').snapshots(),
        builder: (context, customerSnapshot) {
          if (customerSnapshot.hasError) {
            return Center(
              child: Text('Error: ${customerSnapshot.error}'),
            );
          }

          if (customerSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Customer details
          var customers = customerSnapshot.data!.docs;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Total Service Seekers: ${customers.length}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Photo')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Created')),
                    DataColumn(label: Text('Bookings')),
                    DataColumn(label: Text('Message')),
                  ],
                  rows: customers.map<DataRow>((customer) {
                    var name = customer['name'];
                    var email = customer['email'];
                    var photo = customer['photo'];
                    var timestamp = customer['signupTimestamp'];

                    var customerId = customer.id;
                    var bookingsStream = FirebaseFirestore.instance
                        .collection('bookings')
                        .where('customerId', isEqualTo: customerId)
                        .snapshots();

                    return DataRow(
                      cells: [
                        DataCell(CircleAvatar(
                          backgroundImage: NetworkImage(photo),
                        )),
                        DataCell(Text(name)),
                        DataCell(Text(email)),
                        DataCell(Text(timestamp.toDate().toString())),
                        DataCell(
                          StreamBuilder<QuerySnapshot>(
                            stream: bookingsStream,
                            builder: (context, bookingSnapshot) {
                              if (bookingSnapshot.hasData &&
                                  bookingSnapshot.data!.docs.isNotEmpty) {
                                return Text('${bookingSnapshot.data!.docs.length} Bookings');
                              } else {
                                return const Text('No Bookings');
                              }
                            },
                          ),
                        ),
                        DataCell(IconButton(
                          icon: Icon(Icons.message, color: Colors.black45,),
                          onPressed: () {
                            _showMessageDialog(context, customerId);
                          },
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
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


}
