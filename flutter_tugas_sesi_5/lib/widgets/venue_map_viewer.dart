
import 'package:flutter/material.dart';

class VenueMapViewer extends StatelessWidget {
  const VenueMapViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.map_outlined, color: Colors.indigo),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Denah Venue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Cubit atau gunakan gestur untuk memperbesar dan menggeser denah.',
              style: TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: InteractiveViewer(
              constrained: false,
              boundaryMargin: const EdgeInsets.all(80),
              minScale: 0.5,
              maxScale: 3.0,
              child: SizedBox(
                width: 560,
                height: 560,
                child: Container(
                  color: const Color(0xFFF0F3F8),
                  child: Stack(
                    children: [
                      // Jalan utama
                      Positioned(
                        left: 20,
                        top: 20,
                        right: 20,
                        height: 48,
                        child: _mapArea(
                          'JALAN UTAMA',
                          Colors.grey.shade300,
                          Icons.directions,
                        ),
                      ),

                      // Area parkir
                      Positioned(
                        left: 20,
                        top: 82,
                        width: 150,
                        height: 105,
                        child: _mapArea(
                          'PARKIR',
                          Colors.blue.shade100,
                          Icons.local_parking,
                        ),
                      ),

                      // Pintu masuk
                      Positioned(
                        left: 185,
                        top: 82,
                        width: 170,
                        height: 48,
                        child: _mapArea(
                          'PINTU MASUK',
                          Colors.green.shade100,
                          Icons.login,
                        ),
                      ),

                      // Resepsionis
                      Positioned(
                        left: 185,
                        top: 142,
                        width: 170,
                        height: 45,
                        child: _mapArea(
                          'REGISTRASI',
                          Colors.orange.shade100,
                          Icons.how_to_reg,
                        ),
                      ),

                      // Auditorium
                      Positioned(
                        left: 185,
                        top: 200,
                        width: 350,
                        height: 155,
                        child: _mapArea(
                          'AUDITORIUM',
                          Colors.indigo.shade100,
                          Icons.groups,
                        ),
                      ),

                      // Lab
                      Positioned(
                        left: 20,
                        top: 205,
                        width: 150,
                        height: 95,
                        child: _mapArea(
                          'LAB KOMPUTER',
                          Colors.purple.shade100,
                          Icons.computer,
                        ),
                      ),

                      // Ruang seminar
                      Positioned(
                        left: 20,
                        top: 318,
                        width: 150,
                        height: 100,
                        child: _mapArea(
                          'RUANG SEMINAR A',
                          Colors.teal.shade100,
                          Icons.meeting_room,
                        ),
                      ),

                      // Fasilitas
                      Positioned(
                        left: 185,
                        top: 370,
                        width: 160,
                        height: 65,
                        child: _mapArea(
                          'TOILET',
                          Colors.grey.shade300,
                          Icons.wc,
                        ),
                      ),

                      Positioned(
                        left: 365,
                        top: 370,
                        width: 170,
                        height: 65,
                        child: _mapArea(
                          'MUSHOLA',
                          Colors.green.shade100,
                          Icons.mosque,
                        ),
                      ),

                      Positioned(
                        left: 20,
                        top: 445,
                        right: 25,
                        height: 75,
                        child: _mapArea(
                          'AREA ISTIRAHAT',
                          Colors.amber.shade100,
                          Icons.chair_alt,
                        ),
                      ),

                      const Positioned(
                        left: 24,
                        top: 132,
                        child: Text(
                          'DENAH ILUSTRASI',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Catatan: denah ini merupakan ilustrasi lokasi fasilitas, '
              'bukan peta navigasi bangunan yang sebenarnya.',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapArea(String label, Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 25, color: Colors.black87),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
