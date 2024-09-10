import 'package:fix_mates_user/bloc/BookingDetails/bloc/booking_details_bloc.dart';
import 'package:fix_mates_user/services/stripe_services.dart';
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
      return DateFormat('MMMM d, yyyy \'at\' hh:mm a').format(dateTime);
    } else if (timestamp is String) {
      DateTime dateTime = DateTime.parse(timestamp);
      return DateFormat('MMMM d, yyyy \'at\' hh:mm a').format(dateTime);
    } else {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 4.0,
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Booking Details',
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                          _buildGroupContainer(
                            title: 'Booking Information',
                            details: [
                              _buildDetailItem(
                                title: 'Date',
                                content: formatTimestampWithTimeZone(
                                    booking['date']),
                                icon: Icons.date_range,
                              ),
                              _buildDetailItem(
                                title: 'Time Slot',
                                content: booking['timeSlot'],
                                icon: Icons.access_time,
                              ),
                              _buildDetailItem(
                                title: 'Status',
                                content: booking['status'],
                                icon: Icons.info,
                                statusColor: booking['status'] == 'completed'
                                    ? Colors.green
                                    : Colors.blueAccent,
                              ),
                            ],
                          ),
                          _buildGroupContainer(
                            title: 'Payment Information',
                            details: [
                              _buildDetailItem(
                                title: 'Amount',
                                content: booking['amount'] != null
                                    ? '₹${booking['amount']}'
                                    : 'Pending',
                                icon: Icons.money_rounded,
                              ),
                              _buildDetailItem(
                                title: 'Payment Status',
                                content: booking['paid'] == 'completed'
                                    ? 'Paid'
                                    : 'Not Paid',
                                icon: booking['paid'] == 'completed'
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                statusColor: booking['paid'] == 'completed'
                                    ? Colors.green
                                    : Colors.redAccent,
                              ),
                            ],
                          ),
                          _buildGroupContainer(
                            title: 'Work Timing',
                            details: [
                              _buildDetailItem(
                                title: 'Start Time',
                                content: booking['startTime'] != null
                                    ? formatTimestampWithTimeZone(
                                        booking['startTime'])
                                    : 'Not started',
                                icon: Icons.timer,
                              ),
                              _buildDetailItem(
                                title: 'Stop Time',
                                content: booking['endTime'] != null
                                    ? formatTimestampWithTimeZone(
                                        booking['endTime'])
                                    : 'Not stopped',
                                icon: Icons.timer_off,
                              ),
                            ],
                          ),
                          _buildGroupContainer(
                            title: 'Worker Information',
                            details: [
                              _buildDetailItem(
                                title: 'Worker Name',
                                content: booking['workerName'],
                                icon: Icons.person,
                              ),
                              _buildDetailItem(
                                title: 'Work Type',
                                content: booking['workerCategory'],
                                icon: Icons.category,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _buildActionButtons(
                        context, booking['amount'], booking['paid']),
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

  Widget _buildGroupContainer({
    required String title,
    required List<Widget> details,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 16.0),
          ...details,
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required String title,
    required String content,
    required IconData icon,
    Color? statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: statusColor ?? Colors.blueAccent, size: 28),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, dynamic amount, String? paid) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 3,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
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
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              elevation: 6,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              // Handle payment or review functionality
              if (paid == 'completed') {
              } else if (amount != null) {
                await StripeService.instance
                    .makePayment(int.parse(amount.toString()));
              }
            },
            icon: paid == 'completed'
                ? const Icon(Icons.rate_review)
                : const Icon(Icons.payment),
            label:
                Text(paid == 'completed' ? 'Leave Review' : 'Proceed to Pay'),
            style: ElevatedButton.styleFrom(
              backgroundColor: paid == 'completed'
                  ? Colors.green
                  : (amount != null ? Colors.orangeAccent : Colors.grey),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              elevation: 6,
            ),
          ),
        ],
      ),
    );
  }
}
