
import 'package:flutter/material.dart';

import '../../models/monitor.dart';

class DetalhesPage extends StatelessWidget {
  const DetalhesPage({
    super.key,
    required this.monitor,
    required this.filtroOrigem,
  });

  final Monitor monitor;
  final String filtroOrigem;

  @override
  Widget build(BuildContext context) {
    final horarios = filtroOrigem == 'Todos'
        ? monitor.horarios
        : monitor.horarios
            .where((h) => h.diaSemana == filtroOrigem)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do monitor'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: CircleAvatar(
              radius: 52,
              backgroundColor: const Color(0xFFE1E9FF),
              child: Text(
                monitor.nome.isNotEmpty
                    ? monitor.nome[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontSize: 36,
                  color: Color(0xFF2457C5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            monitor.nome,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text(
            'RA: ${monitor.ra}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          Text(
            filtroOrigem == 'Todos'
                ? 'Agenda completa'
                : 'Horários de $filtroOrigem',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          if (horarios.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.event_busy_outlined,
                      size: 44,
                      color: Color(0xFF2457C5),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Ainda não há horários cadastrados '
                      'para este monitor.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      filtroOrigem == 'Todos'
                          ? 'A agenda será exibida aqui quando '
                              'os dados oficiais forem cadastrados.'
                          : 'Não é possível confirmar um '
                              'atendimento neste dia ainda.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            )
          else
            ...horarios.map(
              (horario) => Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.schedule_rounded,
                    color: Color(0xFF2457C5),
                  ),
                  title: Text(horario.diaSemana),
                  subtitle: Text('${horario.hora}\n${horario.local}'),
                  isThreeLine: true,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
