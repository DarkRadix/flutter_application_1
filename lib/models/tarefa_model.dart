class TarefaModel {
  final String id;
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

  factory TarefaModel.fromJson(Map<String, dynamic> json) {
    return TarefaModel(
      id: json["id"].toString(),
      carro: json["carro"],
      modelo: json["modelo"],
      ano: int.parse(json["ano"].toString()),
      placa: json["placa"],
      cor: json["cor"],
      revisado: json["revisado"] == true,
      dataCriacao: json["dataCriacao"] != null
          ? DateTime.parse(json["dataCriacao"])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "carro": carro,
      "modelo": modelo,
      "ano": ano,
      "placa": placa,
      "cor": cor,
      "revisado": revisado,
      "dataCriacao": dataCriacao.toIso8601String(),
    };
  }
}
