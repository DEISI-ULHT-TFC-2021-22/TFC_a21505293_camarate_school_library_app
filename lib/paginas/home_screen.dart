import 'package:camarate_school_library/livros_emprestados_user/show_attributes_screen.dart';
import 'package:camarate_school_library/prateleiras/prateleira_yellow/show_yellow_shelf_screen.dart';
import 'package:flutter/material.dart';
import 'package:camarate_school_library/ferramentas/search_screen.dart';

// ignore: use_key_in_widget_constructors
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double xDeslocamento = 0;
  double yDeslocamento = 0;
  double fatorDeEscala = 1;

  bool isMenuAberto = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      // animação para a página home quando clicar no ícone do menu lateral
      transform: Matrix4.translationValues(xDeslocamento, yDeslocamento, 0)
        ..scale(fatorDeEscala)
        ..rotateY(isMenuAberto ? -0.5 : 0),
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMenuAberto ? 40 : 0.0),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              // Espaçamento entre os icones
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // Ação para o icon do menu lateral
              children: [
                isMenuAberto
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          setState(() {
                            xDeslocamento = 0;
                            yDeslocamento = 0;
                            fatorDeEscala = 1;
                            isMenuAberto = false;
                          });
                        },
                      )
                    : IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          setState(() {
                            xDeslocamento = 230;
                            yDeslocamento = 150;
                            fatorDeEscala = 0.6;
                            isMenuAberto = true;
                          });
                        },
                      ),

                // Ação para o icon da pesquisa
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PesquisaScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
          //Espaçamento entre icone menu e título Livros requisitados
          const SizedBox(
            height: 10,
          ),

          // --> Lista dos livros <--
          SizedBox(
            height: 670,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: const [
                  // --> Lista dos livros <--
                  LivrosRequisitados(),
                  PrateleirasBiblioteca(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
