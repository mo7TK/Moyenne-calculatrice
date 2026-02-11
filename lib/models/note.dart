class Note {
  final String matiere;
  final double noteControle; // Note de contrôle continu (40%)
  final double noteExamen; // Note d'examen (60%)
  final int coefficient;

  Note({
    required this.matiere,
    required this.noteControle,
    required this.noteExamen,
    required this.coefficient,
  });

  // Calcule la note finale: (contrôle * 0.4) + (examen * 0.6)
  double get noteFinale {
    return (noteControle * 0.4) + (noteExamen * 0.6);
  }

  // Calcule la note pondérée: noteFinale * coefficient
  double get notePonderee {
    return noteFinale * coefficient;
  }

  // Vérifie si l'étudiant a validé la matière
  bool get estValide {
    return noteFinale >= 10;
  }

  // Convertir Note en Map pour la sauvegarde
  Map<String, dynamic> toJson() {
    return {
      'matiere': matiere,
      'noteControle': noteControle,
      'noteExamen': noteExamen,
      'coefficient': coefficient,
    };
  }

  // Créer une Note à partir d'un Map
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      matiere: json['matiere'],
      noteControle: json['noteControle'],
      noteExamen: json['noteExamen'],
      coefficient: json['coefficient'],
    );
  }
}
