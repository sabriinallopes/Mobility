import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConfirmDestinationPage extends StatefulWidget {
  final String destination;
  final String departure;

  const ConfirmDestinationPage({
    super.key,
    required this.destination,
    required this.departure,
  });

  @override
  _ConfirmDestinationPageState createState() => _ConfirmDestinationPageState();
}

class _ConfirmDestinationPageState extends State<ConfirmDestinationPage> {
  LatLng userLocation = const LatLng(-23.5505, -46.6333); // São Paulo
  LatLng? destinationLocation;
  String estimatedTime = 'Carregando...';

  void _getDirections() async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${userLocation.latitude},${userLocation.longitude}&destination=${destinationLocation?.latitude},${destinationLocation?.longitude}&key=YOUR_API_KEY'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isNotEmpty) {
        final duration = data['routes'][0]['legs'][0]['duration']['text'];
        setState(() {
          estimatedTime = duration;
        });
      } else {
        setState(() {
          estimatedTime = 'Destino não encontrado';
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
    //converter o texto do destino em coordenadas, se necessário
    destinationLocation = const LatLng(-23.5617, -46.6550); // Exemplo de destino
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
          // Campo de texto para o destino
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
              if (destinationLocation != null) {
                _getDirections();
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
                target: userLocation,
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('user'),
                  position: userLocation,
                  infoWindow: const InfoWindow(title: 'Você está aqui'),
                ),
                if (destinationLocation != null)
                  Marker(
                    markerId: const MarkerId('destination'),
                    position: destinationLocation!,
                    infoWindow: InfoWindow(title: widget.destination),
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
