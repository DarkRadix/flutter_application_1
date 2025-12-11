import 'package:flutter/material.dart';
import 'models/tarefa_model.dart';
import 'tres_campos_page.dart';
import 'api_service.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TarefaModel> _tarefas = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarTarefas();
  }

  Future<void> carregarTarefas() async {
    final dados = await ApiService.getTarefas();
    setState(() {
      _tarefas = dados;
      carregando = false;
    });
  }

  void _adicionarTarefa() async {
    final novaTarefa = await Navigator.push<TarefaModel>(
      context,
      MaterialPageRoute(builder: (context) => const TresCamposPage()),
    );

    if (novaTarefa != null) {
      final salvo = await ApiService.addTarefa(novaTarefa);
      setState(() => _tarefas.add(salvo));
    }
  }

  void _editarTarefa(int index) async {
    final tarefaAtual = _tarefas[index];

    final editada = await Navigator.push<TarefaModel>(
      context,
      MaterialPageRoute(
        builder: (context) => TresCamposPage(tarefaExistente: tarefaAtual),
      ),
    );

    if (editada != null) {
      final atualizado = await ApiService.updateTarefa(editada);

      setState(() {
        _tarefas[index] = atualizado;
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
              onPressed: () async {
                await ApiService.deleteTarefa(_tarefas[index].id);
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

      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : _tarefas.isEmpty
              ? const Center(
                  child: Text(
                    "Nenhum carro cadastrado",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: _tarefas.length,
                  itemBuilder: (context, index) {
                    final t = _tarefas[index];

                    return Card(
                      margin: const EdgeInsets.all(12),
                      child: ListTile(
                        title: Text(
                          "${t.carro} - ${t.modelo}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Ano: ${t.ano}\n"
                          "Placa: ${t.placa}\n"
                          "Cor: ${t.cor}\n"
                          "Revisado: ${t.revisado ? "Sim" : "Não"}",
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
