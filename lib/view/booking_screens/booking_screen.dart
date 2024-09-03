import 'package:fix_mates_user/view/booking_screens/booking_conformation_screen.dart';
import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  final String workerId;
  final String workerName;

  const BookingScreen({
    Key? key,
    required this.workerId,
    required this.workerName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Repair Services',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/bookingBanner.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'First Hour Charge\n',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                            ),
                            TextSpan(
                              text: '₹ 390',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 1,
                        width: 20,
                        indent: 10,
                        endIndent: 10,
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Late Hourly Charge\n',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                            ),
                            TextSpan(
                              text: '₹ 100 /hour',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '• Book an on-site evaluation with a qualified electrician.\n'
                '• Analyses the faults and fixes the issues.',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Included',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          ListTile(
                            leading:
                                Icon(Icons.check_circle, color: Colors.green),
                            title: Text(
                                'Inspection & Labor charges for Repair Services'),
                          ),
                          ListTile(
                            leading:
                                Icon(Icons.check_circle, color: Colors.green),
                            title: Text('15 Days Service Warranty.'),
                          ),
                          ListTile(
                            leading:
                                Icon(Icons.check_circle, color: Colors.green),
                            title: Text(
                                'Professional and certified electricians.'),
                          ),
                          ListTile(
                            leading:
                                Icon(Icons.check_circle, color: Colors.green),
                            title: Text(
                                'Procurement of materials at additional Cost.'),
                          ),
                          ListTile(
                            leading:
                                Icon(Icons.check_circle, color: Colors.green),
                            title: Text(
                              'If work requires a helper, an additional charge is applicable. (80% of Main labor cost)',
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      const Text(
                        'Excluded',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          ListTile(
                            leading: Icon(Icons.cancel, color: Colors.red),
                            title: Text(
                                'Masonry Work & Electronic Appliances Services.'),
                          ),
                          ListTile(
                            leading: Icon(Icons.cancel, color: Colors.red),
                            title: Text('Please Provide ladder, if required.'),
                          ),
                          ListTile(
                            leading: Icon(Icons.cancel, color: Colors.red),
                            title: Text(
                                'Cementing and painting of damaged walls.'),
                          ),
                          ListTile(
                            leading: Icon(Icons.cancel, color: Colors.red),
                            title: Text(
                                'High-voltage equipment or systems repair'),
                          ),
                          ListTile(
                            leading: Icon(Icons.cancel, color: Colors.red),
                            title:
                                Text('Major construction, new building wiring'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'FAQ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '• What kind of repairs can an electrician do?',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Add navigation to How it works and Service Terms page
                },
                child: const Text(
                  'How it works\nService Terms',
                  style: TextStyle(
                    color: Color(0xFF512DA8), // Same purple color
                    fontSize: 16.0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Reviews',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
                          // Replace with actual user image if available
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text('Name of user'),
                        subtitle: Text('This is an example of rating'),
                        trailing: Icon(Icons.star, color: Colors.amber),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'View all >',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingConformationScreen(
                          workerId: workerId,
                          workerName: workerName,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF512DA8), // Purple color
                    padding: const EdgeInsets.symmetric(
                      horizontal: 100,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Book This Service',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
