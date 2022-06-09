import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState()) {
    on<AppPageSelected>(_onPageSelected);
  }

  void _onPageSelected(
    AppPageSelected event,
    Emitter<AppState> emit,
  ) {
    if (state.currentPage == event.destinationPage) return;

    emit(AppState(currentPage: event.destinationPage));
  }
}
