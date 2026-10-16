
import '../../models/monitor.dart';
import '../mocks/monitores_mock.dart';

class MonitorRepository {
  List<Monitor> obterTodos() {
    return monitoresMock;
  }
}
