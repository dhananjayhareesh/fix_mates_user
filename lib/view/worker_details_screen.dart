import 'package:fix_mates_user/view/booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceProvidersScreen extends StatelessWidget {
  final String category;

  const ServiceProvidersScreen({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: Text('Available Technicians'),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
                    style: TextStyle(fontSize: 18, color: Colors.grey[600])));
          }

          final workers = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: workers.length,
            itemBuilder: (context, index) {
              final worker = workers[index];
              final name = worker['userName'] ?? 'No name';
              final photoUrl = worker['photoUrl'] ?? '';

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: CircleAvatar(
                    backgroundImage:
                        photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                    child:
                        photoUrl.isEmpty ? Icon(Icons.person, size: 30) : null,
                    radius: 30,
                  ),
                  title: Text(name,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  subtitle:
                      Text(category, style: TextStyle(color: Colors.grey[600])),
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
    );
  }
}
