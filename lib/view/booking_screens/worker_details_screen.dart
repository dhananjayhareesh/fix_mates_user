import 'package:fix_mates_user/resources/widgets/homescreen_widget/carosal_widget.dart';
import 'package:fix_mates_user/view/booking_screens/booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceProvidersScreen extends StatelessWidget {
  final String category;

  const ServiceProvidersScreen({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample banner images
    final List<String> bannerImages = [
      'assets/carosal_electricaion.jpg',
      'assets/elecmech.webp',
      'assets/acmech.jpg',
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Available Technicians',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: CarouselBanner(
              bannerImages: bannerImages,
              bannerTitle: '',
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('workers')
                  .where('category', isEqualTo: category)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text('No service providers found.',
                          style: TextStyle(
                              fontSize: 18, color: Colors.grey[600])));
                }

                final workers = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: workers.length,
                  itemBuilder: (context, index) {
                    final worker = workers[index];
                    final name = worker['userName']?.toString().toUpperCase() ??
                        'NO NAME';
                    final photoUrl = worker['photoUrl'] ?? '';

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            width: 80, // Larger width for the image
                            height: 80, // Larger height for the image
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              image: photoUrl.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(photoUrl),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: photoUrl.isEmpty
                                ? Icon(Icons.person,
                                    size: 40, color: Colors.grey[600])
                                : null,
                          ),
                        ),
                        title: Center(
                          child: Text(
                            name,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text(
                              'Work Type: $category',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[600]),
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '₹390 per hour',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        color: Colors.yellow[700], size: 18),
                                    SizedBox(width: 4),
                                    Text(
                                      '4', // Static rating value for now
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          final workerId = worker.id;
                          final workerName = worker['userName'] ?? 'No name';

                          print('Worker ID: $workerId');
                          print('Worker name: $workerName');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BookingScreen(
                                      workerId: workerId,
                                      workerName: workerName,
                                    )),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
