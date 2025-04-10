import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Demo',
      home: LoginPage(),
    );
  }
}

Map<String, String> mockDatabase = {}; // email -> password

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (mockDatabase.containsKey(email) && mockDatabase[email] == password) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
    } else {
      setState(() {
        _errorMessage = 'Invalid email or password';
      });
    }
  }

  void _goToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text('Login')),
            TextButton(onPressed: _goToSignUp, child: Text("Don't have an account? Sign up")),
            Text(_errorMessage, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';
  String _successMessage = '';

  void _signUp() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isNotEmpty && password.length >= 6) {
      if (mockDatabase.containsKey(email)) {
        setState(() {
          _errorMessage = 'Email already exists';
          _successMessage = '';
        });
      } else {
        mockDatabase[email] = password;
        setState(() {
          _successMessage = 'Account created. Go back to login.';
          _errorMessage = '';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Enter valid email and password (min 6 chars)';
        _successMessage = '';
      });
    }
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _signUp, child: Text('Sign Up')),
            TextButton(onPressed: _goBack, child: Text('Back to Login')),
            Text(_errorMessage, style: TextStyle(color: Colors.red)),
            Text(_successMessage, style: TextStyle(color: Colors.green)),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('Welcome to the Home Page!')),
    );
  }
}
