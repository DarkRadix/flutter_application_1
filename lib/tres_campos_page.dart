import 'package:flutter/material.dart';
import 'models/tarefa_model.dart';

class TresCamposPage extends StatefulWidget {
  final TarefaModel? tarefaExistente;

  const TresCamposPage({super.key, this.tarefaExistente});

  @override
  State<TresCamposPage> createState() => _TresCamposPageState();
}

class _TresCamposPageState extends State<TresCamposPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController carroController;
  late TextEditingController modeloController;
  late TextEditingController anoController;
  late TextEditingController placaController;
  late TextEditingController corController;

  bool revisado = false;

  @override
  void initState() {
    super.initState();

    carroController = TextEditingController(text: widget.tarefaExistente?.carro ?? "");
    modeloController = TextEditingController(text: widget.tarefaExistente?.modelo ?? "");
    anoController = TextEditingController(text: widget.tarefaExistente?.ano.toString() ?? "");
    placaController = TextEditingController(text: widget.tarefaExistente?.placa ?? "");
    corController = TextEditingController(text: widget.tarefaExistente?.cor ?? "");
    revisado = widget.tarefaExistente?.revisado ?? false;
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final tarefa = TarefaModel(
        id: widget.tarefaExistente?.id ?? "0",
        carro: carroController.text,
        modelo: modeloController.text,
        ano: int.parse(anoController.text),
        placa: placaController.text,
        cor: corController.text,
        revisado: revisado,
        dataCriacao: widget.tarefaExistente?.dataCriacao ?? DateTime.now(),
      );

      Navigator.pop(context, tarefa);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tarefaExistente == null ? "Novo Cadastro" : "Editar Cadastro"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: carroController,
                decoration: const InputDecoration(labelText: "Carro"),
                validator: (v) => v!.isEmpty ? "Informe o carro" : null,
              ),
              TextFormField(
                controller: modeloController,
                decoration: const InputDecoration(labelText: "Modelo"),
                validator: (v) => v!.isEmpty ? "Informe o modelo" : null,
              ),
              TextFormField(
                controller: anoController,
                decoration: const InputDecoration(labelText: "Ano (4 dígitos)"),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Informe o ano";
                  if (!RegExp(r'^\d{4}$').hasMatch(v)) return "Ano inválido";
                  return null;
                },
              ),
              TextFormField(
                controller: placaController,
                decoration: const InputDecoration(labelText: "Placa"),
                validator: (v) => v!.isEmpty ? "Informe a placa" : null,
              ),
              TextFormField(
                controller: corController,
                decoration: const InputDecoration(labelText: "Cor"),
                validator: (v) => v!.isEmpty ? "Informe a cor" : null,
              ),
              SwitchListTile(
                value: revisado,
                onChanged: (v) => setState(() => revisado = v),
                title: const Text("Revisado"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvar,
                child: const Text("Salvar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
