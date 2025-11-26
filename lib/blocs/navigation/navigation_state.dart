part of 'navigation_cubit.dart';

class NavigationState extends Equatable {
  const NavigationState({this.currentIndex = 0});
  final int currentIndex;

  @override
  List<Object?> get props => [currentIndex];
}