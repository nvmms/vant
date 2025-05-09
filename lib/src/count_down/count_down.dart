import 'package:flutter/material.dart';
import 'dart:async';

class VanCountDownController {
  _VanCountDownState? _state;

  void start() {
    assert(_state != null, 'Controller not attached to any VanCountDown');
    _state!._startTimer();
  }

  void pause() {
    assert(_state != null, 'Controller not attached to any VanCountDown');
    _state!._pauseTimer();
  }

  void reset() {
    assert(_state != null, 'Controller not attached to any VanCountDown');
    _state!._resetTimer();
  }

  Duration get currentDuration {
    assert(_state != null, 'Controller not attached to any VanCountDown');
    return _state!._remainingTime;
  }

  bool get isRunning {
    assert(_state != null, 'Controller not attached to any VanCountDown');
    return _state!._timer?.isActive ?? false;
  }
}

class VanCountDown extends StatefulWidget {
  const VanCountDown({
    super.key,
    required this.time,
    this.format = "HH:mm:ss",
    this.autoStart = true,
    this.millisecond = false,
    this.child,
    this.onFinish,
    this.onChange,
    this.controller,
  });

  final Duration time;
  final String format;
  final bool autoStart;
  final bool millisecond;
  final Widget Function(Duration duration)? child;
  final VoidCallback? onFinish;
  final ValueChanged<Duration>? onChange;
  final VanCountDownController? controller;

  @override
  State<StatefulWidget> createState() => _VanCountDownState();
}

class _VanCountDownState extends State<VanCountDown> {
  late Duration _remainingTime;
  late ValueNotifier<String> _formatted;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.time;
    _formatted = ValueNotifier(_formatDuration(_remainingTime));

    widget.controller?._state = this;

    if (widget.autoStart) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(VanCountDown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?._state = null;
      widget.controller?._state = this;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _formatted.dispose();
    widget.controller?._state = null;
    super.dispose();
  }

  void _startTimer() {
    if (_timer?.isActive ?? false) return;

    final duration = widget.millisecond
        ? const Duration(milliseconds: 16)
        : const Duration(seconds: 1);

    _timer = Timer.periodic(duration, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final milliseconds =
          _remainingTime.inMilliseconds - (widget.millisecond ? 16 : 1000);

      if (milliseconds <= 0) {
        _remainingTime = Duration.zero;
        _formatted.value = _formatDuration(_remainingTime);
        timer.cancel();
        widget.onFinish?.call();
      } else {
        _remainingTime = Duration(milliseconds: milliseconds);
        _formatted.value = _formatDuration(_remainingTime);
        widget.onChange?.call(_remainingTime);
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
  }

  void _resetTimer() {
    _timer?.cancel();
    _remainingTime = widget.time;
    _formatted.value = _formatDuration(_remainingTime);
    if (widget.autoStart) {
      _startTimer();
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) return "00:00:00";

    final format = widget.format;
    int remainingMillis = duration.inMilliseconds;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String threeDigits(int n) => n.toString().padLeft(3, '0');

    int days = 0, hours = 0, minutes = 0, seconds = 0, millis = 0;

    if (format.contains("DD")) {
      days = remainingMillis ~/ Duration.millisecondsPerDay;
      remainingMillis -= days * Duration.millisecondsPerDay;
    }

    if (format.contains("HH")) {
      hours = remainingMillis ~/ Duration.millisecondsPerHour;
      remainingMillis -= hours * Duration.millisecondsPerHour;
    }

    if (format.contains("mm")) {
      minutes = remainingMillis ~/ Duration.millisecondsPerMinute;
      remainingMillis -= minutes * Duration.millisecondsPerMinute;
    } else if (!format.contains("HH") &&
        !format.contains("DD") &&
        format.contains("mm")) {
      minutes = duration.inMinutes;
      remainingMillis = 0;
    }

    if (format.contains("ss")) {
      seconds = remainingMillis ~/ Duration.millisecondsPerSecond;
      remainingMillis -= seconds * Duration.millisecondsPerSecond;
    } else if (!format.contains("mm") &&
        !format.contains("HH") &&
        !format.contains("DD") &&
        format.contains("ss")) {
      seconds = duration.inSeconds;
      remainingMillis = 0;
    }

    millis = remainingMillis;

    return format
        .replaceAll('DD', days.toString())
        .replaceAll('HH', hours.toString())
        .replaceAll('mm', minutes.toString())
        .replaceAll('ss', seconds.toString())
        .replaceAll('SSS', millis.toString());
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _formatted,
      builder: (context, value, _) {
        if (widget.child != null) {
          return widget.child!(_remainingTime);
        }
        return Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium,
        );
      },
    );
  }
}
