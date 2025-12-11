import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tarefa_model.dart';

class ApiService {
  static const String baseUrl =
      "https://6912663b52a60f10c8218a09.mockapi.io/API/V1/tarefa";

  // GET ALL
  static Future<List<TarefaModel>> getTarefas() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);
      return jsonList.map((e) => TarefaModel.fromJson(e)).toList();
    }

    throw Exception("Erro ao buscar tarefas");
  }

  // POST (criar)
  static Future<TarefaModel> addTarefa(TarefaModel tarefa) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(tarefa.toJson()),
    );

    if (response.statusCode == 201) {
      return TarefaModel.fromJson(jsonDecode(response.body));
    }

    throw Exception("Erro ao adicionar tarefa");
  }

  // PUT (editar)
  static Future<TarefaModel> updateTarefa(TarefaModel tarefa) async {
    final response = await http.put(
      Uri.parse("$baseUrl/${tarefa.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(tarefa.toJson()),
    );

    if (response.statusCode == 200) {
      return TarefaModel.fromJson(jsonDecode(response.body));
    }

    throw Exception("Erro ao editar tarefa");
  }

  // DELETE
  static Future<void> deleteTarefa(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    if (response.statusCode != 200) {
      throw Exception("Erro ao excluir tarefa");
    }
  }
}
