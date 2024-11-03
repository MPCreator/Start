import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:start/models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Cargar datos adicionales desde Firestore
      UserModel? user = await _loadUserData(userCredential.user!.uid);

      if (user != null) {
        print('Bienvenido, ${user.nombre}');
        Navigator.pushNamed(context, '/main');
      } else {
        print('Usuario no encontrado en Firestore');
      }
    } catch (e) {
      print('Error en el login: $e');
    }
  }

  Future<UserModel?> _loadUserData(String uid) async {
    try {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .get();

      if (userData.exists) {
        return UserModel.fromDocumentSnapshot(userData);
      } else {
        print('Usuario no encontrado');
        return null;
      }
    } catch (e) {
      print('Error al cargar datos del usuario: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Iniciar Sesión'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
