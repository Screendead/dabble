import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:dabble/objects/dabble.dart';
import 'package:dabble/utils/to_closest_time_unit.dart';
import 'package:flutter/material.dart';

class DabbleTile extends StatefulWidget {
  const DabbleTile({super.key, required this.dabble});

  final Dabble dabble;

  @override
  State<DabbleTile> createState() => _DabbleTileState();
}

class _DabbleTileState extends State<DabbleTile>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.dabble.duration * 1000,
      ),
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? _) {
        return ListTile(
          leading: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                color: widget.dabble.color,
                value: widget.dabble.progress,
              ),
              Text(
                widget.dabble.progressString,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: widget.dabble.color,
                    ),
              ),
            ],
          ),
          title: Text(widget.dabble.title),
          subtitle: Text(
            'Duration: ${toClosestTimeUnit((widget.dabble.duration / 60))}',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.add_a_photo),
                color: Colors.blue,
                onPressed: () {
                  // Upload an image of your dabble to Firebase Storage.
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Column(
                          children: [
                            const Text('Upload an image of your dabble.'),
                            ButtonBarSuper(
                              children: [
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.camera_alt),
                                  label: const Text('Take a photo'),
                                  onPressed: () {},
                                ),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.photo),
                                  label: const Text('Choose from gallery'),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                onPressed: widget.dabble.reference.delete,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }
}
