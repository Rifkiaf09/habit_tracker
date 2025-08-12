import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; //ini untuk suara
import 'package:flutter/services.dart'; // inimah untuk getaran

class HabitTile extends StatefulWidget {
  final String habit;
  final bool completed;
  final ValueChanged<bool?> onChanged;
  final DismissDirectionCallback onDismissed;

  const HabitTile({
    super.key,
    required this.habit,
    required this.completed,
    required this.onChanged,
    required this.onDismissed,
  });

  @override
  State<HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playDing() async {
    await _audioPlayer.play(AssetSource('sounds/ding.mp3'));
  }

  Future<void> _vibrate() async {
    HapticFeedback.mediumImpact();
  }

  @override
  void didUpdateWidget(covariant HabitTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Jika status berubah dari belum selesai jadii selesai
    if (!oldWidget.completed && widget.completed) {
      _playDing();
      _vibrate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.habit),
      direction: DismissDirection.endToStart,
      onDismissed: widget.onDismissed,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        leading: Checkbox(
          value: widget.completed,
          onChanged: widget.onChanged,
          activeColor: Colors.green,
        ),
        title: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            fontSize: 16,
            decoration: widget.completed
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: widget.completed ? Colors.grey : Colors.black,
          ),
          child: Text(widget.habit),
        ),
        trailing: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: widget.completed
              ? const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  key: ValueKey('done'),
                )
              : const SizedBox(key: ValueKey('empty'), width: 0),
        ),
      ),
    );
  }
}
