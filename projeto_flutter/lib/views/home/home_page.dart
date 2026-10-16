
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/monitor.dart';
import '../../viewmodels/home_viewmodel.dart';

const Color rosaPrincipal = Color(0xFFD81B83);
const Color rosaClaro = Color(0xFFFCE4F1);
const Color rosaFundo = Color(0xFFFFF7FB);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<String> dias = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitores DCOMP'),
        backgroundColor: rosaClaro,
        foregroundColor: rosaPrincipal,
      ),
      drawer: NavigationDrawer(
        backgroundColor: rosaFundo,
        indicatorColor: rosaClaro,
        selectedIndex: _indiceSelecionado(viewModel.diaSelecionado),
        onDestinationSelected: (index) {
          final vm = context.read<HomeViewModel>();

          if (index == 5) {
            vm.selecionarDia('Todos');
          } else {
            vm.selecionarDia(dias[index]);
          }

          Navigator.pop(context);
        },
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 20, 16, 12),
            child: Text(
              'Filtrar monitores',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: rosaPrincipal,
              ),
            ),
          ),
          ...dias.map(
            (dia) => NavigationDrawerDestination(
              icon: const Icon(Icons.calendar_today_outlined),
              selectedIcon: const Icon(Icons.calendar_today),
              label: Text(dia),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(color: rosaClaro),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: Text('Todos'),
          ),
        ],
      ),
      body: Container(
        color: rosaFundo,
        child: _conteudo(context, viewModel),
      ),
    );
  }

  int? _indiceSelecionado(String? dia) {
    if (dia == null) return null;
    if (dia == 'Todos') return 5;

    final indice = dias.indexOf(dia);
    return indice >= 0 ? indice : null;
  }

  Widget _conteudo(
    BuildContext context,
    HomeViewModel viewModel,
  ) {
    if (!viewModel.temFiltroSelecionado) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month_rounded,
              size: 72,
              color: rosaPrincipal,
            ),
            SizedBox(height: 16),
            Text(
              'Encontre seu monitor',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: rosaPrincipal,
              ),
            ),
            SizedBox(height: 8),
            Text('Abra o menu para selecionar um dia.'),
          ],
        ),
      );
    }

    final monitores = viewModel.monitoresFiltrados;

    if (monitores.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.event_busy_outlined,
                size: 64,
                color: rosaPrincipal,
              ),
              const SizedBox(height: 16),
              Text(
                'Nenhum horário cadastrado para '
                '${viewModel.diaSelecionado}.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: rosaPrincipal,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Os horários desse dia ainda precisam '
                'ser cadastrados.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
          child: Text(
            viewModel.diaSelecionado == 'Todos'
                ? 'Todos os monitores'
                : 'Monitores de ${viewModel.diaSelecionado}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: rosaPrincipal,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Deslize para conhecer os monitores'),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 300,
          child: _CarrosselMonitores(
            key: ValueKey(viewModel.diaSelecionado),
            monitores: monitores,
            filtroOrigem: viewModel.diaSelecionado!,
          ),
        ),
      ],
    );
  }
}

class _CarrosselMonitores extends StatefulWidget {
  const _CarrosselMonitores({
    super.key,
    required this.monitores,
    required this.filtroOrigem,
  });

  final List<Monitor> monitores;
  final String filtroOrigem;

  @override
  State<_CarrosselMonitores> createState() =>
      _CarrosselMonitoresState();
}

class _CarrosselMonitoresState extends State<_CarrosselMonitores> {
  late final PageController _pageController;
  int _paginaAtual = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      viewportFraction: 0.76,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _irPara(int pagina) {
    if (pagina < 0 || pagina >= widget.monitores.length) {
      return;
    }

    _pageController.animateToPage(
      pagina,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: widget.monitores.length,
          physics: const PageScrollPhysics(),
          padEnds: true,
          onPageChanged: (pagina) {
            setState(() {
              _paginaAtual = pagina;
            });
          },
          itemBuilder: (context, index) {
            final monitor = widget.monitores[index];

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
              child: _MonitorCard(
                monitor: monitor,
                onTap: () {
                  context.push(
                    '/detalhes',
                    extra: {
                      'monitor': monitor,
                      'filtroOrigem': widget.filtroOrigem,
                    },
                  );
                },
              ),
            );
          },
        ),
        Positioned(
          left: 4,
          child: IconButton.filled(
            tooltip: 'Monitor anterior',
            onPressed: _paginaAtual > 0
                ? () => _irPara(_paginaAtual - 1)
                : null,
            style: IconButton.styleFrom(
              backgroundColor: rosaPrincipal,
              foregroundColor: Colors.white,
              disabledBackgroundColor: rosaClaro,
              disabledForegroundColor: rosaPrincipal,
            ),
            icon: const Icon(Icons.chevron_left),
          ),
        ),
        Positioned(
          right: 4,
          child: IconButton.filled(
            tooltip: 'Próximo monitor',
            onPressed: _paginaAtual < widget.monitores.length - 1
                ? () => _irPara(_paginaAtual + 1)
                : null,
            style: IconButton.styleFrom(
              backgroundColor: rosaPrincipal,
              foregroundColor: Colors.white,
              disabledBackgroundColor: rosaClaro,
              disabledForegroundColor: rosaPrincipal,
            ),
            icon: const Icon(Icons.chevron_right),
          ),
        ),
      ],
    );
  }
}

class _MonitorCard extends StatelessWidget {
  const _MonitorCard({
    required this.monitor,
    required this.onTap,
  });

  final Monitor monitor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shadowColor: rosaPrincipal.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(
          color: rosaClaro,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        splashColor: rosaClaro,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 48,
                backgroundColor: rosaClaro,
                child: Icon(
                  Icons.person,
                  size: 52,
                  color: rosaPrincipal,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                monitor.nome,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: rosaPrincipal,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'RA: ${monitor.ra}',
                style: const TextStyle(
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ver horários',
                    style: TextStyle(
                      color: rosaPrincipal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: rosaPrincipal,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
