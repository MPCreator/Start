import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/theme_provider.dart';
import '../utils/sizes.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Menu principal")),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: Colors.yellow,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(Icons.logout), // Icono para cerrar sesión
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            },
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSizes.customSizeHeight(context, 0.016)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botón de historial
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/historial');
              },
              child: Container(
                padding: EdgeInsets.all(AppSizes.customSizeHeight(context, 0.016)),
                margin: EdgeInsets.only(bottom: AppSizes.customSizeHeight(context, 0.02)),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.business,
                          size: AppSizes.customSizeHeight(context, 0.03),
                        ),
                        SizedBox(width: AppSizes.customSizeWidth(context, 0.02)),
                        Text(
                          'Historial',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                    ),
                  ],
                ),
              ),
            ),

            // Botón para empezar nuevo cuestionario
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/classification_questions');
              },
              child: Container(
                padding: EdgeInsets.all(AppSizes.customSizeHeight(context, 0.016)),
                margin: EdgeInsets.only(bottom: AppSizes.customSizeHeight(context, 0.02)),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          size: AppSizes.customSizeHeight(context, 0.03),
                        ),
                        SizedBox(width: AppSizes.customSizeWidth(context, 0.02)),
                        Text(
                          'Nuevo cuestionario',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
