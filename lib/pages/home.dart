import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabble/widgets/my_dabbles.dart';
import 'package:dabble/widgets/new_dabble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dabbles'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: const MyDabbles(),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                FirebaseAuth.instance.currentUser!.email!,
              ),
            ),
            ListTile(
              title: const Text('My Dabbles'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => Scaffold(
                      appBar: AppBar(
                        title: const Text('My Dabbles'),
                      ),
                      body: const MyDabbles(),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('My Profile'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

          DocumentReference<Map<String, dynamic>>? dabble =
              await showModalBottomSheet<
                  DocumentReference<Map<String, dynamic>>>(
            context: context,
            builder: (_) => const NewDabble(),
          );

          if (dabble != null) {
            messenger.showSnackBar(
              SnackBar(
                content: Text(
                  'Dabble created: ${dabble.id}',
                ),
              ),
            );
          }
        },
        label: const Text('New Dabble'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
