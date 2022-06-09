part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {}

class AppPageSelected extends AppEvent {
  AppPageSelected({required this.destinationPage});

  final AppPages destinationPage;

  @override
  List<Object> get props => [destinationPage];
}
