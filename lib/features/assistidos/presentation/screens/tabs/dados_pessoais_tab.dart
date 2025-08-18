import 'package:assistencia_social/features/assistidos/bloc/cadastro_bloc.dart';
import 'package:flutter/material.dart';
import 'package:assistencia_social/features/assistidos/domain/models/assistido_enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DadosPessoaisTab extends StatefulWidget {
  const DadosPessoaisTab({super.key});

  @override
  State<DadosPessoaisTab> createState() => _DadosPessoaisTabState();
}

class _DadosPessoaisTabState extends State<DadosPessoaisTab> {
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      // Data inicial que o calendário irá mostrar
      initialDate: _selectedDate ?? DateTime.now(),
      // Data mais antiga permitida (100 anos atrás)
      firstDate: DateTime(DateTime.now().year - 100),
      // Data mais recente permitida (hoje)
      lastDate: DateTime.now(),
    );

    // Se o usuário selecionou uma data, atualizamos o estado
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Formatamos a data para o padrão brasileiro e atualizamos o campo de texto
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
      context.read<CadastroBloc>().add(CadastroDataNascimentoChanged(picked));
    }
  }

  @override
  void dispose() {
    // É importante limpar o controlador quando o widget é destruído
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usamos um LayoutBuilder para adaptar o layout a diferentes larguras de tela
    return Container(
      color: const Color(0xFF2B5DA7),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Se a tela for larga (desktop), usamos o layout com a foto ao lado
          if (constraints.maxWidth > 800) {
            return _buildWideLayout();
          } else {
            // Se for estreita (talvez um dia no celular), usamos um layout vertical
            return _buildNarrowLayout();
          }
        },
      ),
    );
  }

  // Layout para telas largas (Desktop)
  Widget _buildWideLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 32.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coluna Esquerda: Formulário
          Expanded(
            flex: 2, // Ocupa 2/3 da largura
            child: _buildForm(),
          ),
          const SizedBox(width: 48),
          // Coluna Direita: Foto
          Expanded(
            flex: 1, // Ocupa 1/3 da largura
            child: _buildPhotoSection(),
          ),
        ],
      ),
    );
  }

  // Layout para telas estreitas
  Widget _buildNarrowLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          _buildForm(),
          const SizedBox(height: 32),
          _buildPhotoSection(),
        ],
      ),
    );
  }

  // Widget do Formulário (reutilizado nos dois layouts)
  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(labelText: 'Nome Completo'),
          onChanged: (value) {
            // Dispara o evento com o novo valor do nome
            context.read<CadastroBloc>().add(CadastroNomeChanged(value));
          },
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'CPF'),
                onChanged: (value) {
                  // Dispara o evento com o novo valor do CPF
                  context.read<CadastroBloc>().add(CadastroCpfChanged(value));
                },
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'RG'),
                onChanged: (value) {
                  // Dispara o evento com o novo valor do RG
                  context.read<CadastroBloc>().add(CadastroRgChanged(value));
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              // 4. Atualização do TextFormField de Data de Nascimento
              child: TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Data de Nascimento',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Estado Civil'),
                items: EstadoCivil.values.map((estado) {
                  return DropdownMenuItem(
                    value: estado,
                    child: Text(estado.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  // TODO: Conectar ao BLoC para salvar o estado
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        DropdownButtonFormField<Genero>(
          decoration: const InputDecoration(labelText: 'Gênero'),
          items: Genero.values.map((genero) {
            return DropdownMenuItem(
                value: genero, child: Text(genero.displayName));
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              // Dispara o evento com o novo gênero selecionado
              context.read<CadastroBloc>().add(CadastroGeneroChanged(value));
            }
          },
        ),
        const SizedBox(height: 24),
        TextFormField(
          decoration:
              const InputDecoration(labelText: 'Naturalidade (Cidade - UF)'),
        ),
        const SizedBox(height: 24),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Contato/WhatsApp'),
        ),
      ],
    );
  }

  // Widget da Seção da Foto (reutilizado nos dois layouts)
  Widget _buildPhotoSection() {
    return Column(
      children: [
        CircleAvatar(
          radius: 80,
          backgroundColor: Colors.grey.shade200,
          child: Icon(Icons.camera_alt, size: 60, color: Colors.grey.shade400),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            // TODO: Implementar lógica de upload/captura de foto
          },
          child: const Text('Carregar Foto'),
        ),
      ],
    );
  }
}
