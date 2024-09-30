import 'package:flutter/material.dart';
import 'package:flutter_application/pages/confirmdestination_page.dart'; 

class DestinationPage extends StatefulWidget {
  const DestinationPage({super.key}); 

  @override
  State<DestinationPage> createState() => _DestinationPageState(); 
}

class _DestinationPageState extends State<DestinationPage> {
  final TextEditingController _departureController = TextEditingController(); // Controlador para o campo de partida.
  final TextEditingController _destinationController = TextEditingController(); // Controlador para o campo de destino.

  // Função para navegar para a página de confirmação.
  void _navigateToConfirm() {
    String departure = _departureController.text.trim(); // Obtém o texto do campo de partida.
    String destination = _destinationController.text.trim(); // Obtém o texto do campo de destino.

    // Verifica se ambos os campos estão preenchidos.
    if (departure.isNotEmpty && destination.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmDestinationPage(
              departure: departure, destination: destination), // Navega para a página de confirmação.
        ),
      );
      // Limpar tudo apos navegação.
      _departureController.clear(); 
      _destinationController.clear(); 
    } else {
      //campos não estiverem preenchidos, mostra um diálogo de alerta.
      _showDialog('Por favor, informe tanto o Local de Partida quanto o Destino!');
    }
  }

  // Função para mostrar um diálogo de alerta.
  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Atenção'), 
        content: Text(message), 
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), 
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2), 
      body: Padding(
        padding: const EdgeInsets.all(12), 
        child: Column(
          children: [
            // Campo para Local de Partida
            Container(
              padding: const EdgeInsets.all(12), 
              margin: const EdgeInsets.symmetric(horizontal: 25), 
              decoration: BoxDecoration(
                color: Colors.grey[200], 
                borderRadius: BorderRadius.circular(8), 
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                  Expanded(
                    child: TextField(
                      controller: _departureController, 
                      decoration: const InputDecoration(
                        hintText: 'Local de Partida', 
                        border: InputBorder.none, 
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.search, 
                    color: Colors.grey, 
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), 
            // Campo para Destino
            Container(
              padding: const EdgeInsets.all(12), 
              margin: const EdgeInsets.symmetric(horizontal: 25), 
              decoration: BoxDecoration(
                color: Colors.grey[200], 
                borderRadius: BorderRadius.circular(8), 
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                  Expanded(
                    child: TextField(
                      controller: _destinationController, 
                      decoration: const InputDecoration(
                        hintText: 'Destino', 
                        border: InputBorder.none, 
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.search, 
                    color: Colors.grey, 
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), 
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, 
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15), 
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))), 
              onPressed: _navigateToConfirm, 
              child: const Text(
                'Iniciar Viagem', 
                style: TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold,
                  fontSize: 15, 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
