import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../widgets/list/subject_header.dart';
import '../widgets/list/subject_card.dart';
import '../widgets/list/state_widgets.dart';
import '../logic/internship_bloc.dart';
import '../logic/internship_event.dart';
import '../logic/internship_state.dart';
import '../data/models/sujet_model.dart';

@RoutePage()
class SubjectListPage extends StatefulWidget {
  const SubjectListPage({super.key});

  @override
  State<SubjectListPage> createState() => _SubjectListPageState();
}

class _SubjectListPageState extends State<SubjectListPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InternshipBloc>().add(LoadSubjects());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<SujetModel> _applyFilters(List<SujetModel> subjects) {
    return subjects.where((s) {
      return _searchQuery.isEmpty ||
          s.titre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Column(
        children: [
          const SubjectHeader(),
          _buildSearchBar(),
          Expanded(child: _buildListSection()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _searchQuery = v),
          decoration: InputDecoration(
            hintText: 'Rechercher un stage...',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon:
            Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildListSection() {
    return BlocBuilder<InternshipBloc, InternshipState>(
      builder: (context, state) {
        if (state is InternshipLoading) {
          return const Center(
              child: CircularProgressIndicator(
                  color: Color(0xFFF28C28), strokeWidth: 2));
        }
        if (state is InternshipError) {
          return ErrorStateWidget(
              message: state.message,
              onRetry: () =>
                  context.read<InternshipBloc>().add(LoadSubjects()));
        }

        if (state is SubjectsLoaded) {
          final filtered = _applyFilters(state.subjects);
          if (filtered.isEmpty) return const EmptyStateWidget();

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final animation = CurvedAnimation(
                parent: _controller,
                curve: Interval((index * 0.08).clamp(0.0, 0.9), 1.0,
                    curve: Curves.easeOut),
              );
              return SubjectCard(
                  sujet: filtered[index], index: index, animation: animation);
            },
          );
        }
        return const EmptyStateWidget();
      },
    );
  }
}