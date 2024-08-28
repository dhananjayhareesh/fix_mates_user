import 'package:fix_mates_user/bloc/BookingConformation/bloc/booking_conformation_bloc.dart';
import 'package:fix_mates_user/bloc/DateSelection/bloc/date_selection_bloc.dart';
import 'package:fix_mates_user/utils/current_user_id_helper.dart';
import 'package:fix_mates_user/view/booking_screens/booking_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingConformationScreen extends StatelessWidget {
  final String workerId;
  final String workerName;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeSlotController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  BookingConformationScreen({
    super.key,
    required this.workerId,
    required this.workerName,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final DateTime lastSelectableDate = today.add(Duration(days: 5));

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              BookingConformationBloc()..add(FetchLocationEvent()),
        ),
        BlocProvider(
          create: (context) => DateSelectionBloc(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Booking Confirmation'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: BlocBuilder<BookingConformationBloc, BookingConformationState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Your Selected Location
                    const Text(
                      'Your Selected Location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 2,
                      child: Container(
                        width: double.infinity,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: state is BookingConformationLoading
                              ? const CircularProgressIndicator()
                              : state is BookingConformationLoaded
                                  ? Text(
                                      state.locationName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  : state is BookingConformationError
                                      ? Text(
                                          'Error: ${state.error}',
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        )
                                      : const Text('Unexpected state'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Select Day',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<DateSelectionBloc, DateSelectionState>(
                      builder: (context, dateState) {
                        final selectedDate = dateState is DateSelectionSelected
                            ? dateState.selectedDate
                            : null;

                        return TableCalendar(
                          calendarFormat: CalendarFormat.month,
                          focusedDay: today,
                          firstDay: today, // Start from today
                          lastDay: lastSelectableDate, // End after 5 days
                          selectedDayPredicate: (day) {
                            return selectedDate != null &&
                                day.isAtSameMomentAs(selectedDate);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            print('Selected Day: $selectedDay'); // Debug print
                            context
                                .read<DateSelectionBloc>()
                                .add(SelectDateEvent(selectedDay));
                            dateController.text =
                                selectedDay.toLocal().toString().split(' ')[0];
                          },
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                          ),
                          calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: Color.fromARGB(255, 148, 236, 194),
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Select Time Slot',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<DateSelectionBloc, DateSelectionState>(
                      builder: (context, dateState) {
                        final selectedTimeSlot =
                            dateState is DateSelectionSelected
                                ? dateState.selectedTimeSlot
                                : null;

                        return Wrap(
                          spacing: 8.0, // Space between buttons
                          runSpacing: 8.0, // Space between rows
                          children: [
                            _buildTimeSlotButton(
                                context, '9am - 10am', selectedTimeSlot),
                            _buildTimeSlotButton(
                                context, '10am - 11am', selectedTimeSlot),
                            _buildTimeSlotButton(
                                context, '11am - 12pm', selectedTimeSlot),
                            _buildTimeSlotButton(
                                context, '12pm - 1pm', selectedTimeSlot),
                            _buildTimeSlotButton(
                                context, '1pm - 2pm', selectedTimeSlot),
                            _buildTimeSlotButton(
                                context, '2pm - 3pm', selectedTimeSlot),
                            _buildTimeSlotButton(
                                context, '3pm - 4pm', selectedTimeSlot),
                            _buildTimeSlotButton(
                                context, '4pm - 5pm', selectedTimeSlot),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Add Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Enter description...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: BlocBuilder<DateSelectionBloc, DateSelectionState>(
                        builder: (context, dateState) {
                          final selectedDate =
                              dateState is DateSelectionSelected
                                  ? dateState.selectedDate
                                  : null;
                          final selectedTimeSlot =
                              dateState is DateSelectionSelected
                                  ? dateState.selectedTimeSlot
                                  : null;

                          dateController.text = selectedDate
                                  ?.toLocal()
                                  .toString()
                                  .split(' ')[0] ??
                              '';
                          timeSlotController.text = selectedTimeSlot ?? '';

                          return Text(
                            selectedDate != null && selectedTimeSlot != null
                                ? 'Selected Date: ${selectedDate.toLocal().toString().split(' ')[0]}, Time Slot: $selectedTimeSlot'
                                : 'Please select a date and time slot',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final userDocId =
                              await SharedPrefsHelper.getUserDocumentId();
                          final selectedDate = dateController.text;
                          final selectedTimeSlot = timeSlotController.text;
                          final description = descriptionController.text;

                          if (userDocId != null &&
                              selectedDate.isNotEmpty &&
                              selectedTimeSlot.isNotEmpty &&
                              description.isNotEmpty) {
                            final bookingRef = await FirebaseFirestore.instance
                                .collection('Bookings')
                                .add({
                              'workerId': workerId,
                              'userId': userDocId,
                              'date': selectedDate,
                              'timeSlot': selectedTimeSlot,
                              'description': description,
                              'status': 'pending',
                              'startTime': null,
                              'endTime': null,
                              'createdAt': FieldValue.serverTimestamp(),
                            });

                            print(
                                'Booking Confirmed: $userDocId, $workerId, $selectedDate, $selectedTimeSlot, $description');

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Booking Confirmed')),
                            );

                            // Navigate to Booking Confirmed Screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingConfirmedScreen(),
                              ),
                            );
                          } else {
                            print(
                                'Booking Confirmation Failed: Missing Information');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please complete all fields before confirming')),
                            );
                          }
                        } catch (e) {
                          print('Error confirming booking: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Error confirming booking')),
                          );
                        }
                      },
                      child: const Text('Confirm Booking'),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlotButton(
      BuildContext context, String timeSlot, String? selectedTimeSlot) {
    final isSelected = timeSlot == selectedTimeSlot;

    return GestureDetector(
      onTap: () {
        context.read<DateSelectionBloc>().add(SelectTimeSlotEvent(timeSlot));
        timeSlotController.text = timeSlot; // Update time slot in controller
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          timeSlot,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
