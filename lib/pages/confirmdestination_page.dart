import 'package:flutter/material.dart'; 
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Importa o pacote para o Google Maps.
import 'package:http/http.dart' as http; // Importa o pacote para requisições HTTP.
import 'dart:convert'; // Importa a biblioteca para manipulação de JSON.

class ConfirmDestinationPage extends StatefulWidget {
  final String destination; // Destino fornecido pelo usuário.
  final String departure; // Local de partida.

  const ConfirmDestinationPage({
    super.key,
    required this.destination, // Recebe o destino.
    required this.departure, // Recebe a partida.
  });

  @override
  _ConfirmDestinationPageState createState() => _ConfirmDestinationPageState(); // Cria o estado da página.
}

class _ConfirmDestinationPageState extends State<ConfirmDestinationPage> {
  LatLng userLocation = const LatLng(-23.5505, -46.6333); // Localização do usuário (São Paulo).
  LatLng? destinationLocation; // Localização do destino.
  String estimatedTime = 'Carregando...'; 

  // Função para obter direções do Google Maps.
  void _getDirections() async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${userLocation.latitude},${userLocation.longitude}&destination=${destinationLocation?.latitude},${destinationLocation?.longitude}&key=YOUR_API_KEY'));

    if (response.statusCode == 200) { // Verifica se a requisição foi bem-sucedida.
      final data = json.decode(response.body); // Decodifica a resposta JSON.
      if (data['routes'].isNotEmpty) { // Verifica se há rotas disponíveis.
        final duration = data['routes'][0]['legs'][0]['duration']['text']; // Obtém o tempo estimado da rota.
        setState(() {
          estimatedTime = duration; // Atualiza o tempo estimado.
        });
      } else {
        setState(() {
          estimatedTime = 'Destino não encontrado'; //erro se não houver rotas.
        });
      }
    } else {
      setState(() {
        estimatedTime = 'Erro ao buscar direções';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Define a localização de destino, aqui um exemplo fixo.
    destinationLocation = const LatLng(-23.5617, -46.6550); // Coordenadas de exemplo.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar Destino'), 
        backgroundColor: const Color(0xFF4CAF50), 
      ),
      body: Column(
        children: [
        
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Destino', 
                border: OutlineInputBorder(), 
              ),
              readOnly: true, 
              controller: TextEditingController(text: widget.destination), 
            ),
          ),
          // Botão para iniciar a viagem
          ElevatedButton(
            onPressed: () {
              if (destinationLocation != null) { // Verifica se o destino está definido.
                _getDirections(); // Obtém direções.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Viagem iniciada!')), 
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Por favor, insira um destino.')), 
                );
              }
            },
            child: const Text('Iniciar Viagem'), 
          ),
          // Mapa
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: userLocation, // Posição inicial do mapa.
                zoom: 14, // Nível de zoom inicial.
              ),
              markers: {
                Marker( // Marcador para a localização do usuário.
                  markerId: const MarkerId('user'),
                  position: userLocation,
                  infoWindow: const InfoWindow(title: 'Você está aqui'), // Mensagem ao clicar no marcador.
                ),
                if (destinationLocation != null) // Adiciona o marcador de destino se definido.
                  Marker(
                    markerId: const MarkerId('destination'),
                    position: destinationLocation!,
                    infoWindow: InfoWindow(title: widget.destination), // Mensagem ao clicar no marcador de destino.
                  ),
              },
            ),
          ),
          // Informações do motorista
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                const Text(
                  'Motorista: João da Silva', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), 
                ),
                const SizedBox(height: 5), 
                Text('Tempo estimado: $estimatedTime'), 
              ],
            ),
          ),
        ],
      ),
    );
  }
}
