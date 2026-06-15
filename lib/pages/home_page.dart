import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/student.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 1. Maintain a master list and a filtered list for the search bar
  List<Student> _allStudents = [];
  List<Student> _filteredStudents = [];

  // 2. Controller to read the text inside the search bar
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allStudents = getInitialStudents();
    _filteredStudents = List.from(_allStudents); // Initially, show everyone
  }

  // 3. Search function to filter students by name
  void _filterStudents(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStudents = List.from(_allStudents);
      } else {
        _filteredStudents = _allStudents
            .where((student) =>
            student.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose(); // Always dispose controllers to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Mahasiswa'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
      ),
      // 4. Wrap everything in a Column to stack the Search Bar above the Grid
      body: Column(
        children: [
          // Search Bar UI
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterStudents, // Trigger search on every keystroke
              decoration: InputDecoration(
                labelText: 'Cari Mahasiswa...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          // Grid View wrapped in Expanded so it takes up the remaining screen space
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.85,
                ),
                itemCount: _filteredStudents.length, // Read from the filtered list
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
                            // 5. Delete by ID instead of Index, so it deletes the right person even if searched
                            _allStudents.removeWhere((s) => s.id == student.id);
                            _filterStudents(_searchController.text); // Refresh search results
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
                              width: 80, // Matches the old radius of 40 (40 * 2 = 80)
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  // Uses your primary theme color with a bit of transparency for a clean look
                                  color: Colors.black,
                                  width: 3.0, // Adjust this number to make the border thicker or thinner
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(student.avatar),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              student.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              student.domisili,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
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
              _filterStudents(_searchController.text); // Refresh search results to include new student
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mahasiswa berhasil ditambahkan')),
            );
          }
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        // 6. Replaced Icons.add with Icons.person_add to match your image
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}