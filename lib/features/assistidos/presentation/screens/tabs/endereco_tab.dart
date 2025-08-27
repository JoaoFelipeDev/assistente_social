import 'package:assistencia_social/features/assistidos/bloc/cadastro_bloc.dart';
import 'package:assistencia_social/features/assistidos/domain/models/assistido_enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class EnderecoTab extends StatelessWidget {
  const EnderecoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Cor de fundo da aba, conforme seu design
      color: const Color(0xFF00695C), // Tom de verde/teal
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 32.0),
        child: BlocBuilder<CadastroBloc, CadastroState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<SituacaoMoradia>(
                  decoration:
                      const InputDecoration(labelText: 'Situação da Moradia'),
                  items: SituacaoMoradia.values.map((situacao) {
                    return DropdownMenuItem(
                        value: situacao, child: Text(situacao.displayName));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      context
                          .read<CadastroBloc>()
                          .add(CadastroSituacaoMoradiaChanged(value));
                    }
                  },
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'CEP'),
                  onChanged: (value) => context
                      .read<CadastroBloc>()
                      .add(CadastroCepChanged(value)),
                  // TODO: Adicionar máscara de CEP e busca automática
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'Rua'),
                        onChanged: (value) => context
                            .read<CadastroBloc>()
                            .add(CadastroRuaChanged(value)),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'Nº'),
                        onChanged: (value) {
                          // Criar e adicionar evento para o número
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Bairro'),
                  onChanged: (value) {
                    // Criar e adicionar evento para o bairro
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'Cidade'),
                        onChanged: (value) {
                          // Criar e adicionar evento para a cidade
                        },
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'UF'),
                        onChanged: (value) {
                          // Criar e adicionar evento para UF
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
