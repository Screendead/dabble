import 'package:dabble/pages/authenticate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const Color accentColor = Color.fromRGBO(164, 55, 219, 1.0);

class Dabble extends StatelessWidget {
  const Dabble({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dabble',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: accentColor,
          ),
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            border: InputBorder.none,
            filled: true,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: accentColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
        ),
        home: MultiProvider(
          providers: [
            StreamProvider<User?>.value(
              value: FirebaseAuth.instance.userChanges(),
              updateShouldNotify: (_, __) => true,
              initialData: null,
              catchError: (BuildContext _, Object? __) {
                print('Error: Could not retrieve user.');
                return null;
              },
            ),
          ],
          child: Builder(
            builder: (BuildContext context) {
              final User? user = Provider.of<User?>(context);

              if (user == null) {
                return const Authenticate();
              }

              return Scaffold(
                body: SizedBox.expand(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Welcome ${user.email}!'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                        child: const Text('Sign Out'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
