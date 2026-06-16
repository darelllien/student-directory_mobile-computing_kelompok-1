import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/student.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Student> _allStudents = [];
  List<Student> _filteredStudents = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allStudents = getInitialStudents();
    _filteredStudents = List.from(_allStudents);
  }

  void _filterStudents(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStudents = List.from(_allStudents);
      } else {
        _filteredStudents = _allStudents
            .where((student) =>
        // Cek apakah NAMA atau NIM mengandung teks yang dicari
        student.name.toLowerCase().contains(query.toLowerCase()) ||
            student.nim.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Changed title here
        title: const Text('Daftar Mahasiswa'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Updated Search Bar with Shadow
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Subtle shadow color
                    spreadRadius: 1,
                    blurRadius: 8, // How soft the shadow is
                    offset: const Offset(0, 3), // Moves the shadow down slightly
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterStudents,
                decoration: InputDecoration(
                  labelText: 'Cari Nama atau NIM...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none, // Hides the harsh default line so the shadow pops
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),

          // ... The rest of your Expanded GridView goes here exactly as before
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.80, // Sedikit diperkecil karena ketambahan baris NIM
                ),
                itemCount: _filteredStudents.length,
                itemBuilder: (context, index) {
                  final student = _filteredStudents[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          '/profile',
                          arguments: {
                            'student': student,
                            'totalStudents': _allStudents.length,
                          },
                        );

                        if (result == 'delete') {
                          setState(() {
                            _allStudents.removeWhere((s) => s.id == student.id);
                            _filterStudents(_searchController.text);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Mahasiswa berhasil dihapus')),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 4.0,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(student.avatar),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Nama Mahasiswa
                            Text(
                              student.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            // NIM Mahasiswa (Tambahan Baru)
                            Text(
                              student.nim,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF487EFD), // Diwarnai primary agar stand-out
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            // Domisili Mahasiswa
                            Text(
                              student.domisili,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add');

          if (result != null && result is Student) {
            setState(() {
              _allStudents.add(result);
              _filterStudents(_searchController.text);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mahasiswa berhasil ditambahkan')),
            );
          }
        },
        // Warna tombol disamakan dengan primary color
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}