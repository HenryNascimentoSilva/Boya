import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String profileImagePath = 'assets/images/profile.jpg'; // Caminho da imagem do perfil do usuário
  final String userName = 'Nome do Usuário'; // Nome do usuário
  final String userEmail = 'email@exemplo.com';

  const ProfileScreen({super.key}); // Email do usuário

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(profileImagePath),
                backgroundColor: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              userName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontFamily: 'Montserrat'
              ),
            ),
            const SizedBox(height: 8),
            Text(
              userEmail,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Montserrat'
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  // Ação ao clicar no botão "Editar Perfil"
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w700
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  )
                ),
                child: const Text('Editar Conta'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: ElevatedButton(onPressed: () {}
              ,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                textStyle: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w700
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),), child: const Text('Excluir Conta')
                      ),
            )],
        ),
      ),
    );
  }
}
