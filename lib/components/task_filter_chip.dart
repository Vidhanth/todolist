import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskFilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final Function onTap;

  const TaskFilterChip({
    Key? key,
    required this.onTap,
    required this.active,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(80, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200)),
        backgroundColor: active
            ? Theme.of(context).colorScheme.onBackground
            : Colors.transparent,
      ),
      onPressed: () {
        onTap.call();
      },
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: active
              ? Theme.of(context).colorScheme.background
              : Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
  }
}
