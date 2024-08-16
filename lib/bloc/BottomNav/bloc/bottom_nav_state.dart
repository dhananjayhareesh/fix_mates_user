part of 'bottom_nav_bloc.dart';

@immutable
sealed class BottomNavState {
  final int selectedIndex;

  const BottomNavState(this.selectedIndex);
}

final class BottomNavInitial extends BottomNavState {
  BottomNavInitial() : super(0);
}

class BottomNavLoaded extends BottomNavState {
  BottomNavLoaded(int index) : super(index);
}
