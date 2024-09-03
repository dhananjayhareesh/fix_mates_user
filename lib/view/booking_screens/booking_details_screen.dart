import 'package:fix_mates_user/bloc/BookingDetails/bloc/booking_details_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String bookingId;

  const BookingDetailsScreen({required this.bookingId, super.key});

  String formatTimestampWithTimeZone(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime dateTime = timestamp.toDate();
      return DateFormat('MMMM d, yyyy \'at\' hh:mm:ss a zzz').format(dateTime);
    } else if (timestamp is String) {
      DateTime dateTime = DateTime.parse(timestamp);
      return DateFormat('MMMM d, yyyy \'at\' hh:mm:ss a zzz').format(dateTime);
    } else {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: BlocProvider(
        create: (context) =>
            BookingDetailsBloc()..add(FetchBookingDetail(bookingId)),
        child: BlocBuilder<BookingDetailsBloc, BookingDetailsState>(
          builder: (context, state) {
            if (state is BookingDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BookingDetailLoaded) {
              final booking = state.booking;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          _buildDetailContainer(
                            title: 'Date',
                            content:
                                formatTimestampWithTimeZone(booking['date']),
                            icon: Icons.date_range,
                          ),
                          _buildDetailContainer(
                            title: 'Time Slot',
                            content: booking['timeSlot'],
                            icon: Icons.access_time,
                          ),
                          _buildDetailContainer(
                            title: 'Description',
                            content: booking['description'],
                            icon: Icons.description,
                          ),
                          _buildDetailContainer(
                            title: 'Status',
                            content: booking['status'],
                            icon: Icons.info,
                          ),
                          _buildDetailContainer(
                            title: 'Start Time',
                            content: booking['startTime'] != null
                                ? formatTimestampWithTimeZone(
                                    booking['startTime'])
                                : 'Not started',
                            icon: Icons.timer,
                          ),
                          _buildDetailContainer(
                            title: 'Stop Time',
                            content: booking['endTime'] != null
                                ? formatTimestampWithTimeZone(
                                    booking['endTime'])
                                : 'Not stopped',
                            icon: Icons.timer_off,
                          ),
                          const SizedBox(height: 16.0),
                          _buildDetailContainer(
                            title: 'Worker Name',
                            content: booking['workerName'],
                            icon: Icons.person,
                          ),
                          _buildDetailContainer(
                            title: 'Work Type',
                            content: booking['workerCategory'],
                            icon: Icons.category,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _buildActionButtons(context, booking['status']),
                  ],
                ),
              );
            } else if (state is BookingDetailsError) {
              return Center(child: Text(state.message));
            }

            return const Center(child: Text('Booking details not found.'));
          },
        ),
      ),
    );
  }

  Widget _buildDetailContainer({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 30),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  content,
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // Handle chat functionality
          },
          icon: const Icon(Icons.chat_bubble_outline),
          label: const Text('Chat'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            // Handle payment or review functionality
            if (status == 'completed') {
              // Navigate to review screen
            } else {
              // Navigate to payment screen
            }
          },
          icon: status == 'completed'
              ? const Icon(Icons.rate_review)
              : const Icon(Icons.payment),
          label: Text(status == 'completed' ? 'Leave Review' : 'Payment'),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                status == 'completed' ? Colors.green : Colors.orangeAccent,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }
}
