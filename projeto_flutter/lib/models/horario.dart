class Horario {
  final String diaSemana;
  final String hora;
  final String local;

  const Horario({
    required this.diaSemana,
    required this.hora,
    this.local = 'Departamento de Computação',
  });
}