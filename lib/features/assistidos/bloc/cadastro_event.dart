part of 'cadastro_bloc.dart';

abstract class CadastroEvent extends Equatable {
  const CadastroEvent();
  @override
  List<Object?> get props => [];
}

class CadastroNomeChanged extends CadastroEvent {
  final String nome;
  const CadastroNomeChanged(this.nome);
  @override
  List<Object> get props => [nome];
}

class CadastroCpfChanged extends CadastroEvent {
  final String cpf;
  const CadastroCpfChanged(this.cpf);
  @override
  List<Object> get props => [cpf];
}

// Evento que faltava
class CadastroCpfUnfocused extends CadastroEvent {}

class CadastroRgChanged extends CadastroEvent {
  final String rg;
  const CadastroRgChanged(this.rg);
  @override
  List<Object> get props => [rg];
}

class CadastroDataNascimentoChanged extends CadastroEvent {
  final DateTime data;
  const CadastroDataNascimentoChanged(this.data);
  @override
  List<Object> get props => [data];
}

class CadastroEstadoCivilChanged extends CadastroEvent {
  final EstadoCivil estadoCivil;
  const CadastroEstadoCivilChanged(this.estadoCivil);
  @override
  List<Object> get props => [estadoCivil];
}

class CadastroGeneroChanged extends CadastroEvent {
  final Genero genero;
  const CadastroGeneroChanged(this.genero);
  @override
  List<Object> get props => [genero];
}

class CadastroFotoChanged extends CadastroEvent {
  final XFile? foto;
  const CadastroFotoChanged(this.foto);
  @override
  List<Object?> get props => [foto];
}

class CadastroSubmitted extends CadastroEvent {}

class CadastroCepChanged extends CadastroEvent {
  final String cep;
  const CadastroCepChanged(this.cep);
}

class CadastroRuaChanged extends CadastroEvent {
  final String rua;
  const CadastroRuaChanged(this.rua);
}

class CadastroSituacaoMoradiaChanged extends CadastroEvent {
  final SituacaoMoradia situacao;
  const CadastroSituacaoMoradiaChanged(this.situacao);
}
