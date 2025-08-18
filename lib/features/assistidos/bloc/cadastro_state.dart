part of 'cadastro_bloc.dart';

enum FormStatus { initial, loading, success, failure }

class CadastroState extends Equatable {
  const CadastroState({
    this.formStatus = FormStatus.initial,
    this.nomeCompleto = '',
    this.cpf = '',
    this.rg = '',
    this.dataNascimento,
    this.estadoCivil,
    this.genero,
    this.naturalidade = '',
    this.contato = '',
    // Adicionaremos os outros campos das outras abas aqui depois...
  });

  final String nomeCompleto;
  final String cpf;
  final String rg;
  final DateTime? dataNascimento;
  final EstadoCivil? estadoCivil;
  final Genero? genero;
  final String naturalidade;
  final String contato;

  final FormStatus formStatus;

  CadastroState copyWith({
    String? nomeCompleto,
    String? cpf,
    String? rg,
    DateTime? dataNascimento,
    EstadoCivil? estadoCivil,
    Genero? genero,
    String? naturalidade,
    String? contato,
    FormStatus? formStatus,
  }) {
    return CadastroState(
      nomeCompleto: nomeCompleto ?? this.nomeCompleto,
      cpf: cpf ?? this.cpf,
      rg: rg ?? this.rg,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      estadoCivil: estadoCivil ?? this.estadoCivil,
      genero: genero ?? this.genero,
      naturalidade: naturalidade ?? this.naturalidade,
      contato: contato ?? this.contato,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome_completo': nomeCompleto,
      'cpf': cpf,
      'rg': rg,
      // As datas precisam ser enviadas no formato ISO 8601
      'data_nascimento': dataNascimento?.toIso8601String(),
      // Os enums precisam ser enviados como o texto que o banco espera
      'estado_civil': estadoCivil?.displayName,
      'genero': genero?.displayName,
      'naturalidade': naturalidade,
      'telefone': contato,
      // ... aqui mapearemos os campos das outras abas no futuro
    };
  }

  @override
  List<Object?> get props => [
        nomeCompleto,
        cpf,
        rg,
        dataNascimento,
        estadoCivil,
        genero,
        naturalidade,
        contato
      ];
}
