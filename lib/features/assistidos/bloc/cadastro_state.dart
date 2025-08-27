part of 'cadastro_bloc.dart';

// Enum para o status geral do formulário
enum FormStatus { initial, loading, success, failure }

// Enum para o status específico da validação do CPF
enum CpfStatus { initial, checking, valid, invalid, failure }

class CadastroState extends Equatable {
  const CadastroState({
    this.formStatus = FormStatus.initial,
    this.cpfStatus = CpfStatus.initial,
    this.nomeCompleto = '',
    this.cpf = '',
    this.rg = '',
    this.dataNascimento,
    this.estadoCivil,
    this.genero,
    this.naturalidade = '',
    this.contato = '',
    this.errorMessage = '',
    this.submissionAttempted = false,
    this.foto,
    this.situacaoMoradia,
    this.cep = '',
    this.rua = '',
    this.numero = '',
    this.bairro = '',
    this.cidade = '',
    this.uf = '',
  });

  final FormStatus formStatus;
  final CpfStatus cpfStatus;
  final String nomeCompleto;
  final String cpf;
  final String rg;
  final DateTime? dataNascimento;
  final EstadoCivil? estadoCivil;
  final Genero? genero;
  final String naturalidade;
  final String contato;
  final String errorMessage;
  final bool submissionAttempted;
  final XFile? foto;
  final SituacaoMoradia? situacaoMoradia;
  final String cep;
  final String rua;
  final String numero;
  final String bairro;
  final String cidade;
  final String uf;

  // Propriedade computada para facilitar a lógica na UI
  bool get isCpfValid =>
      cpfStatus == CpfStatus.valid || cpfStatus == CpfStatus.initial;
  bool get isDadosPessoaisValid {
    return nomeCompleto.isNotEmpty &&
        cpf.isNotEmpty &&
        dataNascimento != null &&
        estadoCivil != null &&
        genero != null &&
        isCpfValid;
  }

  CadastroState copyWith({
    bool? submissionAttempted,
    FormStatus? formStatus,
    CpfStatus? cpfStatus,
    String? nomeCompleto,
    String? cpf,
    String? rg,
    DateTime? dataNascimento,
    EstadoCivil? estadoCivil,
    Genero? genero,
    String? naturalidade,
    String? contato,
    String? errorMessage,
    XFile? foto,
    SituacaoMoradia? situacaoMoradia,
    String? cep,
    String? rua,
    String? numero,
    String? bairro,
    String? cidade,
    String? uf,
  }) {
    return CadastroState(
      submissionAttempted: submissionAttempted ?? this.submissionAttempted,
      formStatus: formStatus ?? this.formStatus,
      cpfStatus: cpfStatus ?? this.cpfStatus,
      nomeCompleto: nomeCompleto ?? this.nomeCompleto,
      cpf: cpf ?? this.cpf,
      rg: rg ?? this.rg,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      estadoCivil: estadoCivil ?? this.estadoCivil,
      genero: genero ?? this.genero,
      naturalidade: naturalidade ?? this.naturalidade,
      contato: contato ?? this.contato,
      errorMessage: errorMessage ?? this.errorMessage,
      foto: foto ?? this.foto,
      situacaoMoradia: situacaoMoradia ?? this.situacaoMoradia,
      cep: cep ?? this.cep,
      rua: rua ?? this.rua,
      numero: numero ?? this.numero,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      uf: uf ?? this.uf,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome_completo': nomeCompleto,
      'cpf': cpf,
      'rg': rg,
      'data_nascimento': dataNascimento?.toIso8601String(),
      'estado_civil': estadoCivil?.displayName,
      'genero': genero?.displayName,
      'naturalidade': naturalidade,
      'telefone': contato,
      'situacao_moradia': situacaoMoradia?.displayName,
      'cep': cep,
      'endereco_rua': rua,
      'endereco_numero': numero,
      'endereco_bairro': bairro,
      'endereco_cidade': cidade,
      'endereco_uf': uf,
    };
  }

  @override
  List<Object?> get props => [
        formStatus,
        cpfStatus,
        nomeCompleto,
        cpf,
        rg,
        dataNascimento,
        estadoCivil,
        genero,
        naturalidade,
        contato,
        errorMessage,
        foto,
        situacaoMoradia,
        cep,
        rua,
        numero,
        bairro,
        cidade,
        uf
      ];
}
