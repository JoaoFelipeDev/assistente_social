part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  const DashboardState({
    this.status = DashboardStatus.initial,
    this.assistidos = const <Assistido>[],
    this.errorMessage = '',
  });

  final DashboardStatus status;
  final List<Assistido> assistidos;
  final String errorMessage;

  DashboardState copyWith({
    DashboardStatus? status,
    List<Assistido>? assistidos,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      assistidos: assistidos ?? this.assistidos,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, assistidos, errorMessage];
}
