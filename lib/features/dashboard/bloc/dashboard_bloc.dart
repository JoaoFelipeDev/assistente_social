import 'package:assistencia_social/features/assistidos/data/repositories/assistido_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final AssistidoRepository _assistidoRepository;

  DashboardBloc({required AssistidoRepository assistidoRepository})
      : _assistidoRepository = assistidoRepository,
        super(const DashboardState()) {
    on<DashboardAssistidosFetched>(_onAssistidosFetched);
  }

  Future<void> _onAssistidosFetched(
    DashboardAssistidosFetched event,
    Emitter<DashboardState> emit,
  ) async {
    // 1. Emite o estado de 'loading' para a UI mostrar um spinner.
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      // 2. Chama o repository para buscar os dados.
      final assistidos = await _assistidoRepository.fetchAssistidos();
      // 3. Emite o estado de 'success' com os dados carregados.
      emit(state.copyWith(
        status: DashboardStatus.success,
        assistidos: assistidos,
      ));
    } catch (e) {
      // 4. Em caso de erro, emite o estado de 'failure'.
      emit(state.copyWith(
        status: DashboardStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
