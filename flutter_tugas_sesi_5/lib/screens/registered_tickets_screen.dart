
import 'package:flutter/material.dart';
import '../models/registration_ticket.dart';

class RegisteredTicketsScreen extends StatelessWidget {
  final List<RegistrationTicket> tickets;
  final ValueChanged<RegistrationTicket> onRemove;

  const RegisteredTicketsScreen({
    super.key,
    required this.tickets,
    required this.onRemove,
  });

  Future<bool> _confirmCancellation(
    BuildContext context,
    RegistrationTicket ticket,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Batalkan pendaftaran?'),
          content: Text(
            'Apakah kamu yakin ingin membatalkan tiket '
            '"${ticket.eventTitle}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Tidak'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Ya, batalkan'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.confirmation_number_outlined,
                size: 72,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              const Text(
                'Belum Ada Tiket',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tiket seminar yang berhasil kamu daftarkan '
                'akan muncul di sini.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];

        return Dismissible(
          key: ValueKey(ticket.id),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete_outline, color: Colors.white),
                SizedBox(height: 4),
                Text(
                  'Batalkan',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          confirmDismiss: (_) {
            return _confirmCancellation(context, ticket);
          },
          onDismissed: (_) {
            onRemove(ticket);

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    'Pendaftaran "${ticket.eventTitle}" dibatalkan.',
                  ),
                ),
              );
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.confirmation_number,
                          color: Colors.indigo,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ticket.eventTitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Kode tiket: ${ticket.id}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _TicketInfoRow(
                    icon: Icons.person_outline,
                    label: 'Nama peserta',
                    value: ticket.participantName,
                  ),
                  const SizedBox(height: 10),
                  _TicketInfoRow(
                    icon: Icons.badge_outlined,
                    label: 'NIM / Identitas',
                    value: ticket.nim,
                  ),
                  const SizedBox(height: 10),
                  _TicketInfoRow(
                    icon: Icons.groups_outlined,
                    label: 'Jenis peserta',
                    value: ticket.participantType,
                  ),
                  const SizedBox(height: 10),
                  _TicketInfoRow(
                    icon: Icons.calendar_month,
                    label: 'Tanggal kehadiran',
                    value: _formatDate(ticket.attendanceDate),
                  ),
                  const SizedBox(height: 10),
                  _TicketInfoRow(
                    icon: Icons.card_giftcard,
                    label: 'Paket kit',
                    value: ticket.withKit ? 'Dengan kit' : 'Tanpa kit',
                  ),
                  const SizedBox(height: 10),
                  _TicketInfoRow(
                    icon: Icons.volunteer_activism,
                    label: 'Donasi',
                    value: 'Rp ${ticket.donation.toInt()}',
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () async {
                        final confirmed =
                            await _confirmCancellation(context, ticket);

                        if (confirmed && context.mounted) {
                          onRemove(ticket);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Pendaftaran "${ticket.eventTitle}" dibatalkan.',
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      label: const Text(
                        'Batalkan tiket',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  Text(
                    'Geser kartu ke kiri untuk membatalkan.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }
}

class _TicketInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _TicketInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 19,
          color: Colors.indigo,
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 112,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
