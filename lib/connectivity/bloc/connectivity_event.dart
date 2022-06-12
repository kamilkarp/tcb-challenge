part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent {}

class _ConnectivityChanged extends ConnectivityEvent {
  _ConnectivityChanged({required this.connectivityState});

  final ConnectivityState connectivityState;
}

class ConnectivityCheck extends ConnectivityEvent with EquatableMixin {
  @override
  List<Object> get props => [];
}
