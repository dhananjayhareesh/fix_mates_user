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
          backgroundColor: Colors.blueAccent,
          title: const Text(
            'Booking Confirmation',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<BookingConformationBloc, BookingConformationState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location Section
                    const Text(
                      'Your Selected Location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
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

                    // Day Selection Section
                    const Text(
                      'Select Day',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<DateSelectionBloc, DateSelectionState>(
                      builder: (context, dateState) {
                        final selectedDate = dateState is DateSelectionSelected
                            ? dateState.selectedDate
                            : null;

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1.0,
                            ),
                          ),
                          child: TableCalendar(
                            calendarFormat: CalendarFormat.week,
                            focusedDay: today,
                            firstDay: today,
                            lastDay: lastSelectableDate,
                            selectedDayPredicate: (day) {
                              return selectedDate != null &&
                                  day.isAtSameMomentAs(selectedDate);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              context
                                  .read<DateSelectionBloc>()
                                  .add(SelectDateEvent(selectedDay));
                              dateController.text = selectedDay
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0];
                            },
                            headerStyle: const HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                            ),
                            calendarStyle: CalendarStyle(
                              todayDecoration: BoxDecoration(
                                color: const Color(0xFF90CAF9),
                                shape: BoxShape.circle,
                              ),
                              selectedDecoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              outsideDaysVisible: false,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Time Slot Selection Section
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
                          spacing: 8.0,
                          runSpacing: 8.0,
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

                    // Description Section
                    const Text(
                      'Any instruction for technician?',
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
                        hintText: 'Any thoughts to share?',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Booking Summary Section
                    BlocBuilder<DateSelectionBloc, DateSelectionState>(
                      builder: (context, dateState) {
                        final selectedDate = dateState is DateSelectionSelected
                            ? dateState.selectedDate
                            : null;
                        final selectedTimeSlot =
                            dateState is DateSelectionSelected
                                ? dateState.selectedTimeSlot
                                : null;

                        dateController.text =
                            selectedDate?.toLocal().toString().split(' ')[0] ??
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
                    const SizedBox(height: 30),

                    // Confirm Booking Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            final userDocId =
                                await SharedPrefsHelper.getUserDocumentId();
                            final selectedDate = dateController.text;
                            final selectedTimeSlot = timeSlotController.text;
                            final description = descriptionController.text;
                            final locationName = context
                                    .read<BookingConformationBloc>()
                                    .state is BookingConformationLoaded
                                ? (context.read<BookingConformationBloc>().state
                                        as BookingConformationLoaded)
                                    .locationName
                                : '';

                            if (userDocId != null &&
                                selectedDate.isNotEmpty &&
                                selectedTimeSlot.isNotEmpty &&
                                description.isNotEmpty) {
                              final bookingRef = await FirebaseFirestore
                                  .instance
                                  .collection('Bookings')
                                  .add({
                                'workerId': workerId,
                                'userId': userDocId,
                                'date': selectedDate,
                                'timeSlot': selectedTimeSlot,
                                'description': description,
                                'status': 'pending',
                                'location': locationName,
                                'startTime': null,
                                'endTime': null,
                                'amount': null,
                                'paid': null,
                                'createdAt': FieldValue.serverTimestamp(),
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Booking Confirmed!')),
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BookingConfirmedScreen(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please fill all required fields')),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Confirm Booking',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
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
    BuildContext context,
    String timeSlot,
    String? selectedTimeSlot,
  ) {
    final isSelected = timeSlot == selectedTimeSlot;

    return ChoiceChip(
      label: Text(timeSlot),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          context.read<DateSelectionBloc>().add(SelectTimeSlotEvent(timeSlot));
          timeSlotController.text = timeSlot;
        }
      },
      selectedColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.grey.shade200,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
