// Usado para mapear o ENUM 'genero_enum' do banco de dados.
enum Genero {
  masculino,
  feminino;

  String get displayName {
    switch (this) {
      case Genero.masculino:
        return 'Masculino';
      case Genero.feminino:
        return 'Feminino';
    }
  }
}

// Usado para mapear o ENUM 'estado_civil_enum' do banco de dados.
enum EstadoCivil {
  solteiro,
  casado,
  separado,
  divorciado,
  viuvo,
  uniaoEstavel;

  String get displayName {
    switch (this) {
      case EstadoCivil.solteiro:
        return 'Solteiro(a)';
      case EstadoCivil.casado:
        return 'Casado(a)';
      case EstadoCivil.separado:
        return 'Separado(a)';
      case EstadoCivil.divorciado:
        return 'Divorciado(a)';
      case EstadoCivil.viuvo:
        return 'Viúvo(a)';
      case EstadoCivil.uniaoEstavel:
        return 'União Estável';
    }
  }
}

enum SituacaoMoradia {
  propria,
  alugada;

  String get displayName {
    switch (this) {
      case SituacaoMoradia.propria:
        return 'Própria';
      case SituacaoMoradia.alugada:
        return 'Alugada';
    }
  }
}
