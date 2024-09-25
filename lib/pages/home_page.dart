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
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const DestinationPage(),
    const UserPage(),
  ];

  void _navigateToPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Fecha o Drawer
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const IntroPag()),
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
                  title: const Text('Início',
                      style: TextStyle(color: Colors.white)),
                  onTap: () => _navigateToPage(0),
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: const Text('Perfil',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context); // Fecha o Drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.payment, color: Colors.white),
                  title: const Text('Pagamentos',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context); // Fecha o Drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PaymentPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info, color: Colors.white),
                  title: const Text('Sobre Nós',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context); // Fecha o Drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AboutPage()),
                    );
                  },
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text('Sair', style: TextStyle(color: Colors.white)),
              onTap: _logout, //chamar a função de logout
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
