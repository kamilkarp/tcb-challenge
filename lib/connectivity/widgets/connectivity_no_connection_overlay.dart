import 'package:flutter/material.dart';
import 'package:tcb_challenge/l10n/l10n.dart';

class ConnectivityNoConnectionOverlay extends StatelessWidget {
  const ConnectivityNoConnectionOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 100),
            Text(
              l10n.noInternetConnectionOverlayText,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
