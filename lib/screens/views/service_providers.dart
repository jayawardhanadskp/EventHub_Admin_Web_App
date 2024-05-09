import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ServiceprovidersScreen extends StatefulWidget {
  static const String routeName = '/ServiceprovidersScreen';

  const ServiceprovidersScreen({Key? key}) : super(key: key);

  @override
  State<ServiceprovidersScreen> createState() =>
      _ServiceprovidersScreenState();
}

class _ServiceprovidersScreenState extends State<ServiceprovidersScreen> {
  late List<DocumentSnapshot> _serviceProviders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Providers'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('service_providers')
            .snapshots(),
        builder: (context, serviceProviderSnapshot) {
          if (serviceProviderSnapshot.hasError) {
            return Center(
              child: Text('Error:  ${serviceProviderSnapshot.error}'),
            );
          }

          if (serviceProviderSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          _serviceProviders = serviceProviderSnapshot.data!.docs;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Total Service Providers: ${_serviceProviders.length}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Service Category')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Contact Details')),
                    DataColumn(label: Text('Average Rating')),
                    DataColumn(label: Text('Bookings')),
                    DataColumn(label: Text('Notification')),
                  ],
                  rows: _serviceProviders.map<DataRow>((serviceProvider) {
                    var name = serviceProvider['business_Name'];
                    var email = serviceProvider['email'];
                    var address = serviceProvider['address'];
                    var phone = serviceProvider['phone'];
                    var service = serviceProvider['service'];
                    var serviceproviderId = serviceProvider.id;

                    return DataRow(
                      cells: [
                        DataCell(Text(name)),
                        DataCell(Text(service)),
                        DataCell(Text(email)),
                        DataCell(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(address),
                            Text(phone)
                          ],
                        )),


                        DataCell(
                          FutureBuilder<double>(
                            future: _calculateAverageRating(serviceproviderId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return RatingBar.builder(
                                  initialRating: snapshot.data ?? 0,
                                  minRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    // Handle rating update
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        DataCell(
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('bookings')
                                .where('serviceproviderId',
                                isEqualTo: serviceproviderId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                var bookingsCount =
                                    snapshot.data?.docs.length ?? 0;
                                return Text('$bookingsCount');
                              }
                            },
                          ),
                        ),
                        DataCell(IconButton(
                          icon: const Icon(Icons.message, color: Colors.black45,),
                          onPressed: () {
                            _showMessageDialog(context, serviceproviderId);
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

  Future<double> _calculateAverageRating(String serviceProviderId) async {
    var reviewsSnapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('serviceProviderId', isEqualTo: serviceProviderId)
        .get();

    if (reviewsSnapshot.docs.isEmpty) {
      return 0.0;
    }

    var totalRating = 0.0;
    for (var review in reviewsSnapshot.docs) {
      totalRating += (review['rating'] as num).toDouble();
    }

    return totalRating / reviewsSnapshot.docs.length;
  }
}

// function to show message dialog
void _showMessageDialog(BuildContext context, String customerId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String message = '';

      return AlertDialog(
        title: Text('Send Notification'),
        content: TextField(
          onChanged: (value) {
            message = value;
          },
          decoration: InputDecoration(hintText: 'Type your Notification'),
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
