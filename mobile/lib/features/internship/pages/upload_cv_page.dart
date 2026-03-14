import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/internship_bloc.dart';
import '../logic/internship_event.dart';
import '../logic/internship_state.dart';
import '../widgets/upload/upload_header.dart';
import '../widgets/upload/upload_stepper_card.dart';
import '../widgets/upload/upload_drop_zone.dart';
import '../widgets/upload/upload_file_preview.dart';
import '../widgets/upload/upload_success_sheet.dart';

const Color asmOrange = Color(0xFFF28C28);
const Color asmOrangeDark = Color(0xFFE65100);

@RoutePage()
class UploadCvPage extends StatefulWidget {
  final int sujetId;
  const UploadCvPage({super.key, required this.sujetId});

  @override
  State<UploadCvPage> createState() => _UploadCvPageState();
}

class _UploadCvPageState extends State<UploadCvPage>
    with TickerProviderStateMixin {
  String? _filePath;
  String? _fileName;
  int? _fileSize;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.93, end: 1.07).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      _fadeController.reset();
      setState(() {
        _filePath = result.files.single.path;
        _fileName = result.files.single.name;
        _fileSize = result.files.single.size;
      });
      _fadeController.forward();
    }
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / 1048576).toStringAsFixed(1)} MB';
  }

  void _submit(BuildContext context) {
    if (_filePath == null) return;
    context.read<InternshipBloc>().add(
      SubmitCandidature(widget.sujetId, _filePath!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternshipBloc, InternshipState>(
      listener: (context, state) {
        if (state is CandidatureSuccess) {
          showUploadSuccessSheet(context);
        } else if (state is InternshipError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              content: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(state.message,
                        style: const TextStyle(
                            color: Colors.white, fontFamily: 'Poppins')),
                  ),
                ],
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        body: Column(
          children: [
            // ── Header orange ────────────────────────────────
            const UploadHeader(),
            // ── Corps scrollable ─────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stepper card
                    const UploadStepperCard(),
                    const SizedBox(height: 20),

                    // Titre
                    const Text(
                      'Votre CV',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Format PDF uniquement · Max 5 MB',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Zone upload
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: _filePath == null
                          ? UploadDropZone(
                        pulseAnimation: _pulseAnimation,
                        onTap: _pickFile,
                      )
                          : UploadFilePreview(
                        fileName: _fileName!,
                        fileSize: _fileSize,
                        formatSize: _formatSize,
                        onReplace: _pickFile,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Note info
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: asmOrange.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(12),
                        border:
                        Border.all(color: asmOrange.withOpacity(0.2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: asmOrange.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(Icons.info_outline_rounded,
                                color: asmOrange, size: 14),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Votre candidature sera créée avec le statut EN_ATTENTE. '
                                  "L'encadrant sera notifié de votre dépôt.",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                                height: 1.6,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Bouton soumettre
                    BlocBuilder<InternshipBloc, InternshipState>(
                      builder: (context, state) {
                        final isLoading = state is InternshipLoading;
                        return Column(
                          children: [
                            if (_filePath == null && !isLoading)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.arrow_upward_rounded,
                                        size: 14,
                                        color: Colors.grey.shade400),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Sélectionnez un fichier pour continuer',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: (_filePath != null && !isLoading)
                                    ? () => _submit(context)
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: asmOrange,
                                  disabledBackgroundColor:
                                  Colors.grey.shade200,
                                  foregroundColor: Colors.white,
                                  disabledForegroundColor:
                                  Colors.grey.shade400,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 0,
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                                    : const Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.send_rounded, size: 18),
                                    SizedBox(width: 10),
                                    Text(
                                      'Soumettre ma candidature',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}