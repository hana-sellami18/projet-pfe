import '../data/models/sujet_model.dart';

abstract class InternshipState {
  const InternshipState(); // Ajout du constructeur parent const
}

class InternshipInitial extends InternshipState {
  const InternshipInitial();
}

class InternshipLoading extends InternshipState {
  const InternshipLoading();
}

class SubjectsLoaded extends InternshipState {
  final List<SujetModel> subjects;
  const SubjectsLoaded(this.subjects); // Ajout de const
}

class CandidatureSuccess extends InternshipState {
  const CandidatureSuccess();
}

class InternshipError extends InternshipState {
  final String message;
  const InternshipError(this.message); // Ajout de const ici pour corriger l'erreur
}