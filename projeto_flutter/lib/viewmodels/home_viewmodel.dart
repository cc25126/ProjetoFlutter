
import 'package:flutter/foundation.dart';

import '../data/repositories/monitor_repository.dart';
import '../models/monitor.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    MonitorRepository? repository,
  }) : _repository = repository ?? MonitorRepository();

  final MonitorRepository _repository;

  String? _diaSelecionado;

  String? get diaSelecionado => _diaSelecionado;

  bool get temFiltroSelecionado => _diaSelecionado != null;

  List<Monitor> get monitoresFiltrados {
    final todos = _repository.obterTodos();

    if (_diaSelecionado == null) {
      return [];
    }

    if (_diaSelecionado == 'Todos') {
      return todos;
    }

    return todos.where((monitor) {
      return monitor.horarios.any(
        (horario) => horario.diaSemana == _diaSelecionado,
      );
    }).toList();
  }

  void selecionarDia(String dia) {
    _diaSelecionado = dia;
    notifyListeners();
  }

  void limparFiltro() {
    _diaSelecionado = null;
    notifyListeners();
  }
}
