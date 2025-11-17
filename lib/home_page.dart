import 'package:flutter/material.dart';
import 'tres_campos_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final List<Map<String, String>> _itens = []; // lista com os dados vindos da outra tela

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> _abrirTresCampos() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TresCamposPage(),
      ),
    );

    if (resultado != null && resultado is Map<String, String>) {
      setState(() {
        _itens.add(resultado);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Itens salvos:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: _itens.isEmpty
                  ? const Center(child: Text('Nenhum item salvo ainda'))
                  : ListView.builder(
                      itemCount: _itens.length,
                      itemBuilder: (context, index) {
                        final item = _itens[index];
                        return Card(
                          child: ListTile(
                            title: Text(item['campo1'] ?? ''),
                            subtitle: Text(
                                '${item['campo2'] ?? ''} — ${item['campo3'] ?? ''}'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirTresCampos, // abre a tela dos 3 campos
        tooltip: 'Adicionar novo item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
