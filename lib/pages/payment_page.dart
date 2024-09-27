import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Lista para armazenar os cartões
  List<Map<String, String>> savedCards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Cartões'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF2F2F2),
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),

            // Exibe o último cartão salvo, se existir
            if (savedCards.isNotEmpty)
              CreditCardWidget(
                cardNumber: savedCards.last['number']!,
                expiryDate: savedCards.last['expiry']!,
                cardHolderName: savedCards.last['holder']!,
                cvvCode: savedCards.last['cvv']!,
                showBackView: isCvvFocused,
                obscureCardNumber: false,
                obscureCardCvv: true,
                isHolderNameVisible: true,
                onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
              ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      _buildTextFormField(
                        label: 'Número do Cartão',
                        hint: 'XXXX XXXX XXXX XXXX',
                        onChanged: (value) {
                          setState(() {
                            cardNumber = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o número do cartão.';
                          }
                          if (value.length != 16) {
                            return 'O número do cartão deve ter 16 dígitos.';
                          }
                          return null;
                        },
                      ),
                      _buildTextFormField(
                        label: 'Data de Validade',
                        hint: 'MM/AA',
                        onChanged: (value) {
                          setState(() {
                            expiryDate = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a data de validade.';
                          }
                          return null;
                        },
                      ),
                      _buildTextFormField(
                        label: 'CVV',
                        hint: 'XXX',
                        onChanged: (value) {
                          setState(() {
                            cvvCode = value;
                            isCvvFocused = true;
                          });
                        },
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o CVV.';
                          }
                          if (value.length != 3) {
                            return 'O CVV deve ter 3 dígitos.';
                          }
                          return null;
                        },
                      ),
                      _buildTextFormField(
                        label: 'Nome do Titular',
                        onChanged: (value) {
                          setState(() {
                            cardHolderName = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o nome do titular.';
                          }
                          return null;
                        },
                        hint: '',
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(12),
                          child: const Text(
                            'Adicionar Cartão',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            // Adiciona o cartão à lista
                            setState(() {
                              savedCards.add({
                                'number': cardNumber,
                                'expiry': expiryDate,
                                'holder': cardHolderName,
                                'cvv': cvvCode,
                              });
                              // Limpa os campos após adicionar
                              cardNumber = '';
                              expiryDate = '';
                              cardHolderName = '';
                              cvvCode = '';
                              isCvvFocused = false;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      // Exibe os cartões salvos
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: savedCards.length,
                        itemBuilder: (context, index) {
                          final card = savedCards[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              title: Text(card['holder']!), // Corrigido
                              subtitle: Text(
                                  '**** **** **** ${card['number']!.substring(12)}'),
                              trailing: Text(card['expiry']!),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _buildTextFormField({
    required String label,
    required String hint,
    required Function(String) onChanged,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.black),
        hintStyle: const TextStyle(color: Colors.grey),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF4CAF50)),
        ),
      ),
      onChanged: onChanged,
      obscureText: obscureText,
      validator: validator,
    );
  }
}
