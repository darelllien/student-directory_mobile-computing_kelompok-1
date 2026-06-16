import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../data/app_data.dart';
import '../models/student.dart';
import '../theme/app_colors.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _selectedProdi;
  String? _selectedDomisili;
  String? _assignedAvatar;
  bool _isConsentChecked = false;
  String _selectedCountryCode = '+62';
  String? _phoneErrorText;

  @override
  void initState() {
    super.initState();
    _assignedAvatar = avatarList[Random().nextInt(avatarList.length)];
  }

  @override
  void dispose() {
    _nimController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Widget _buildFieldLabel(String label, bool isRequired) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 4),
      child: RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontFamily: 'Roboto',
          ),
          children: isRequired
              ? const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: AppColors.negative,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
              : [],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String cleanPhone = _phoneController.text.trim();
      if (cleanPhone.startsWith('0')) {
        cleanPhone = cleanPhone.substring(1);
      }
      final formattedPhone = '$_selectedCountryCode$cleanPhone';

      final newStudent = Student(
        id:
            DateTime.now().microsecondsSinceEpoch.toString() +
            Random().nextInt(1000).toString(),
        nim: _nimController.text.trim(),
        name: _nameController.text.trim(),
        prodi: _selectedProdi ?? '',
        domisili: _selectedDomisili ?? '',
        email: _emailController.text.trim(),
        phone: formattedPhone,
        avatar: _assignedAvatar ?? '',
      );

      Navigator.pop(context, newStudent);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Validasi gagal! Periksa kembali field bertanda merah (*)',
          ),
          backgroundColor: AppColors.negative,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration buildUnderlineDecoration({
      required String hintText,
      required IconData icon,
    }) {
      return InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppColors.disabledBackground,
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        prefixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 0),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        filled: false,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.iconBackground, width: 1.5),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.secondary, width: 2.0),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.negative, width: 1.5),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.negative, width: 2.0),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Tambah Mahasiswa',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 116,
                    height: 116,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 3),
                    ),
                    child: ClipOval(
                      child: _assignedAvatar != null
                          ? Image.network(
                              _assignedAvatar!,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.iconBackground,
                                  child: const Icon(
                                    Icons.person,
                                    size: 44,
                                    color: AppColors.disabledBackground,
                                  ),
                                );
                              },
                            )
                          : const Icon(Icons.person, size: 44),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildFieldLabel('Nama Lengkap', true),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                  ),
                  decoration: buildUnderlineDecoration(
                    hintText: 'Masukkan nama Lengkap',
                    icon: Icons.person_outline,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama lengkap wajib diisi!';
                    }
                    if (RegExp(r'[0-9]').hasMatch(value)) {
                      return 'Pastikan nama lengkap tidak mengandung angka atau simbol!';
                    }
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('NIM', true),
                          TextFormField(
                            controller: _nimController,
                            keyboardType: TextInputType.number,
                            maxLength: 12,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                            ),
                            decoration: buildUnderlineDecoration(
                              hintText: 'Masukkan NIM',
                              icon: Icons.badge_outlined,
                            ).copyWith(counterText: ""),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'NIM wajib diisi!';
                              }
                              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return 'NIM harus berupa angka!';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Prodi/Jurusan', true),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedProdi,
                            isExpanded: true,
                            items: prodiList.map((prodi) {
                              return DropdownMenuItem(
                                value: prodi,
                                child: Text(
                                  prodi,
                                  style: const TextStyle(fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => _selectedProdi = value),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontFamily: 'Roboto',
                            ),
                            isDense: true,
                            decoration:
                                buildUnderlineDecoration(
                                  hintText: 'Pilih Prodi',
                                  icon: Icons.school_outlined,
                                ).copyWith(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                ),
                            validator: (value) =>
                                value == null ? 'Pilih prodi!' : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _buildFieldLabel('Domisili', true),
                DropdownButtonFormField<String>(
                  initialValue: _selectedDomisili,
                  items: domisiliList.map((domisili) {
                    return DropdownMenuItem(
                      value: domisili.trim(),
                      child: Text(
                        domisili.trim(),
                        style: const TextStyle(fontSize: 15),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _selectedDomisili = value),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontFamily: 'Roboto',
                  ),
                  decoration: buildUnderlineDecoration(
                    hintText: 'Pilih Domisili',
                    icon: Icons.location_on,
                  ),
                  validator: (value) =>
                      value == null ? 'Domisili wajib dipilih!' : null,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Alamat Email', true),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                            ),
                            decoration: buildUnderlineDecoration(
                              hintText: 'Masukkan Email',
                              icon: Icons.email_outlined,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email wajib diisi!';
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value.trim())) {
                                return 'Format email tidak valid!';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Nomer Handphone', true),
                          InputDecorator(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 4,
                              ),
                              filled: false,
                              errorText: _phoneErrorText,
                              errorStyle: const TextStyle(
                                color: AppColors.negative,
                                fontSize: 12,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.iconBackground,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.secondary,
                                  width: 2.0,
                                ),
                              ),
                              errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.negative,
                                  width: 1.5,
                                ),
                              ),
                              focusedErrorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.negative,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedCountryCode,
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      size: 18,
                                      color: AppColors.textPrimary,
                                    ),
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      fontFamily: 'Roboto',
                                    ),
                                    alignment: Alignment.center,
                                    items: countryCodesMap.keys.map((code) {
                                      return DropdownMenuItem(
                                        value: code,
                                        child: Text(
                                          countryCodesMap[code]!,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          _selectedCountryCode = value;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    '|',
                                    style: TextStyle(
                                      color: AppColors.iconBackground,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 13,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 15,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: '812xxxxxxxxx',
                                      hintStyle: TextStyle(
                                        color: AppColors.disabledBackground,
                                        fontSize: 14,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      focusedErrorBorder: InputBorder.none,
                                      counterText: "",
                                      errorStyle: TextStyle(
                                        height: 0,
                                        fontSize: 0,
                                      ),
                                    ),
                                    validator: (value) {
                                      String? errorMessage;
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        errorMessage = 'Nomor HP wajib diisi!';
                                      } else {
                                        String cleanPhone = value.trim();
                                        if (cleanPhone.length < 9 ||
                                            cleanPhone.length > 12) {
                                          errorMessage =
                                              'Nomor HP tidak valid!';
                                        }
                                      }
                                      if (_phoneErrorText != errorMessage) {
                                        setState(() {
                                          _phoneErrorText = errorMessage;
                                        });
                                      }
                                      return errorMessage != null ? "" : null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isConsentChecked
                          ? AppColors.secondary
                          : AppColors.iconBackground,
                      width: _isConsentChecked ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isConsentChecked,
                        activeColor: AppColors.primary,
                        onChanged: (bool? value) {
                          setState(() {
                            _isConsentChecked = value ?? false;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Saya menyatakan bahwa data yang saya masukkan adalah benar.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isConsentChecked ? _submitForm : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.disabledBackground,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Simpan Mahasiswa',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _isConsentChecked
                            ? AppColors.surface
                            : AppColors.disabledText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
