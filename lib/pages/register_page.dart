import 'package:flutter/material.dart';
import 'login_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

//controladores
class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>(); // Chave para o formulário.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  String?
      _selectedDisability; // Armazena a condição de acessibilidade selecionada.
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

  bool isValidCPF(String cpf) {
    // Validação básica do CPF:
    return cpf.length == 11 &&
        int.tryParse(cpf) !=
            null; // Verifica se o CPF tem 11 dígitos e é numérico.
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
          key: _formKey, // Associa a chave ao formulário.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Nome', _nameController),
              const SizedBox(height: 16),
              _buildTextField('E-mail', _emailController, validate: true),
              const SizedBox(height: 16),
              _buildTextField('CPF', _cpfController, validate: true),
              const SizedBox(height: 16),
              _buildTextField('Data de Nascimento', _dataNascimentoController,
                  validate: true),
              const SizedBox(height: 16),
              _buildTextField('Telefone', _telefoneController, validate: true),
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
                onPressed: _registerUser, // Chama o método de registro.
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

  // Método para construir campos de texto.
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
              // Validação do campo.
              if (value == null || value.isEmpty) {
                return 'Este campo é obrigatório'; // Mensagem se vazio.
              }
              if (label == 'E-mail' && !isValidEmail(value)) {
                return 'E-mail inválido'; // Mensagem se o e-mail for inválido.
              }
              if (label == 'CPF' && !isValidCPF(value)) {
                return 'CPF inválido'; // Mensagem se o CPF for inválido.
              }
              if (label == 'Confirmar Senha' &&
                  value != _passwordController.text) {
                return 'As senhas não correspondem'; // Mensagem se as senhas não coincidirem.
              }
              return null; // Retorna null se válido.
            }
          : null, // Se não for necessário validar, retorna null.
    );
  }

  // Método para construir o campo de dropdown.
  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedDisability, // Valor selecionado.
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
          _selectedDisability =
              value; // Atualiza a condição de acessibilidade selecionada.
        });
      },
    );
  }

  // Método chamado ao pressionar o botão de registro.
  Future<void> _registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Implement secure registration logic
      final url = Uri.parse('http://127.0.0.1/Mobility/banco/cadastro.php');
      // Replace with your secure HTTPS URL

      final body = {
        'nome': _nameController.text,
        'cpf': _cpfController.text,
        'datanasc': _dataNascimentoController.text,
        'telefone': _telefoneController.text,
        'email': _emailController.text,
        'senha': _confirmPasswordController.text,
        'necessidade': _needsController.text,
      };

      try {
        final response = await http.post(url, body: jsonEncode(body));
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          if (responseData['success'] == true) {
            // Registration successful
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registrado com sucesso!')),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          } else {
            // Handle server-side validation error
            error(context, responseData['error']);
          }
        } else {
          // Handle network or server error
          error(context, 'Falha no registro. Tente novamente mais tarde.');
        }
      } catch (erro) {
        // Handle general error (e.g., network issue)
        error(context, 'Erro durante o registro: $erro');
      }
    }
  }

  void error(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
        ),
      ),
    );
  }
}
