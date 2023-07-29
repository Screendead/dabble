import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabble/utils/to_closest_time_unit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewDabble extends StatefulWidget {
  const NewDabble({super.key});

  @override
  State<NewDabble> createState() => _NewDabbleState();
}

class _NewDabbleState extends State<NewDabble> {
  final List<int> durations = [1, 2, 5, 10, 15, 20, 30, 45, 60, 90, 120];
  int? selectedDuration;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormFieldState<String>> titleKey =
      GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    super.initState();

    User user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          selectedDuration =
              value.data()!['defaultDuration'] as int? ?? durations.first;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextFormField(
                  key: titleKey,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title.';
                    }

                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextButton.icon(
                    onPressed: () {
                      DateTime now = DateTime.now();
                      titleKey.currentState!.didChange(
                        'Dabble for ${now.month}/${now.day}/${now.year}',
                      );
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Use today\'s date'),
                  ),
                ),
              ],
            ),
            selectedDuration == null
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : ButtonBarSuper(
                    wrapFit: WrapFit.divided,
                    wrapType: WrapType.balanced,
                    children: durations
                        .map(
                          (int duration) => ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                selectedDuration = duration;
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: selectedDuration == duration
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.surface,
                              foregroundColor: selectedDuration == duration
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onSurface,
                              elevation: 0.0,
                            ),
                            child: Text(toClosestTimeUnit(duration)),
                          ),
                        )
                        .toList(),
                  ),
            ElevatedButton(
              onPressed: selectedDuration == null
                  ? null
                  : () async {
                      if (formKey.currentState!.validate()) {
                        User user = FirebaseAuth.instance.currentUser!;
                        NavigatorState navigator = Navigator.of(context);

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .set(
                          <String, dynamic>{
                            'defaultDuration': selectedDuration!,
                          },
                          SetOptions(
                            merge: true,
                          ),
                        );

                        DocumentReference dabble = await FirebaseFirestore
                            .instance
                            .collection('dabbles')
                            .add(
                          <String, dynamic>{
                            'title': titleKey.currentState!.value,
                            'duration': selectedDuration! * 60,
                            'createdAt': FieldValue.serverTimestamp(),
                            'owner': user.uid,
                          },
                        );

                        navigator.pop(dabble);
                      }
                    },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
