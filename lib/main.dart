import 'package:assistencia_social/core/theme/app_theme.dart';
import 'package:assistencia_social/features/assistidos/data/repositories/assistido_repository.dart';
import 'package:assistencia_social/features/assistidos/presentation/screens/cadastro_assistido_screen.dart';
import 'package:assistencia_social/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:assistencia_social/features/dashboard/bloc/presentation/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ionhuzcxnwvqohvdanys.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlvbmh1emN4bnd2cW9odmRhbnlzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ1MTg4MjMsImV4cCI6MjA3MDA5NDgyM30.on9ItjkuLYjnYcLKQFunQOVoyIfgfzW2YC0cJ0eZR4s',
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Para injetar nossas dependências, criamos um repositório.
    // Ele será usado por todos os BLoCs que precisarem de dados de assistidos.
    final assistidoRepository = AssistidoRepository(supabase);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Assistência Social',
      theme: AppTheme.theme,
      // O BlocProvider disponibiliza o DashboardBloc para a tela DashboardScreen e seus filhos.
      home: BlocProvider(
        create: (context) => DashboardBloc(
          assistidoRepository: assistidoRepository,
        ),
        child: const CadastroAssistidoScreen(),
      ),
    );
  }
}
