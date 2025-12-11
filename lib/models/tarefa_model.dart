class TarefaModel {
  final int id;
  final String carro;
  final String modelo;
  final int ano;
  final String placa;
  final String cor;
  final bool revisado;
  final DateTime dataCriacao;

  TarefaModel({
    required this.id,
    required this.carro,
    required this.modelo,
    required this.ano,
    required this.placa,
    required this.cor,
    required this.revisado,
    required this.dataCriacao,
  });
}
