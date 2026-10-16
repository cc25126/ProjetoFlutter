
import 'horario.dart';

class Monitor {
  final String id;
  final String nome;
  final String ra;
  final String? fotoUrl;
  final List<Horario> horarios;

  const Monitor({
    required this.id,
    required this.nome,
    required this.ra,
    this.fotoUrl,
    required this.horarios,
  });
}
