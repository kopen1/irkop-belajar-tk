import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// On Web, keeps the app content in a phone-friendly viewport while still
/// using the full available height and width on small screens.
class WebMobileShell extends StatelessWidget {
  final Widget child;

  const WebMobileShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;

    return ColoredBox(
      color: const Color(0xFFE8F2F7),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final usePhoneFrame = width >= 700;
          final appWidth = usePhoneFrame ? 540.0 : width;

          return Center(
            child: SizedBox(
              width: appWidth,
              height: constraints.maxHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: usePhoneFrame
                      ? const BorderRadius.all(Radius.circular(28))
                      : BorderRadius.zero,
                  boxShadow: usePhoneFrame
                      ? const [
                          BoxShadow(
                            color: Color(0x180D405C),
                            blurRadius: 28,
                            offset: Offset(0, 8),
                          ),
                        ]
                      : const [],
                ),
                child: ClipRRect(
                  borderRadius: usePhoneFrame
                      ? const BorderRadius.all(Radius.circular(28))
                      : BorderRadius.zero,
                  child: child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
