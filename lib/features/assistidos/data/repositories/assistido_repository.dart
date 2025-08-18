import 'package:supabase_flutter/supabase_flutter.dart';

// Definindo um tipo para clareza. Um Assistido é um Mapa de String para dynamic.
typedef Assistido = Map<String, dynamic>;

class AssistidoRepository {
  // O cliente Supabase, que permite a comunicação com o banco de dados.
  final SupabaseClient _client;

  AssistidoRepository(this._client);

  /// Busca a lista completa de assistidos no banco de dados.
  /// Ordena por nome completo em ordem crescente.
  Future<List<Assistido>> fetchAssistidos() async {
    try {
      final response = await _client
          .from('assistidos')
          .select() // Equivale a 'SELECT *'
          .order('nome_completo', ascending: true);

      // O Supabase retorna uma List<dynamic>, então convertemos para o nosso tipo.
      return List<Assistido>.from(response);
    } on PostgrestException catch (e) {
      // Erro específico do Supabase (ex: tabela não encontrada, falha de RLS)
      print('Erro do Supabase ao buscar assistidos: ${e.message}');
      rethrow;
    } catch (e) {
      // Outros erros (ex: problema de rede)
      print('Erro inesperado ao buscar assistidos: $e');
      rethrow;
    }
  }

  Future<void> createAssistido(Map<String, dynamic> assistidoData) async {
    try {
      // O método 'insert' do Supabase recebe um mapa e cria uma nova linha.
      await _client.from('assistidos').insert(assistidoData);
    } on PostgrestException catch (e) {
      // Tratamento de erro específico do Supabase
      print('Erro do Supabase ao criar assistido: ${e.message}');
      // Relançamos o erro para que o BLoC possa tratá-lo.
      rethrow;
    } catch (e) {
      print('Erro inesperado ao criar assistido: $e');
      rethrow;
    }
  }

  // Futuramente, adicionaremos outros métodos aqui, como:
  // - fetchAssistidoByCpf(String cpf)
  // - createAssistido(Assistido data)
  // - updateAssistido(String id, Assistido data)
  // - deleteAssistido(String id)

  Future<bool> checkIfCpfExists(String cpf) async {
    try {
      final response =
          await _client.from('assistidos').select('id').eq('cpf', cpf);

      // O response é uma lista; se não estiver vazia, o CPF existe.
      return (response as List).isNotEmpty;
    } catch (e) {
      print('Erro ao verificar CPF: $e');
      return false;
    }
  }
}
