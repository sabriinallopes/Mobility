import 'package:flutter/material.dart'; 
import 'package:flutter_application/pages/about_page.dart'; 
import 'package:flutter_application/pages/destination_page.dart'; 
import 'package:flutter_application/pages/intro_pag.dart'; 
import 'package:flutter_application/pages/user_page.dart'; 
import 'package:flutter_application/pages/payment_page.dart'; 
import '../components/bottom_nav_bar.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key}); 

  @override
  State<HomePage> createState() => _HomePageState(); 
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Índice da página selecionada.

  // Função para atualizar o índice da página selecionada na barra de navegação.
  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index; // Atualiza o índice selecionado.
    });
  }

  // Lista de páginas que podem ser navegadas.
  final List<Widget> _pages = [
    const DestinationPage(), // Página de destino.
    const UserPage(), // Página do usuário.
  ];

  // Função para navegar para uma página específica.
  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index; // Atualiza o índice da página.
    });
    Navigator.pop(context); // Fecha o Drawer.
  }

  // Função de logout que redireciona para a página de introdução.
  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const IntroPag()), // Substitui a página atual pela página de introdução.
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2), 
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index), 
      ),
      appBar: AppBar(
        backgroundColor: Colors.white, 
        elevation: 1, 
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black), 
            onPressed: () {
              Scaffold.of(context).openDrawer(); 
            },
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[900], 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: [
            Column(
              children: [
                DrawerHeader(
                  child: Image.asset(
                    'lib/imagens/img.png', 
                    color: Colors.white,
                  ),
                ),
                const Divider(color: Colors.grey), 
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.white), 
                  title: const Text('Início', style: TextStyle(color: Colors.white)), 
                  onTap: () => _navigateToPage(0), 
                ),
                ListTile(
                  leading: const Icon(Icons.payment, color: Colors.white), 
                  title: const Text('Pagamentos', style: TextStyle(color: Colors.white)), 
                  onTap: () {
                    Navigator.pop(context); 
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PaymentPage()), 
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info, color: Colors.white), 
                  title: const Text('Sobre Nós', style: TextStyle(color: Colors.white)), 
                  onTap: () {
                    Navigator.pop(context); 
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutPage()), 
                    );
                  },
                ),
              ],
            ),
            // Opção de logout
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white), 
              title: const Text('Sair', style: TextStyle(color: Colors.white)), 
              onTap: _logout, 
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex], // Exibe a página correspondente ao índice selecionado.
    );
  }
}
