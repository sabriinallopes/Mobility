import 'package:flutter/material.dart';
import 'package:flutter_application/pages/home_page.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key}); 

  @override
  State<LoginPage> createState() => _LoginPageState(); 
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // Chave global para o formulário.
  final TextEditingController _emailController = TextEditingController(); // Controlador para o campo de e-mail.
  final TextEditingController _passwordController = TextEditingController(); // Controlador para o campo de senha.
  bool _isLoading = false; // Indica se o login está carregando.

//validar e-mail
  bool isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+'); 
    return regex.hasMatch(email); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'), 
        backgroundColor: const Color(0xFF4CAF50), 
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), 
        child: Form(
          key: _formKey, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              _buildTextField('E-mail', _emailController, validate: true),
              const SizedBox(height: 16), //verificar se é quantidade de caractere
              _buildTextField('Senha', _passwordController,
                  isPassword: true, validate: true),
              const SizedBox(height: 30), 
              ElevatedButton(
                onPressed: _isLoading ? null : _loginUser, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, 
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), 
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white), 
                      )
                    : const Text(
                        'Entrar', 
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
              ),
              const SizedBox(height: 20), 
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context,
                        '/register'); // Navega para a página de registro.
                  },
                  child: const Text('Não tem uma conta? Registre-se aqui.'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir campos de texto
  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false, bool validate = false}) {
    return TextFormField(
      controller: controller, // Controlador do campo.
      obscureText: isPassword, // Oculta texto se for uma senha.
      decoration: InputDecoration(
        labelText: label, 
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[200], 
      ),
      validator: validate
          ? (value) { // Validação do campo.
              if (value == null || value.isEmpty) {
                return 'Este campo é obrigatório'; // Mensagem se o campo estiver vazio.
              }
              if (label == 'E-mail' && !isValidEmail(value)) {
                return 'E-mail inválido'; // Mensagem se o e-mail for inválido.
              }
              return null; // Retorna null se válido.
            }
          : null,
    );
  }

  // Método para realizar o login
  void _loginUser() {
    if (_formKey.currentState?.validate() ?? false) { 
      setState(() {
        _isLoading = true; // Ativa o carregamento.
      });

      // lógica de autenticação (simulada com atraso)
      Future.delayed(const Duration(seconds: 2), () {
        // Se a autenticação for bem-sucedida
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()), // Navega para a HomePage.
        );

        setState(() {
          _isLoading = false; // Desativa o carregamento.
        });
      });
    }
  }
}
