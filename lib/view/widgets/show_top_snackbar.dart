import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';

InputDecoration inputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: Colors.grey),
    contentPadding:
        const EdgeInsets.symmetric(vertical: 19.0, horizontal: 20.0),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: const BorderSide(
        color: maincolor,
        width: 1.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: const BorderSide(
        color: maincolor,
        width: 1.5,
      ),
    ),
  );
}

void showTopSnackBar(BuildContext context, String message, IconData icon,
    Color color, Duration duration) {
  OverlayState? overlayState = Overlay.of(context);
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50.0,
      left: 10.0,
      right: 10.0,
      child: Material(
        color: Colors.transparent,
        child: NotificationWithProgressBar(
          message: message,
          icon: icon,
          color: color,
          duration: duration,
        ),
      ),
    ),
  );

  overlayState.insert(overlayEntry);

  Future.delayed(duration, () {
    overlayEntry.remove();
  });
}

class NotificationWithProgressBar extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color color;
  final Duration duration;

  const NotificationWithProgressBar({
    super.key,
    required this.message,
    required this.icon,
    required this.color,
    this.duration = const Duration(seconds: 5),
  });

  @override
  State<NotificationWithProgressBar> createState() =>
      _NotificationWithProgressBarState();
}

class _NotificationWithProgressBarState
    extends State<NotificationWithProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isVisible
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
              border: Border(left: BorderSide(color: widget.color, width: 4)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(widget.icon, color: widget.color),
                    const SizedBox(width: 10),
                    Expanded(child: Text(widget.message)),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _isVisible = false;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _controller.value,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(widget.color),
                    );
                  },
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
