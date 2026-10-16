
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/home_viewmodel.dart';
import '../../models/monitor.dart';

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
      ),
      drawer: NavigationDrawer(
        selectedIndex: _indiceSelecionado(
          viewModel.diaSelecionado,
        ),
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
            child: Divider(),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: Text('Todos'),
          ),
        ],
      ),
      body: _conteudo(context, viewModel),
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
              color: Color.fromARGB(255, 182, 127, 255),
            ),
            SizedBox(height: 16),
            Text(
              'Encontre seu monitor',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
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
                color: Color(0xFF2457C5),
              ),
              const SizedBox(height: 16),
              Text(
                'Nenhum horário cadastrado para '
                '${viewModel.diaSelecionado}.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
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
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Deslize para conhecer os monitores'),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: PageController(
              viewportFraction: 0.76,
            ),
            itemCount: monitores.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                child: _MonitorCard(
                  monitor: monitores[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MonitorCard extends StatelessWidget {
  const _MonitorCard({
    required this.monitor,
  });

  final Monitor monitor;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 48,
              backgroundColor: Color(0xFFE1E9FF),
              child: Icon(
                Icons.person,
                size: 52,
                color: Color(0xFF2457C5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              monitor.nome,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('RA: ${monitor.ra}'),
            const SizedBox(height: 16),
            const Text(
              'Monitor acadêmico',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
