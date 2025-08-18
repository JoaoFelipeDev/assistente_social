import 'package:assistencia_social/features/assistidos/data/repositories/assistido_repository.dart';
import 'package:assistencia_social/features/assistidos/domain/models/assistido_enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cadastro_event.dart';
part 'cadastro_state.dart';

class CadastroBloc extends Bloc<CadastroEvent, CadastroState> {
  final AssistidoRepository _assistidoRepository;
  CadastroBloc(this._assistidoRepository) : super(const CadastroState()) {
    on<CadastroNomeChanged>((event, emit) {
      emit(state.copyWith(nomeCompleto: event.nome));
    });
    on<CadastroCpfChanged>((event, emit) {
      emit(state.copyWith(cpf: event.cpf));
    });
    on<CadastroRgChanged>((event, emit) {
      emit(state.copyWith(rg: event.rg));
    });
    on<CadastroDataNascimentoChanged>((event, emit) {
      emit(state.copyWith(dataNascimento: event.data));
    });
    on<CadastroEstadoCivilChanged>((event, emit) {
      emit(state.copyWith(estadoCivil: event.estadoCivil));
    });
    on<CadastroGeneroChanged>((event, emit) {
      emit(state.copyWith(genero: event.genero));
    });
    on<CadastroSubmitted>(_onSubmitted);
    // ...
  }
  Future<void> _onSubmitted(
    CadastroSubmitted event,
    Emitter<CadastroState> emit,
  ) async {
    // 1. Emite o estado de 'loading' para a UI poder mostrar um spinner.
    emit(state.copyWith(formStatus: FormStatus.loading));
    try {
      // 2. Chama o repository, passando o estado atual formatado em JSON.
      await _assistidoRepository.createAssistido(state.toJson());
      // 3. Emite o estado de 'success'.
      emit(state.copyWith(formStatus: FormStatus.success));
    } catch (e) {
      // 4. Em caso de erro, emite o estado de 'failure'.
      emit(state.copyWith(formStatus: FormStatus.failure));
    }
  }
}
