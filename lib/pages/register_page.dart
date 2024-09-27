import 'package:flutter/material.dart';
import 'home_page.dart'; // Certifique-se de importar sua página HomePage

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _selectedDisability;
  final List<String> _disabilities = [
    'Visual',
    'Auditiva',
    'Motora',
    'Intelectual',
    'Outra'
  ];
  final TextEditingController _needsController = TextEditingController();

  bool isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Nome', _nameController),
              const SizedBox(height: 16),
              _buildTextField('E-mail', _emailController, validate: true),
              const SizedBox(height: 16),
              _buildTextField('Senha', _passwordController,
                  isPassword: true, validate: true),
              const SizedBox(height: 16),
              _buildTextField('Confirmar Senha', _confirmPasswordController,
                  isPassword: true, validate: true),
              const SizedBox(height: 16),
              _buildDropdownField(),
              const SizedBox(height: 16),
              _buildTextField('Necessidades Específicas', _needsController,
                  maxLines: 3),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Registrar',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false, int maxLines = 1, bool validate = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: validate
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Este campo é obrigatório';
              }
              if (label == 'E-mail' && !isValidEmail(value)) {
                return 'E-mail inválido';
              }
              if (label == 'Confirmar Senha' &&
                  value != _passwordController.text) {
                return 'As senhas não correspondem';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedDisability,
      decoration: InputDecoration(
        labelText: 'Condições de Acessibilidade',
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: _disabilities.map((String disability) {
        return DropdownMenuItem<String>(
          value: disability,
          child: Text(disability),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedDisability = value;
        });
      },
    );
  }

  void _registerUser() {
    if (_formKey.currentState?.validate() ?? false) {
      // Implementar a lógica de registro

      // Mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrado com sucesso!')),
      );

      // Redirecionar para a HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }
}
