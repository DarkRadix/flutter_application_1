import 'package:flutter/material.dart';
import 'models/tarefa_model.dart';
import 'tres_campos_page.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<TarefaModel> _tarefas = [];

  void _adicionarTarefa() async {
    final novaTarefa = await Navigator.push<TarefaModel>(
      context,
      MaterialPageRoute(builder: (context) => const TresCamposPage()),
    );

    if (novaTarefa != null) {
      setState(() {
        _tarefas.add(novaTarefa);
      });
    }
  }

  void _editarTarefa(int index) async {
    final tarefaAtual = _tarefas[index];

    final tarefaEditada = await Navigator.push<TarefaModel>(
      context,
      MaterialPageRoute(
        builder: (context) => TresCamposPage(
          tarefaExistente: tarefaAtual,
        ),
      ),
    );

    if (tarefaEditada != null) {
      setState(() {
        _tarefas[index] = tarefaEditada;
      });
    }
  }

  void _confirmarRemocao(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmar exclusão"),
          content: const Text("Tem certeza que deseja excluir este item?"),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text(
                "Excluir",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                setState(() => _tarefas.removeAt(index));
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarTarefa,
        child: const Icon(Icons.add),
      ),
      body: _tarefas.isEmpty
          ? const Center(
              child: Text(
                "Nenhum carro cadastrado",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: _tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = _tarefas[index];

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    title: Text(
                      "${tarefa.carro} - ${tarefa.modelo}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Ano: ${tarefa.ano}\n"
                      "Placa: ${tarefa.placa}\n"
                      "Cor: ${tarefa.cor}\n"
                      "Revisado: ${tarefa.revisado ? "Sim" : "Não"}",
                    ),
                    onTap: () => _editarTarefa(index),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmarRemocao(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
