import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/quiz_history.dart';
import '../../models/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void _register() async {
    try {
      // 1. Crear usuario en Firebase Authentication
      print("email: ${ _emailController.text}");
      print("password: ${ _passwordController.text}");
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // 2. Crear instancia inicial de `HistorialCuestionarios` con listas vacías
      List<HistorialCuestionarios> historialCuestionarios = [];

      // 3. Crear instancia de `UserModel` con los datos del usuario
      UserModel newUser = UserModel(
        id: userCredential.user!.uid,
        nombre: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        historialCuestionarios: historialCuestionarios,
      );

      // 4. Guardar en Firestore
      await _firestore
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .set(newUser.toMap());

      // Navegar a otra pantalla después del registro exitoso
      Navigator.pushNamed(context, '/main');
    } catch (e) {
      print('Error en el registro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
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
              onPressed: _register,
              child: const Text('Registrarse'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
