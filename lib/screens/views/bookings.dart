import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookingScreen extends StatefulWidget {
  static const String routeName = '/BookingScreen';

  const BookingScreen({Key? key}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bookings').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var bookings = snapshot.data!.docs;

          return SingleChildScrollView(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Service Provider')),
                DataColumn(label: Text('Customer')),
                DataColumn(label: Text('Booked Date')),
                DataColumn(label: Text('Event Date')),
                DataColumn(label: Text('Booking Price')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Rating')),
              ],
              rows: bookings.map<DataRow>((booking) {
                var serviceProviderId = booking['serviceproviderId'];
                var customerId = booking['customerId'];
                var bookedDate = (booking['timestamp'] as Timestamp).toDate();
                var eventDate = booking['selectedDay'];
                var bookingPrice = booking['selectedPrice'];
                var status = booking['status'];
                var bookingId = booking.id;
            
                var serviceProviderStream = FirebaseFirestore.instance
                    .collection('service_providers')
                    .doc(serviceProviderId)
                    .snapshots();
                var customerStream = FirebaseFirestore.instance
                    .collection('customers')
                    .doc(customerId)
                    .snapshots();
                var ratingStream = FirebaseFirestore.instance
                    .collection('reviews')
                    .where('serviceProviderId', isEqualTo: serviceProviderId)
                    .where('bookingId', isEqualTo: bookingId)
                    .snapshots();
            
                return DataRow(
                  cells: [
                    DataCell(
                      StreamBuilder<DocumentSnapshot>(
                        stream: serviceProviderStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Text('Loading...');
                          }
                          var serviceProvider = snapshot.data!;
                          return Text(serviceProvider['business_Name']);
                        },
                      ),
                    ),
                    DataCell(
                      StreamBuilder<DocumentSnapshot>(
                        stream: customerStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Text('Loading...');
                          }
                          var customer = snapshot.data!;
                          return Text(customer['name']);
                        },
                      ),
                    ),
                    DataCell(Text(bookedDate.toString())),
                    DataCell(Text(eventDate)),
                    DataCell(Text(bookingPrice)),
                    DataCell(
                      Text(status, style: TextStyle(
                        color: status == 'waiting' ? Colors.red : Colors.green,),
                      ),
                    ),
                    DataCell(
                      StreamBuilder<QuerySnapshot>(
                        stream: ratingStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return const Text('No Rating');
                          }
                          var totalRating = 0.0;
                          for (var doc in snapshot.data!.docs) {
                            totalRating += doc['rating'] as double;
                          }
                          var averageRating = totalRating / snapshot.data!.docs.length;
                          return RatingBar.builder(
                            initialRating: averageRating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20,
                            itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
