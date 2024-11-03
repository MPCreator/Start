

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:start/utils/sizes.dart';

import '../providers/theme_provider.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
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
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: AppSizes.customSizeHeight(context, 0.1),),
              Text(
                'ASISTENTE VIRTUAL \nSTART',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppSizes.customSizeHeight(context, 0.03),
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: AppSizes.customSizeHeight(context, 0.1),),

              Image.asset(
                'assets/logo.png',
                height: AppSizes.customSizeHeight(context, 0.2),
              ),

              SizedBox(height: AppSizes.customSizeHeight(context, 0.2)),

              SizedBox(
                width: AppSizes.customSizeWidth(context, 0.5),
                height: AppSizes.customSizeHeight(context, 0.07),

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text('Iniciar sesión',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppSizes.customSizeHeight(context, 0.02)
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppSizes.customSizeHeight(context, 0.01)),

              SizedBox(
                width: AppSizes.customSizeWidth(context, 0.5),
                height: AppSizes.customSizeHeight(context, 0.07),

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/classification_questions');
                  },
                  child: Text('Empezar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                        fontSize: AppSizes.customSizeHeight(context, 0.02)
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}