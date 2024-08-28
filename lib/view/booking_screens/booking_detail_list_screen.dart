import 'package:fix_mates_user/bloc/BookingDetails/bloc/booking_details_bloc.dart';
import 'package:fix_mates_user/view/booking_screens/booking_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingDetailListScreen extends StatelessWidget {
  const BookingDetailListScreen({super.key});

  Future<String?> getUserDocId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userDocId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
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
                    itemCount: state.bookings.length,
                    itemBuilder: (context, index) {
                      final booking = state.bookings[index];
                      return Card(
                        child: ListTile(
                          title: Text('Date: ${booking['date']}'),
                          subtitle: Text('Time: ${booking['timeSlot']}'),
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
}
