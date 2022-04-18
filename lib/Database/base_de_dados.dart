import 'dart:convert';

import 'package:camarate_school_library/models/livro_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async' show Future;

class BaseDeDados {
  List<LivroModel> livros = [];

  Future<List<LivroModel>> carregarLivrosBD(
      DatabaseReference referenciaLivrosBD) async {
    RepositorioDeLivros listaDeLivros;

    DatabaseEvent dadosSnapshot = await referenciaLivrosBD.once();

    List<dynamic> respostaJSON =
        jsonDecode(jsonEncode(dadosSnapshot.snapshot.value));

    listaDeLivros = RepositorioDeLivros.fromJSON(respostaJSON);

    livros.addAll(listaDeLivros.livroModel);

    if (!livros.isNotEmpty) {
      // ignore: avoid_print
      print('Sem livros para mostrar');
    }

    return livros;
  }
}
