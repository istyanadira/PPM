
import 'package:flutter/material.dart';

import '../data/sample_events.dart';
import '../models/event_item.dart';
import '../models/registration_ticket.dart';
import '../widgets/event_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/venue_map_viewer.dart';
import 'event_registration_screen.dart';
import 'registered_tickets_screen.dart';

class HomeEventsScreen extends StatefulWidget {
  const HomeEventsScreen({super.key});

  @override
  State<HomeEventsScreen> createState() => _HomeEventsScreenState();
}

class _HomeEventsScreenState extends State<HomeEventsScreen> {
  int _selectedIndex = 0;
  String _selectedCategory = 'Semua';

  final List<RegistrationTicket> _tickets = [];

  final List<String> _categories = [
    'Semua',
    'AI',
    'Mobile',
    'IoT',
    'Cybersecurity',
  ];

  List<EventItem> get _filteredEvents {
    if (_selectedCategory == 'Semua') {
      return sampleEvents;
    }

    return sampleEvents
        .where((event) => event.category == _selectedCategory)
        .toList();
  }

  Future<void> _openFilter() async {
    final category = await FilterBottomSheet.show(
      context,
      selectedCategory: _selectedCategory,
      categories: _categories,
    );

    if (!mounted || category == null) return;

    setState(() {
      _selectedCategory = category;
    });
  }

  Future<void> _openRegistration(EventItem event) async {
    final ticket = await Navigator.push<RegistrationTicket>(
      context,
      MaterialPageRoute(
        builder: (context) => EventRegistrationScreen(event: event),
      ),
    );

    if (!mounted || ticket == null) return;

    setState(() {
      _tickets.add(ticket);
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Tiket "${ticket.eventTitle}" berhasil ditambahkan.'),
        ),
      );
  }

  void _removeTicket(RegistrationTicket ticket) {
    setState(() {
      _tickets.removeWhere((item) => item.id == ticket.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildSeminarPage(),
      _buildGalleryPage(),
      RegisteredTicketsScreen(
        tickets: _tickets,
        onRemove: _removeTicket,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('NusaEvent Hub'),
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              tooltip: 'Filter kategori',
              onPressed: _openFilter,
              icon: const Icon(Icons.filter_list),
            ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.event_note),
            label: 'Seminar',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_library),
            label: 'Galeri & Denah',
          ),
          NavigationDestination(
            icon: Icon(Icons.confirmation_number),
            label: 'Tiket Saya',
          ),
        ],
      ),
    );
  }

  Widget _buildSeminarPage() {
    final events = _filteredEvents;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Temukan Seminar',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _openFilter,
                icon: const Icon(Icons.tune),
                label: const Text('Filter'),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Pilih acara yang ingin kamu ikuti.'),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 42,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = _categories[index];

              return ChoiceChip(
                label: Text(category),
                selected: _selectedCategory == category,
                onSelected: (_) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: events.isEmpty
              ? const Center(
                  child: Text('Tidak ada seminar dalam kategori ini.'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];

                    return EventCard(
                      event: event,
                      onTap: () => _openRegistration(event),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildGalleryPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Galeri Seminar',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 230,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
            ),
            itemCount: sampleEvents.length,
            itemBuilder: (context, index) {
              final event = sampleEvents[index];

              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _openRegistration(event),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          event.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Container(
                              color: Colors.indigo.shade100,
                              width: double.infinity,
                              child: const Icon(
                                Icons.image_not_supported_outlined,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              event.category,
                              style: const TextStyle(
                                color: Colors.indigo,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Text(
            'Denah Venue',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Expanded(
          child: VenueMapViewer(),
        ),
      ],
    );
  }
}
