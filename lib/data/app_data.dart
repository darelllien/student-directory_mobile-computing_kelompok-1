import 'dart:math';
import '../models/student.dart';

const List<String> avatarList = [
  'https://i.pravatar.cc/150?img=1',
  'https://i.pravatar.cc/150?img=2',
  'https://i.pravatar.cc/150?img=3',
  'https://i.pravatar.cc/150?img=4',
  'https://i.pravatar.cc/150?img=5',
  'https://i.pravatar.cc/150?img=6',
  'https://i.pravatar.cc/150?img=7',
  'https://i.pravatar.cc/150?img=8',
  'https://i.pravatar.cc/150?img=9',
  'https://i.pravatar.cc/150?img=10',
  'https://i.pravatar.cc/150?img=11',
  'https://i.pravatar.cc/150?img=12',
];

const List<String> domisiliList = [
  'Jakarta Pusat',
  'Jakarta Utara',
  'Jakarta Selatan',
  'Jakarta Barat',
  'Jakarta Timur',
  'Tangerang',
  'Tangerang Selatan',
  'Bekasi',
  'Depok',
  'Bogor',
  'Bandung',
  'Surabaya',
  'Semarang',
  'Yogyakarta',
  'Medan',
  'Makassar',
  'Palembang',
  'Denpasar',
  'Malang',
  'Lainnya',
];

const List<String> prodiList = [
  'Bisnis Digital',
  'Keuangan dan Investasi',
  'Manajemen',
  'Akuntansi',
  'Ilmu Komputer',
  'Sains Data',
  'Sistem Informasi',
  'Artificial Intelligence',
  'Ilmu Komunikasi',
  'Desain Komunikasi Visual',
  'Psikologi',
  'PGSD',
  'Ilmu Hukum',
  'Teknik Elektro',
  'Teknik Industri',
  'Teknik Lingkungan & Rekayasa Berkelanjutan',
];

const Map<String, String> countryCodesMap = {
  '+62': '🇮🇩 +62',
  '+1': '🇺🇸 +1',
  '+60': '🇲🇾 +60',
  '+65': '🇸🇬 +65',
  '+61': '🇦🇺 +61',
  '+91': '🇮🇳 +91',
  '+81': '🇯🇵 +81',
  '+82': '🇰🇷 +82',
  '+86': '🇨🇳 +86',
  '+44': '🇬🇧 +44',
  '+49': '🇩🇪 +49',
  '+33': '🇫🇷 +33',
  '+31': '🇳🇱 +31',
  '+966': '🇸🇦 +966',
  '+971': '🇦🇪 +971',
};

List<Student> getInitialStudents() {
  final List<Map<String, String>> rawData = [
    {
      'nim': '10123001',
      'name': 'Budi Santoso',
      'prodi': 'Sains Data',
      'avatar': 'https://i.pravatar.cc/150?img=1',
      'domisili': 'Jakarta Selatan',
      'phone': '081234567890',
      'email': 'budi@student.cakrawala.ac.id',
    },
    {
      'nim': '10123002',
      'name': 'Sari Dewi',
      'prodi': 'Informatika',
      'avatar': 'https://i.pravatar.cc/150?img=5',
      'domisili': 'Bekasi',
      'phone': '087654321098',
      'email': 'sari@student.cakrawala.ac.id',
    },
    {
      'nim': '10123003',
      'name': 'Ahmad Fauzi',
      'prodi': 'Sains Data',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'domisili': 'Tangerang Selatan',
      'phone': '082198765432',
      'email': 'ahmad@student.cakrawala.ac.id',
    },
    {
      'nim': '10123004',
      'name': 'Rina Kusuma',
      'prodi': 'Sistem Informasi',
      'avatar': 'https://i.pravatar.cc/150?img=11',
      'domisili': 'Tangerang Selatan',
      'phone': '085678901234',
      'email': 'rina@student.cakrawala.ac.id',
    },
    {
      'nim': '10123005',
      'name': 'Dian Pratama',
      'prodi': 'Teknologi Informasi',
      'avatar': 'https://i.pravatar.cc/150?img=8',
      'domisili': 'Bogor',
      'phone': '089876543210',
      'email': 'dian@student.cakrawala.ac.id',
    },
  ];

  return rawData.map((data) {
    return Student(
      id:
          DateTime.now().microsecondsSinceEpoch.toString() +
          Random().nextInt(1000).toString(),
      nim: data['nim'] ?? '',
      name: data['name'] ?? '',
      prodi: data['prodi'] ?? '',
      avatar: data['avatar'] ?? '',
      domisili: data['domisili'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
    );
  }).toList();
}
