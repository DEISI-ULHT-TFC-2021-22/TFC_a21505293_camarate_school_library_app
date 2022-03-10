import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Models/livro.dart';
import 'View_models/home_requisitar_provider.dart';
import 'screens/home.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        //** Exponho o primeiro valor da minha lista na página home (Livros da prateleira) */
        Provider(create: (_) => GerarLivro()),

        //** Dependência = GerarLivro --> HomeRequisitarProvider
        //** Ao carregar no botao requisitar, consumo o primeiro valor livro da
        //** lista na classe GerarLivro e guardo na funcao da classe HomeRequisitarProvider
        //** que é o addLivrosRequisitados*/
        ChangeNotifierProxyProvider<GerarLivro, HomeRequisitarProvider>(
          create: (context) => HomeRequisitarProvider(),
          update: (context, livro, informacaoDoLivro) {
            if (informacaoDoLivro == null)
              // ignore: curly_braces_in_flow_control_structures
              throw ArgumentError.notNull('Sem informacao do Livro');
            informacaoDoLivro.livro = livro;
            return informacaoDoLivro;
          },
        )
      ],

      //** APLICAÇÃO */
      child: const CamarateSchoolLibraryApp(),
    ),
  );
}

class CamarateSchoolLibraryApp extends StatelessWidget {
  const CamarateSchoolLibraryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // tira o debug do ecrã
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
