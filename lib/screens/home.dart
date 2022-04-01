import 'package:camarate_school_library/Database/base_de_dados.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:camarate_school_library/Models/Auth/auth_model.dart';
import 'package:camarate_school_library/Models/Livro/livro_model.dart';
import 'package:camarate_school_library/Database/repositorio_de_livros.dart';
import 'package:camarate_school_library/Models/Livro/livro_requisitado_model.dart';
import 'package:camarate_school_library/Screens/pesquisar.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'livro_detalhado.dart';

//** VARIÁVEIS GLOBAIS */
final getLivrosBD = BaseDeDados();

//* Espaçamento
const espacamento = SizedBox(
  height: 14,
);

//* TÍtulo [Prateleiras]
const prateleiras = Padding(
  padding: EdgeInsets.all(16.0),
  child: Text(
    'Prateleiras',
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
  ),
);

//* TÍtulo [Livros Requisitados]
const livrosRequisitados = Padding(
  padding: EdgeInsets.all(16.0),
  child: Text(
    'Livros Requisitados',
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
  ),
);

//* PÁGINA HOME
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseDatabase _baseDeDados = FirebaseDatabase.instance;

  List<LivroModel> livros = <LivroModel>[];

  @override
  void initState() {
    super.initState();
    _baseDeDados.ref().child("livrosAleatorios");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livros'), // Título

        actions: <Widget>[
          //** Icone de pesquisa */
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  //** Redireciona o utilizador para a página de detalhes do livro */
                  builder: (context) => const PesquisaDeLivro(),
                ),
              );
            },
          ),
        ],
      ),

      /// Menu Lateral
      drawer: Drawer(
        child: ListView(
          // Importante: Remove qualquer preenchimento a mais do ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: null,
            ),
            ListTile(
              title: const Text(
                'Terminar sessão',
              ), // Titulo dentro do menu lateral

              /// Aceder ao metodo com o provider para terminar sessão
              onTap: () => context.read<AuthModel>().terminarSessao(),
            ),
          ],
        ),
      ),

      //* Este SingleChildScrollView será geral para toda a página home e fará apenas
      //* scroll na vertical
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            //* Título
            livrosRequisitados,

            //** Este SingleChildScrollView vai fazer scroll na horizontal
            //** vai apresentar os livros que foram requisitados */
            SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                height: 310.0,
                child: Column(
                  children: const [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),

                        //** Apresenta o livro requisitado no ecrã */
                        child: ListaDeLivroRequisitado(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //* Título
            prateleiras,
            //
            //** Este SingleChildScrollView vai fazer scroll na horizontal
            //** e irá apresentar os livros das prateleiras */

            SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                height: 375.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    //** comportamento para que a ListView só ocupe o espaço que precisa */
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) =>
                        //** Livros da prateleira na página home */
                        ListaDeLivros(index: index),

                    //** Obter o tamanho maximo da minha lista, os valores
                    //** da lista estão contidos na classe GerarLivro */ */
                    itemCount:
                        Provider.of<RepositorioDeLivros>(context, listen: false)
                            .todosLivros
                            .length,
                  ),
                ),
              ),
            ),

            StreamBuilder(
              stream: FirebaseDatabase.instance.ref("livrosAleatorios").onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  var databaseEvent = snapshot.data!;
                  var databaseSnapshot = databaseEvent.snapshot;
                  print('Snapshot: ${databaseSnapshot.value}');
                  return Text("${databaseSnapshot.value}");
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

//* LISTA SE UM LIVRO FOR REQUISITADO

class ListaDeLivroRequisitado extends StatelessWidget {
  const ListaDeLivroRequisitado({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //** Consumer */
    return Consumer<LivroRequisitadoModel>(
      //** (context, requisicao, child) --> variaveis */
      builder: (context, requisicao, child) => ListView.builder(
        scrollDirection: Axis.horizontal,

        //** tamanho máximo da lista para a requisicão */
        itemCount: requisicao.livros.length,

        itemBuilder: (context, index) => InkWell(
          //* Aqui o utilizador consegue carregar em cima do livro
          //* e ser direcionado para o ecrã de livro detalhado
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              //** Redireciona o utilizador para a página de detalhes do livro */
              builder: (context) => LivroDetalhado(
                livro: requisicao.livros[index],
              ),
            ),
          ),

          //* Widgets que vão reconstruir o formato dos livros a serem apresentados
          //* no página home
          child: Row(
            children: [
              Container(
                width: 111.0,
                margin: const EdgeInsets.only(right: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 121.66,
                      height: 165.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          //** Capa */
                          image:
                              NetworkImage(requisicao.livros[index].imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12.0),

                    //** Titulo */
                    Text(
                      requisicao.livros[index].titulo,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0,
                      ),
                    ),

                    const SizedBox(height: 5.0),

                    //** Data: */
                    Text(
                      'Data da requisição: ',
                      style: GoogleFonts.catamaran(
                        textStyle: const TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//* LISTA DE LIVROS PRATELEIRAS

class ListaDeLivros extends StatelessWidget {
  const ListaDeLivros({Key? key, required this.index}) : super(key: key);

  //** Variável para alcançar os livros por id na lista livros */
  final int index;

  @override
  Widget build(BuildContext context) {
    var livros = context.select<RepositorioDeLivros, LivroModel>(
      // Aqui, apenas interessa o livro a partir do [index].
      (livro) => livro.getPorId(index),
    );

    // Um pequeno tema para o texto(titulo, subTitulo, etc)
    var textTheme = Theme.of(context).textTheme.headline6;

    return GestureDetector(
      //* Aqui o utilizador consegue carregar em cima do livro
      //* e ser direcionado para o ecrã de livro detalhado
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            //** Redireciona o utilizador para a página de detalhes do livro */
            builder: (context) => LivroDetalhado(
              livro: livros,
            ),
          ),
        );
      },

      //** Widgets que vão desenvolver formato dos livros a serem apresentados
      //** no página home */
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
        child: LimitedBox(
          maxHeight: 48,
          child: Row(
            children: [
              Container(
                width: 122.0,
                margin: const EdgeInsets.only(right: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 121.66,
                      height: 190.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          //** Capa */
                          image: NetworkImage(livros.imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12.0),

                    //** Titulo */
                    Text(livros.titulo, style: textTheme),

                    const SizedBox(height: 5.0),

                    //** Autor */
                    Text(livros.autor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
