part of 'bottom_nav_bloc.dart';

@immutable
sealed class BottomNavEvent {}

class BottomNavItemSelected extends BottomNavEvent {
  final int index;
  BottomNavItemSelected(this.index);
}
