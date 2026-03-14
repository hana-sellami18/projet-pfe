import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/internship_repository.dart';
import 'internship_event.dart';
import 'internship_state.dart';

class InternshipBloc extends Bloc<InternshipEvent, InternshipState> {
  final InternshipRepository repository;

  InternshipBloc({required this.repository}) : super(const InternshipInitial()) {

    on<LoadSubjects>((event, emit) async {
      emit(const InternshipLoading());
      try {
        final subjects = await repository.getAvailableSubjects();

        if (subjects.isEmpty) {
          // Ce "const" ne provoquera plus d'erreur
          emit(const InternshipError("Aucun sujet disponible pour le moment"));
        } else {
          emit(SubjectsLoaded(subjects));
        }
      } catch (e) {
        // Pas de const ici car e.toString() est dynamique
        emit(InternshipError(e.toString()));
      }
    });

    on<SubmitCandidature>((event, emit) async {
      final currentState = state;
      emit(const InternshipLoading());

      try {
        await repository.postuler(event.sujetId, event.filePath);
        emit(const CandidatureSuccess());
        add(LoadSubjects());
      } catch (e) {
        emit(InternshipError(e.toString()));
        if (currentState is SubjectsLoaded) emit(currentState);
      }
    });
  }
}