import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fix_mates_user/bloc/BookingDetails/bloc/booking_details_bloc.dart';
import 'package:fix_mates_user/view/booking_screens/booking_details_screen.dart';

class BookingDetailListScreen extends StatelessWidget {
  const BookingDetailListScreen({super.key});

  Future<String?> getUserDocId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userDocId');
  }

  String formatDate(String dateStr) {
    // Parse the date string into a DateTime object
    DateTime date = DateTime.parse(dateStr);

    // Format the DateTime object into dd/MM/yyyy format
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'My Bookings',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<String?>(
        future: getUserDocId(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userDocId = snapshot.data;
          if (userDocId == null) {
            return const Center(child: Text('No user found.'));
          }

          return BlocProvider(
            create: (context) =>
                BookingDetailsBloc()..add(FetchUserBookings(userDocId)),
            child: BlocBuilder<BookingDetailsBloc, BookingDetailsState>(
              builder: (context, state) {
                if (state is BookingDetailsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BookingDetailsLoaded) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: state.bookings.length,
                    itemBuilder: (context, index) {
                      final booking = state.bookings[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingDetailsScreen(
                                bookingId: booking['id'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10.0,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.category_outlined,
                                          color: Colors.blueAccent),
                                      const SizedBox(width: 8.0),
                                      Expanded(
                                        child: Text(
                                          booking['workerName'] ?? 'Unknown',
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        booking['workerCategory'] ?? 'Unknown',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12.0),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today,
                                          color: Colors.blueAccent),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Date: ${formatDate(booking['date'])}',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4.0),
                                  Row(
                                    children: [
                                      Icon(Icons.access_time,
                                          color: Colors.blueAccent),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Time: ${booking['timeSlot']}',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12.0),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BookingDetailsScreen(
                                              bookingId: booking['id'],
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20.0),
                                      ),
                                      child: const Text(
                                        'See Details',
                                        style: TextStyle(color: Colors.amber),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                left: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 8.0),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(booking['status']),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Text(
                                    booking['status'] ?? 'Unknown',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is BookingDetailsError) {
                  return Center(child: Text(state.message));
                }

                return const Center(child: Text('No bookings found.'));
              },
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
