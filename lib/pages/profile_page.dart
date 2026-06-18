import 'package:flutter/material.dart';
import '../models/student.dart';
import '../theme/app_colors.dart';
import '../constants/app_strings.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final Student? student = args?['student'] as Student?;
    final int totalStudents = args?['totalStudents'] as int? ?? 0;

    final bool canDelete = totalStudents > 3;

    if (student == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppStrings.profileTitle)),
        body: const Center(child: Text(AppStrings.errorNotFound)),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          AppStrings.profileTitle,
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ),
      ),
      body: Stack(
        children: [
          const _ProfileHeaderBackground(),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                _ProfileAvatar(student: student),
                const SizedBox(height: 12),
                Text(
                  student.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.surface,
                  ),
                ),
                const SizedBox(height: 12),
                _StudentInfoCard(student: student),
                const SizedBox(height: 18),
                _DeleteAccountButton(canDelete: canDelete),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeaderBackground extends StatelessWidget {
  const _ProfileHeaderBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 220,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final Student student;
  const _ProfileAvatar({required this.student});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: 'avatar_${student.id}',
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
            image: DecorationImage(
              image: NetworkImage(student.avatar),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class _StudentInfoCard extends StatelessWidget {
  final Student student;
  const _StudentInfoCard({required this.student});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary, width: 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _InfoRow(
              icon: Icons.person_outline,
              label: AppStrings.labelFullName,
              value: student.name,
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.badge_outlined,
              label: AppStrings.labelId,
              value: student.nim,
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.school_outlined,
              label: AppStrings.labelMajor,
              value: student.prodi,
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: AppStrings.labelDomicile,
              value: student.domisili,
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.phone_outlined,
              label: AppStrings.labelPhone,
              value: student.phone,
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.email_outlined,
              label: AppStrings.labelEmail,
              value: student.email,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary, width: 1),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DeleteAccountButton extends StatelessWidget {
  final bool canDelete;
  const _DeleteAccountButton({required this.canDelete});

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.negative, width: 1.5),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      size: 40,
                      color: AppColors.negative,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  AppStrings.dialogDeleteConfirm,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.negative,
                          foregroundColor: AppColors.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.delete, size: 18),
                        label: const Text(
                          AppStrings.btnDelete,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.pop(context, true);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          foregroundColor: AppColors.textPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text(
                          AppStrings.btnCancel,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: canDelete ? () => _showDeleteDialog(context) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.negative,
            foregroundColor: AppColors.surface,
            disabledBackgroundColor: AppColors.disabledBackground,
            disabledForegroundColor: AppColors.disabledText,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.delete_outline),
          label: const Text(
            AppStrings.btnDeleteAccount,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}