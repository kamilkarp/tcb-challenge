part of 'app_bloc.dart';

enum AppPages { photos, comments }

class AppState extends Equatable {
  const AppState({this.currentPage = AppPages.photos});

  final AppPages currentPage;

  @override
  List<Object> get props => [currentPage];
}
