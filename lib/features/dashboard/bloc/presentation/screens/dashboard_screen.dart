import 'package:assistencia_social/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// TODO: Importe sua classe de modelo Assistido
// import 'package:assistencia_social/features/dashboard/domain/entities/assistido.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Definindo constantes para espaçamento para fácil manutenção
  static const double _defaultPadding = 16.0;

  @override
  void initState() {
    super.initState();
    // Ao iniciar a tela, disparamos o evento para buscar os dados.
    context.read<DashboardBloc>().add(DashboardAssistidosFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Assistidos'),
        actions: [
          // Botão para cadastrar um novo assistido
          Padding(
            padding: const EdgeInsets.only(right: _defaultPadding),
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implementar a navegação para a tela de cadastro
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: const Text('Cadastrar Novo',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ),
        ],
      ),
      body: const _DashboardBody(defaultPadding: _defaultPadding),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.defaultPadding});

  final double defaultPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SearchBar(padding: defaultPadding),
        Expanded(
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              // Usar um switch é mais limpo e garante que todos os estados sejam tratados.
              switch (state.status) {
                case DashboardStatus.initial:
                case DashboardStatus.loading:
                  return const Center(child: CircularProgressIndicator());
                case DashboardStatus.failure:
                  return Center(
                    child: Text(
                      'Falha ao carregar os dados: ${state.errorMessage}',
                    ),
                  );
                case DashboardStatus.success:
                  if (state.assistidos.isEmpty) {
                    return const Center(
                        child: Text('Nenhum assistido cadastrado.'));
                  }
                  return _AssistidosList(
                      assistidos: state.assistidos, padding: defaultPadding);
              }
            },
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Buscar por Nome ou CPF',
          suffixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onChanged: (value) {
          // TODO: Implementar a lógica de busca com debounce no BLoC
        },
      ),
    );
  }
}

class _AssistidosList extends StatelessWidget {
  const _AssistidosList({required this.assistidos, required this.padding});

  // Assumindo que o state.assistidos agora é uma List<Assistido>
  final List<dynamic> assistidos; // Mude para List<Assistido>
  final double padding;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: assistidos.length,
      itemBuilder: (context, index) {
        // final assistido = assistidos[index] as Assistido;
        final assistido =
            assistidos[index]; // Remova o 'as Assistido' se mantiver dynamic
        return _AssistidoListItem(assistido: assistido, padding: padding);
      },
    );
  }
}

class _AssistidoListItem extends StatelessWidget {
  const _AssistidoListItem({required this.assistido, required this.padding});

  // final Assistido assistido;
  final dynamic assistido; // Mude para Assistido
  final double padding;

  @override
  Widget build(BuildContext context) {
    // Usando o modelo, o acesso aos dados é mais seguro e legível.
    // final nome = assistido.nomeCompleto;
    // final cpf = assistido.cpf;
    final nome = assistido['nome_completo'];
    final cpf = assistido['cpf'];

    return Card(
      margin: EdgeInsets.symmetric(horizontal: padding, vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          // TODO: Usar assistido.fotoUrl quando disponível
          child: Text(nome.isNotEmpty ? nome[0] : '?'),
        ),
        title: Text(nome),
        subtitle: Text('CPF: $cpf'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                // TODO: Navegar para tela de edição
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // TODO: Implementar diálogo de confirmação e exclusão
              },
            ),
          ],
        ),
        onTap: () {
          // TODO: Navegar para a tela de detalhes do assistido
        },
      ),
    );
  }
}
