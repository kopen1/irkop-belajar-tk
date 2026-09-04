import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Responsive Web shell:
/// - phone/tablet: edge-to-edge app surface
/// - desktop: a wide native-app workspace instead of a phone-sized frame
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
          final desktop = width >= 900;
          final contentWidth = desktop
              ? (width - 48).clamp(0.0, 1280.0).toDouble()
              : width;

          return Center(
            child: SizedBox(
              width: contentWidth,
              height: constraints.maxHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: desktop
                      ? const BorderRadius.all(Radius.circular(32))
                      : BorderRadius.zero,
                  boxShadow: desktop
                      ? const [
                          BoxShadow(
                            color: Color(0x180D405C),
                            blurRadius: 30,
                            offset: Offset(0, 10),
                          ),
                        ]
                      : const [],
                ),
                child: ClipRRect(
                  borderRadius: desktop
                      ? const BorderRadius.all(Radius.circular(32))
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
