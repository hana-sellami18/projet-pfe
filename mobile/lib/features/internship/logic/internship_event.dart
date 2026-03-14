abstract class InternshipEvent {}

class LoadSubjects extends InternshipEvent {}

class SubmitCandidature extends InternshipEvent {
  final int sujetId;
  final String filePath;
  SubmitCandidature(this.sujetId, this.filePath);
}