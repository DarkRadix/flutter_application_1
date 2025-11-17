import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TresCamposPage extends StatefulWidget {
  const TresCamposPage({super.key});

  @override
  State<TresCamposPage> createState() => _TresCamposPageState();
}

class _TresCamposPageState extends State<TresCamposPage> {
  final campo1Controller = TextEditingController();
  final campo2Controller = TextEditingController();
  final campo3Controller = TextEditingController();

  DateTime? dataSelecionada;

  Future<void> _abrirDatePicker() async {
    final agora = DateTime.now();

    final data = await showDatePicker(
      context: context,
      initialDate: dataSelecionada ?? agora,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (data != null) {
      setState(() {
        dataSelecionada = data;
        final dia = data.day.toString().padLeft(2, '0');
        final mes = data.month.toString().padLeft(2, '0');
        final ano = data.year.toString();
        campo3Controller.text = "$dia/$mes/$ano";
      });
    }
  }

  void enviar() {
    if (campo1Controller.text.isEmpty ||
        campo2Controller.text.isEmpty ||
        campo3Controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Navigator.pop(context, {
      'campo1': campo1Controller.text,
      'campo2': campo2Controller.text,
      'campo3': campo3Controller.text,
    });
  }

  @override
  void dispose() {
    campo1Controller.dispose();
    campo2Controller.dispose();
    campo3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inserir Dados')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: campo1Controller,
              decoration: const InputDecoration(labelText: 'Jogo'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: campo2Controller,
              decoration: const InputDecoration(labelText: 'Tipo do Jogo'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: campo3Controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _DataInputFormatter(),
              ],
              decoration: InputDecoration(
                labelText: 'Data de lançamento',
                hintText: 'dd/mm/aaaa',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _abrirDatePicker,
                ),
              ),
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: enviar,
              child: const Text('Salvar e Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Formata automaticamente a digitação em formato de data: dd/mm/aaaa
class _DataInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;

    // remove tudo que não for número
    text = text.replaceAll(RegExp(r'[^0-9]'), '');

    // insere os '/'
    if (text.length > 2 && text.length <= 4) {
      text = '${text.substring(0, 2)}/${text.substring(2)}';
    } else if (text.length > 4) {
      text =
          '${text.substring(0, 2)}/${text.substring(2, 4)}/${text.substring(4, text.length)}';
    }

    // limita o tamanho máximo a 10 caracteres (dd/mm/aaaa)
    if (text.length > 10) {
      text = text.substring(0, 10);
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
