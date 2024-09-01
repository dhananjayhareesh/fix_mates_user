import 'package:fix_mates_user/view/booking_screens/booking_conformation_screen.dart';
import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  final String workerId;
  final String workerName;

  const BookingScreen(
      {super.key, required this.workerId, required this.workerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Description'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              child: Image.asset(
                'assets/bookingBanner.jpg',
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text('First Hour Charges'),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BookingConformationScreen(
                            workerId: workerId,
                            workerName: workerName,
                          )),
                );
              },
              child: Text('Book now'))
        ],
      ),
    );
  }
}
