import 'dart:convert';

import 'package:camarate_school_library/guia_de_estilo/color_styles.dart';
import 'package:camarate_school_library/prateleiras/prateleira_amarela/ecra_de_detalhes/book_details.dart';
import 'package:camarate_school_library/prateleiras/prateleira_amarela/variables_show_book.dart';
import 'package:camarate_school_library/prateleiras/prateleira_amarela/book_content_yellow.dart';
import 'package:camarate_school_library/requisitados/borrowed_books.dart';
import 'package:camarate_school_library/requisitados/borrowed_shelf.dart';
import 'package:flutter/material.dart';
import 'package:camarate_school_library/ferramentas/search_screen.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

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
  void initState() {
    super.initState();
    carregarDadosPrateleira();
  }

  // sempre que abrir o ecrã de pesquisa carrega a minha lista inicial de livros
  //do ficheiro .json...
  carregarDadosPrateleira() async {
    final prateleirasJSON =
        await rootBundle.loadString("assets/files/livros_prateleiras.json");
    var dadosDecodificados = jsonDecode(prateleirasJSON);
    var informacoesDoLivro = dadosDecodificados["prateleira"];

    DadosListaAmarela.livrosNasPrateleiras = List.from(informacoesDoLivro)
        .map<PrateleirasDaBiblioteca>((livrosNasPrateleiras) =>
            PrateleirasDaBiblioteca.fromMap(livrosNasPrateleiras))
        .toList();
    setState(() {});
  }

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

          // Este container contém os icones do menu lateral e de pesquisa
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

          SizedBox(
            height: 715,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 13.0, right: 189.0),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.0),
                      child: Text(
                        'Livros Requisitados',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: darkColor,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),
                  // Lista de lisvros requisitados
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    // falta chamar a lista ....
                  ),

                  Container(
                    padding: const EdgeInsets.only(right: 189.0),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.0),
                      child: Text(
                        'Prateleiras',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: darkColor,
                            fontFamily: 'Poppins'),
                      ),
                    ),
                  ),

                  // --> MOSTRAR AS LISTAS DOS LIVROS NO ECRÃ <--
                  tituloDaClasse(),
                  const SizedBox(
                    height: 15,
                  ),
                  //mostrarLivrosPrateleiraAmarela(),
                  //mostrarLivrosEmprestados(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
