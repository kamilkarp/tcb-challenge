import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:equatable/equatable.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc({required ConnectivityRepository connectivityRepository})
      : _connectivityRepository = connectivityRepository,
        super(ConnectivityState.unknown) {
    on<_ConnectivityChanged>(_onConnectivityChanged);
    on<ConnectivityCheck>(_onConnectivityCheck);

    _connectivitySubscription =
        _connectivityRepository.onConnectivityChanged.listen(
      (status) => add(
        _ConnectivityChanged(
          connectivityState: status == ConnectivityStatus.connected
              ? ConnectivityState.connected
              : ConnectivityState.disconnected,
        ),
      ),
      onError: (Object error, StackTrace stackTrace) {
        add(
          _ConnectivityChanged(connectivityState: ConnectivityState.unknown),
        );
        addError(error, stackTrace);
      },
      cancelOnError: false,
    );
  }

  final ConnectivityRepository _connectivityRepository;
  late StreamSubscription<ConnectivityStatus> _connectivitySubscription;

  void _onConnectivityChanged(
    _ConnectivityChanged event,
    Emitter<ConnectivityState> emit,
  ) {
    emit(event.connectivityState);
  }

  Future<void> _onConnectivityCheck(
    ConnectivityCheck event,
    Emitter<ConnectivityState> emit,
  ) async {
    try {
      final status = await _connectivityRepository.checkConnectivityStatus();
      emit(
        status == ConnectivityStatus.connected
            ? ConnectivityState.connected
            : ConnectivityState.disconnected,
      );
    } catch (error, stackTrace) {
      emit(ConnectivityState.unknown);
      addError(error, stackTrace);
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}
