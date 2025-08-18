import 'package:assistencia_social/features/assistidos/bloc/cadastro_bloc.dart';
import 'package:assistencia_social/features/assistidos/data/repositories/assistido_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'tabs/dados_pessoais_tab.dart';

class CadastroAssistidoScreen extends StatefulWidget {
  const CadastroAssistidoScreen({super.key});

  @override
  State<CadastroAssistidoScreen> createState() =>
      _CadastroAssistidoScreenState();
}

class _CadastroAssistidoScreenState extends State<CadastroAssistidoScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CadastroBloc(AssistidoRepository(Supabase.instance.client)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cadastro de Assistido'),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Column(
          children: [
            // Custom Tab Bar com design de pasta
            Container(
              color: Colors.blue.shade700,
              child: Stack(
                children: [
                  // Background das abas
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue.shade700,
                          Colors.blue.shade600,
                        ],
                      ),
                    ),
                  ),
                  // Abas customizadas
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      child: Row(
                        children: [
                          _buildFolderTab(
                            'Dados Pessoais',
                            Colors.blue.shade600,
                            Colors.white,
                            0,
                          ),
                          _buildFolderTab(
                            'Endereço',
                            Colors.teal.shade600,
                            Colors.white,
                            1,
                          ),
                          _buildFolderTab(
                            'Família',
                            Colors.orange.shade700,
                            Colors.white,
                            2,
                          ),
                          _buildFolderTab(
                            'Perfil\nSocioeconômico',
                            Colors.amber.shade700,
                            Colors.white,
                            3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Conteúdo das abas
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: TabBarView(
                    controller: _tabController,
                    children: const <Widget>[
                      DadosPessoaisTab(),
                      Center(child: Text("Conteúdo de Endereço")),
                      Center(child: Text("Conteúdo de Família")),
                      Center(child: Text("Conteúdo de Perfil Socioeconômico")),
                    ],
                  ),
                ),
              ),
            ),
            // Botão inferior
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    offset: const Offset(0, -2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: BlocBuilder<CadastroBloc, CadastroState>(
                  builder: (context, state) {
                    return ElevatedButton.icon(
                      onPressed: state.formStatus == FormStatus.loading
                          ? null
                          : () {
                              context
                                  .read<CadastroBloc>()
                                  .add(CadastroSubmitted());
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      icon: state.formStatus == FormStatus.loading
                          ? Container(
                              width: 20,
                              height: 20,
                              padding: const EdgeInsets.all(2.0),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.save),
                      label: const Text(
                        'Salvar Cadastro',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderTab(
      String title, Color color, Color textColor, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _tabController.animateTo(index);
        },
        child: AnimatedBuilder(
          animation: _tabController,
          builder: (context, child) {
            bool isSelected = _tabController.index == index;
            return Container(
              margin: const EdgeInsets.only(right: 1),
              child: Stack(
                children: [
                  // Sombra da pasta
                  if (isSelected)
                    Positioned(
                      top: 2,
                      left: 2,
                      right: -2,
                      bottom: -1,
                      child: CustomPaint(
                        painter:
                            FolderShadowPainter(Colors.black.withOpacity(0.15)),
                      ),
                    ),
                  // Pasta principal
                  Container(
                    height: isSelected ? 60 : 48,
                    margin: EdgeInsets.only(top: isSelected ? 0 : 12),
                    child: CustomPaint(
                      painter: FolderTabPainter(
                        color: color,
                        isSelected: isSelected,
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                          top: isSelected ? 8 : 6,
                          bottom: 12,
                          left: 12,
                          right: 12,
                        ),
                        child: Center(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: textColor,
                              fontSize: isSelected ? 13 : 11,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Painter customizado para criar o formato de pasta
class FolderTabPainter extends CustomPainter {
  final Color color;
  final bool isSelected;

  FolderTabPainter({required this.color, required this.isSelected});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    // Dimensões mais simples e limpas
    double cornerRadius = 8;
    double tabWidth = size.width * 0.3; // Aba menor
    double tabHeight = 6;

    // Construindo o formato da pasta de forma mais simples
    // Começar do canto esquerdo
    path.moveTo(0, size.height - cornerRadius);

    // Canto inferior esquerdo arredondado
    path.arcToPoint(
      Offset(cornerRadius, size.height),
      radius: Radius.circular(cornerRadius),
    );

    // Base da pasta
    path.lineTo(size.width - cornerRadius, size.height);

    // Canto inferior direito arredondado
    path.arcToPoint(
      Offset(size.width, size.height - cornerRadius),
      radius: Radius.circular(cornerRadius),
    );

    // Lado direito
    path.lineTo(size.width, tabHeight + cornerRadius);

    // Canto superior direito
    path.arcToPoint(
      Offset(size.width - cornerRadius, tabHeight),
      radius: Radius.circular(cornerRadius),
    );

    // Linha até onde começa a "orelha"
    path.lineTo(tabWidth + 15, tabHeight);

    // Pequena curva da orelha (mais suave)
    path.quadraticBezierTo(
      tabWidth + 8,
      tabHeight - 3,
      tabWidth,
      0,
    );

    // Topo da orelha
    path.lineTo(cornerRadius, 0);

    // Canto superior esquerdo da orelha
    path.arcToPoint(
      Offset(0, cornerRadius),
      radius: Radius.circular(cornerRadius),
    );

    // Lado esquerdo
    path.close();

    // Gradiente mais sutil
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color.withOpacity(isSelected ? 1.0 : 0.85),
        color.withOpacity(isSelected ? 0.95 : 0.8),
      ],
    );

    final paint = Paint()
      ..shader =
          gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    // Borda muito sutil
    if (isSelected) {
      final borderPaint = Paint()
        ..color = color.withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;
      canvas.drawPath(path, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Painter para a sombra da pasta
class FolderShadowPainter extends CustomPainter {
  final Color color;

  FolderShadowPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final path = Path();

    double cornerRadius = 8;
    double tabWidth = size.width * 0.3;
    double tabHeight = 6;

    // Mesmo formato da pasta principal, mas simplificado para sombra
    path.moveTo(0, size.height - cornerRadius);
    path.arcToPoint(
      Offset(cornerRadius, size.height),
      radius: Radius.circular(cornerRadius),
    );
    path.lineTo(size.width - cornerRadius, size.height);
    path.arcToPoint(
      Offset(size.width, size.height - cornerRadius),
      radius: Radius.circular(cornerRadius),
    );
    path.lineTo(size.width, tabHeight + cornerRadius);
    path.arcToPoint(
      Offset(size.width - cornerRadius, tabHeight),
      radius: Radius.circular(cornerRadius),
    );
    path.lineTo(tabWidth + 15, tabHeight);
    path.quadraticBezierTo(
      tabWidth + 8,
      tabHeight - 3,
      tabWidth,
      0,
    );
    path.lineTo(cornerRadius, 0);
    path.arcToPoint(
      Offset(0, cornerRadius),
      radius: Radius.circular(cornerRadius),
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
