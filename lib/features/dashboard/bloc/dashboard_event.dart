part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

// Evento disparado quando a tela quer carregar os assistidos.
class DashboardAssistidosFetched extends DashboardEvent {}
