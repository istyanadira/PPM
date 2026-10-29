
import '../models/event_item.dart';

const List<EventItem> sampleEvents = [
  EventItem(
    id: 'EV001',
    title: 'AI for Future',
    description: 'Mengenal penerapan Artificial Intelligence.',
    category: 'AI',
    date: '15 November 2026',
    location: 'Auditorium Kampus',
    price: 50000,
    quota: 100,
    imageUrl: 'https://picsum.photos/seed/ai/400/600',
  ),
  EventItem(
    id: 'EV002',
    title: 'Flutter Mobile Workshop',
    description: 'Belajar membangun aplikasi mobile dengan Flutter.',
    category: 'Mobile',
    date: '18 November 2026',
    location: 'Lab Komputer 1',
    price: 35000,
    quota: 50,
    imageUrl: 'https://picsum.photos/seed/mobile/400/600',
  ),
  EventItem(
    id: 'EV003',
    title: 'IoT Smart Campus',
    description: 'Eksplorasi Internet of Things untuk kampus pintar.',
    category: 'IoT',
    date: '20 November 2026',
    location: 'Ruang Seminar A',
    price: 40000,
    quota: 75,
    imageUrl: 'https://picsum.photos/seed/iot/400/600',
  ),
  EventItem(
    id: 'EV004',
    title: 'Cybersecurity Essentials',
    description: 'Dasar keamanan jaringan dan perlindungan data.',
    category: 'Cybersecurity',
    date: '22 November 2026',
    location: 'Auditorium Kampus',
    price: 45000,
    quota: 60,
    imageUrl: 'https://picsum.photos/seed/cyber/400/600',
  ),
];
