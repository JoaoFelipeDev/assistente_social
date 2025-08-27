import 'package:assistencia_social/features/assistidos/data/repositories/assistido_repository.dart';
import 'package:assistencia_social/features/assistidos/domain/models/assistido_enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'cadastro_event.dart';
part 'cadastro_state.dart';

class CadastroBloc extends Bloc<CadastroEvent, CadastroState> {
  final AssistidoRepository _assistidoRepository;

  CadastroBloc({required AssistidoRepository assistidoRepository})
      : _assistidoRepository = assistidoRepository,
        super(const CadastroState()) {
    on<CadastroNomeChanged>(
        (event, emit) => emit(state.copyWith(nomeCompleto: event.nome)));
    on<CadastroRgChanged>((event, emit) => emit(state.copyWith(rg: event.rg)));
    on<CadastroDataNascimentoChanged>(
        (event, emit) => emit(state.copyWith(dataNascimento: event.data)));
    on<CadastroEstadoCivilChanged>(
        (event, emit) => emit(state.copyWith(estadoCivil: event.estadoCivil)));
    on<CadastroGeneroChanged>(
        (event, emit) => emit(state.copyWith(genero: event.genero)));

    on<CadastroCpfChanged>((event, emit) {
      emit(state.copyWith(
          cpf: event.cpf, cpfStatus: CpfStatus.initial, errorMessage: ''));
    });

    // O handler que estava faltando:
    on<CadastroCpfUnfocused>(_onCpfUnfocused);
    on<CadastroFotoChanged>((event, emit) {
      emit(state.copyWith(foto: event.foto));
    });
    on<CadastroSubmitted>(_onSubmitted);

    on<CadastroSituacaoMoradiaChanged>(
        (event, emit) => emit(state.copyWith(situacaoMoradia: event.situacao)));
    on<CadastroCepChanged>(
        (event, emit) => emit(state.copyWith(cep: event.cep)));
    on<CadastroRuaChanged>(
        (event, emit) => emit(state.copyWith(rua: event.rua)));
  }

  Future<void> _onCpfUnfocused(
    CadastroCpfUnfocused event,
    Emitter<CadastroState> emit,
  ) async {
    if (state.cpf.length != 11) {
      emit(state.copyWith(
          cpfStatus: CpfStatus.invalid,
          errorMessage: "CPF deve ter 11 dígitos"));
      return;
    }
    emit(state.copyWith(cpfStatus: CpfStatus.checking));
    try {
      final exists = await _assistidoRepository.checkIfCpfExists(state.cpf);
      if (exists) {
        emit(state.copyWith(
            cpfStatus: CpfStatus.invalid, errorMessage: "CPF já cadastrado"));
      } else {
        emit(state.copyWith(cpfStatus: CpfStatus.valid));
      }
    } catch (e) {
      emit(state.copyWith(
          cpfStatus: CpfStatus.failure, errorMessage: "Erro ao validar CPF"));
    }
  }

  Future<void> _onSubmitted(
    CadastroSubmitted event,
    Emitter<CadastroState> emit,
  ) async {
    emit(state.copyWith(submissionAttempted: true));

    if (!state.isCpfValid) return;
    if (!state.isDadosPessoaisValid) {
      // Se não for válido, não prossegue. A UI irá reagir e mostrar os erros.
      return;
    }
    emit(state.copyWith(formStatus: FormStatus.loading));
    try {
      await _assistidoRepository.createAssistido(state.toJson());
      emit(state.copyWith(formStatus: FormStatus.success));
    } on Exception catch (e) {
      final message = e.toString().contains('assistidos_cpf_key')
          ? 'Erro: CPF já cadastrado.'
          : 'Falha ao salvar. Tente novamente.';
      emit(state.copyWith(
          formStatus: FormStatus.failure, errorMessage: message));
    }
  }
}
