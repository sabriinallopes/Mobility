import 'package:flutter/material.dart';
import 'home_page.dart';

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
  void _registerUser() {
    if (_formKey.currentState?.validate() ?? false) {
      // Valida o formulário.
      // Implementar a lógica de registro aqui.

      // Mensagem de sucesso.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrado com sucesso!')),
      );

      // Redirecionar para a HomePage.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const HomePage()), // Navegação para a página inicial.
      );
    }
  }
}
