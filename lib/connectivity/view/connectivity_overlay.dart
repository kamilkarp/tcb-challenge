import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcb_challenge/connectivity/connectivity.dart';

class ConnectivityOverlay extends StatefulWidget {
  const ConnectivityOverlay({
    Key? key,
    required this.child,
    this.noConnectionWidget = const ConnectivityNoConnectionOverlay(),
  }) : super(key: key);

  final Widget child;
  final Widget noConnectionWidget;

  @override
  State<ConnectivityOverlay> createState() => _ConnectivityOverlayState();
}

class _ConnectivityOverlayState extends State<ConnectivityOverlay>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      context.read<ConnectivityBloc>().add(ConnectivityCheck());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (_, state) {
        switch (state) {

          /// In case of an error assume user is connected
          case ConnectivityState.unknown:
          case ConnectivityState.connected:
            return widget.child;
          case ConnectivityState.disconnected:
            return widget.noConnectionWidget;
        }
      },
    );
  }
}
