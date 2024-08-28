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
                child: ListView(
                  children: [
                    _buildDetailCard(
                      title: 'Date',
                      content: formatTimestampWithTimeZone(booking['date']),
                      icon: Icons.date_range,
                    ),
                    _buildDetailCard(
                      title: 'Time Slot',
                      content: booking['timeSlot'],
                      icon: Icons.access_time,
                    ),
                    _buildDetailCard(
                      title: 'Description',
                      content: booking['description'],
                      icon: Icons.description,
                    ),
                    _buildDetailCard(
                      title: 'Status',
                      content: booking['status'],
                      icon: Icons.info,
                    ),
                    _buildDetailCard(
                      title: 'Start Time',
                      content: booking['startTime'] != null
                          ? formatTimestampWithTimeZone(booking['startTime'])
                          : 'Not started',
                      icon: Icons.timer,
                    ),
                    _buildDetailCard(
                      title: 'Stop Time',
                      content: booking['endTime'] != null
                          ? formatTimestampWithTimeZone(booking['endTime'])
                          : 'Not stopped',
                      icon: Icons.timer_off,
                    ),
                    const SizedBox(height: 16.0),
                    _buildDetailCard(
                      title: 'Worker Name',
                      content: booking['workerName'],
                      icon: Icons.person,
                    ),
                    _buildDetailCard(
                      title: 'Work Type',
                      content: booking['workerCategory'],
                      icon: Icons.category,
                    ),
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

  Widget _buildDetailCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4.0,
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(content),
      ),
    );
  }
}
