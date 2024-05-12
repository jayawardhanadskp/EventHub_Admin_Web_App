import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashbordScreen extends StatefulWidget {
  static const String routeName = '/DashbordScreen';

  const DashbordScreen({Key? key}) : super(key: key);

  @override
  State<DashbordScreen> createState() => _DashbordScreenState();
}

class _DashbordScreenState extends State<DashbordScreen> {
  int? totalServiceProviders;
  int? totalServiceSeekers;
  int? totalBookings;
  int? totalBanners;

  @override
  void initState() {
    super.initState();
    fetchDataSummary();
  }

  void fetchDataSummary() async {
    QuerySnapshot serviceProvidersSnapshot =
    await FirebaseFirestore.instance.collection('service_providers').get();
    QuerySnapshot serviceSeekersSnapshot =
    await FirebaseFirestore.instance.collection('customers').get();
    QuerySnapshot bookingsSnapshot =
    await FirebaseFirestore.instance.collection('bookings').get();
    QuerySnapshot bannersSnapshot =
    await FirebaseFirestore.instance.collection('banners').get();

    setState(() {
      totalServiceProviders = serviceProvidersSnapshot.size;
      totalServiceSeekers = serviceSeekersSnapshot.size;
      totalBookings = bookingsSnapshot.size;
      totalBanners = bannersSnapshot.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Dashboard'),
      ),
      body:  Column(
        children: [
          Image.asset('assets/banner.jpeg'),
           Container(
             padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     Padding(
                       padding: const EdgeInsets.all(15.0),
                       child: Container(
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(8),
                             boxShadow: [
                               BoxShadow(
                                   color: Colors.blue.shade900.withOpacity(0.4),
                                   spreadRadius: 7,
                                   blurRadius: 5,
                                   offset: const Offset(0, 3)
                               )
                             ]
                         ),
                         child: Container(
                           decoration: BoxDecoration(
                               color: Colors.blue.shade900,
                               border: Border.all(color: Colors.blue.shade900),
                               borderRadius: BorderRadius.circular(8)
                           ),
                           child: Column(
                             children: [
                               const Padding(
                                 padding: EdgeInsets.only(left: 15.0,right: 15.0, top: 15.0),
                                 child: Text('Service Seekers', style: TextStyle(color: Colors.white, fontSize: 25),),
                               ),
                               totalServiceSeekers != null
                                   ? Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Text(totalServiceSeekers!.toString(), style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w600),),
                               )
                                   : const CircularProgressIndicator(),
                             ],
                           ),
                         ),
                       ),
                     ),

                     Padding(
                       padding: const EdgeInsets.all(15.0),
                       child: Container(
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(8),
                             boxShadow: [
                               BoxShadow(
                                   color: Colors.blue.shade900.withOpacity(0.4),
                                   spreadRadius: 7,
                                   blurRadius: 5,
                                   offset: const Offset(0, 3)
                               )
                             ]
                         ),
                         child: Container(
                           decoration: BoxDecoration(
                               color: Colors.blue.shade900,
                               border: Border.all(color: Colors.blue.shade900),
                               borderRadius: BorderRadius.circular(8)
                           ),
                           child: Column(
                             children: [
                               const Padding(
                                 padding: EdgeInsets.only(left: 15.0,right: 15.0, top: 15.0),
                                 child: Text('Service Providers', style: TextStyle(color: Colors.white, fontSize: 25),),
                               ),
                               totalServiceSeekers != null
                                   ? Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Text(totalServiceProviders!.toString(), style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w600),),
                               )
                                   : const CircularProgressIndicator(),
                             ],
                           ),
                         ),
                       ),
                     ),

                     Padding(
                       padding: const EdgeInsets.all(15.0),
                       child: Container(
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(8),
                             boxShadow: [
                               BoxShadow(
                                   color: Colors.blue.shade900.withOpacity(0.4),
                                   spreadRadius: 7,
                                   blurRadius: 5,
                                   offset: const Offset(0, 3)
                               )
                             ]
                         ),
                         child: Container(
                           decoration: BoxDecoration(
                               color: Colors.blue.shade900,
                               border: Border.all(color: Colors.blue.shade900),
                               borderRadius: BorderRadius.circular(8)
                           ),
                           child: Column(
                             children: [
                               const Padding(
                                 padding: EdgeInsets.only(left: 15.0,right: 15.0, top: 15.0),
                                 child: Text('Bookings', style: TextStyle(color: Colors.white, fontSize: 25),),
                               ),
                               totalServiceSeekers != null
                                   ? Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Text(totalBookings!.toString(), style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w600),),
                               )
                                   : const CircularProgressIndicator(),
                             ],
                           ),
                         ),
                       ),
                     ),

                   ],
                 )
                ],
              ),
            ),

        ],
      ),
    );
  }}