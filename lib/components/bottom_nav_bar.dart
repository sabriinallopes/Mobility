//Importação do pacote básico e biblioteca para a abarra de navegação
import 'package:flutter/material.dart'; 
import 'package:google_nav_bar/google_nav_bar.dart'; 

class MyBottomNavBar extends StatelessWidget {
  final void Function(int)? onTabChange; //função para lidar com a mudança de abas.

  const MyBottomNavBar({super.key, required this.onTabChange}); // Construtor que requer a função onTabChange.

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20), // Adiciona espaçamento vertical ao container.
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [ // Adiciona sombra ao container + configurações de opacidade.
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), 
            spreadRadius: 3, 
            blurRadius: 5, 
            offset: const Offset(0, 3), 
          ),
        ],
      ),
      child: GNav( // Cria a barra de navegação.
        color: Colors.grey[400], 
        activeColor: Colors.blueAccent, 
        tabBackgroundColor: Colors.grey.shade100,
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Alinha os botões igualmente.
        tabBorderRadius: 16, // Arredonda os cantos das abas.
        onTabChange: (value) => onTabChange!(value), // Chama a função onTabChange ao mudar de aba.
        tabs: const [ // Define as abas da barra de navegação.
          GButton(
            icon: Icons.home, // Ícone da aba "Início".
            text: 'Início', 
          ),
          GButton(
            icon: Icons.person, // Ícone da aba "Conta".
            text: 'Conta', 
          ),
        ],
      ),
    );
  }
}
