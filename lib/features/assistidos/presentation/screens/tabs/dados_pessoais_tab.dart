import 'dart:io';

import 'package:assistencia_social/features/assistidos/bloc/cadastro_bloc.dart';
import 'package:flutter/material.dart';
import 'package:assistencia_social/features/assistidos/domain/models/assistido_enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class DadosPessoaisTab extends StatefulWidget {
  const DadosPessoaisTab({super.key});

  @override
  State<DadosPessoaisTab> createState() => _DadosPessoaisTabState();
}

class _DadosPessoaisTabState extends State<DadosPessoaisTab> {
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;

  final _cpfFocusNode =
      FocusNode(); // 🔹 FocusNode para capturar quando perde o foco

  @override
  void initState() {
    super.initState();

    // Listener para disparar evento quando o CPF perde o foco
    _cpfFocusNode.addListener(() {
      if (!_cpfFocusNode.hasFocus) {
        context.read<CadastroBloc>().add(CadastroCpfUnfocused());
      }
    });
  }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    // Abre a galeria para o usuário escolher uma imagem
    final XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Envia o evento para o BLoC com o arquivo selecionado
      context.read<CadastroBloc>().add(CadastroFotoChanged(pickedFile));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
      context.read<CadastroBloc>().add(CadastroDataNascimentoChanged(picked));
    }
  }

  @override
  void dispose() {
    _cpfFocusNode.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 109, 154, 223),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return _buildWideLayout();
          } else {
            return _buildNarrowLayout();
          }
        },
      ),
    );
  }

  Widget _buildWideLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 32.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: _buildForm()),
          const SizedBox(width: 48),
          Expanded(flex: 1, child: _buildPhotoSection()),
        ],
      ),
    );
  }

  Widget _buildNarrowLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: BlocBuilder<CadastroBloc, CadastroState>(
        builder: (context, state) {
          String? showError(String value) {
            return state.submissionAttempted && value.isEmpty
                ? 'Campo obrigatório'
                : null;
          }

          String? showErrorForNullable(Object? value) {
            return state.submissionAttempted && value == null
                ? 'Campo obrigatório'
                : null;
          }

          return Column(
            children: [
              _buildForm(),
              const SizedBox(height: 32),
              _buildPhotoSection(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(labelText: 'Nome Completo'),
          onChanged: (value) =>
              context.read<CadastroBloc>().add(CadastroNomeChanged(value)),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            // 🔹 Campo CPF com validação integrada ao Bloc
            Expanded(
              child: BlocBuilder<CadastroBloc, CadastroState>(
                builder: (context, state) {
                  return TextFormField(
                    focusNode: _cpfFocusNode,
                    onChanged: (value) => context
                        .read<CadastroBloc>()
                        .add(CadastroCpfChanged(value)),
                    decoration: InputDecoration(
                      labelText: 'CPF',
                      errorText: !state.isCpfValid ? state.errorMessage : null,
                      suffixIcon: _buildCpfStatusIcon(state.cpfStatus),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'RG'),
                onChanged: (value) =>
                    context.read<CadastroBloc>().add(CadastroRgChanged(value)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
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
                  // TODO: conectar ao Bloc
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

  Widget _buildPhotoSection() {
    return BlocBuilder<CadastroBloc, CadastroState>(
      builder: (context, state) {
        return Column(
          children: [
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.grey.shade200,
              // Mostra a imagem selecionada ou o ícone da câmera
              backgroundImage:
                  state.foto != null ? FileImage(File(state.foto!.path)) : null,
              child: state.foto == null
                  ? Icon(Icons.camera_alt,
                      size: 60, color: Colors.grey.shade400)
                  : null,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _pickImage, // Chama a função para escolher a imagem
              icon: const Icon(Icons.upload, color: Colors.white),
              label: const Text('Carregar Foto',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  /// 🔹 Ícones de status para o CPF
  Widget? _buildCpfStatusIcon(CpfStatus status) {
    switch (status) {
      case CpfStatus.checking:
        return const Padding(
          padding: EdgeInsets.all(12.0),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      case CpfStatus.valid:
        return const Icon(Icons.check_circle, color: Colors.green);
      case CpfStatus.invalid:
        return const Icon(Icons.error, color: Colors.red);
      default:
        return null;
    }
  }
}
