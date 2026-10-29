
import 'package:flutter/material.dart';

import '../models/event_item.dart';
import '../models/registration_ticket.dart';

class EventRegistrationScreen extends StatefulWidget {
  final EventItem event;

  const EventRegistrationScreen({
    super.key,
    required this.event,
  });

  @override
  State<EventRegistrationScreen> createState() =>
      _EventRegistrationScreenState();
}

class _EventRegistrationScreenState
    extends State<EventRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();

  String? _participantType;
  DateTime? _attendanceDate;

  bool _withKit = false;
  bool _agreedToTerms = false;
  bool _isLoading = false;

  double _donation = 0;

  final List<String> _participantTypes = [
    'Mahasiswa',
    'Dosen',
    'Umum',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  Future<void> _selectAttendanceDate() async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _attendanceDate ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 1, 12, 31),
      helpText: 'Pilih tanggal kehadiran',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );

    if (selectedDate != null && mounted) {
      setState(() {
        _attendanceDate = selectedDate;
      });
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  String _formatRupiah(double amount) {
    return 'Rp ${amount.toInt()}';
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Periksa kembali data yang wajib diisi.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_attendanceDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih tanggal kehadiran.'),
        ),
      );
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Kamu harus menyetujui syarat dan ketentuan.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulasi proses pengiriman data pendaftaran.
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final ticket = RegistrationTicket(
      id: 'TKT-${DateTime.now().microsecondsSinceEpoch}',
      eventId: widget.event.id,
      eventTitle: widget.event.title,
      participantName: _nameController.text.trim(),
      nim: _nimController.text.trim(),
      email: _emailController.text.trim(),
      whatsapp: _whatsappController.text.trim(),
      participantType: _participantType!,
      attendanceDate: _attendanceDate!,
      withKit: _withKit,
      donation: _donation,
    );

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pendaftaran berhasil dibuat!'),
        backgroundColor: Colors.green,
      ),
    );

    // Beri waktu agar SnackBar sempat terlihat.
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    // Mengirim tiket kembali ke halaman sebelumnya.
    Navigator.pop(context, ticket);
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Pendaftaran'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Informasi seminar
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.event_available,
                        size: 36,
                        color: Colors.indigo,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Kategori: ${event.category}'),
                      Text('Tanggal acara: ${event.date}'),
                      Text('Lokasi: ${event.location}'),
                      const SizedBox(height: 8),
                      Text(
                        'Harga tiket: ${_formatRupiah(event.price.toDouble())}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Data Peserta',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Nama peserta
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nama lengkap',
                  prefixIcon: Icon(Icons.person_outline),
                  hintText: 'Masukkan nama lengkap',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama lengkap wajib diisi.';
                  }

                  if (value.trim().length < 3) {
                    return 'Nama minimal 3 karakter.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // NIM
              TextFormField(
                controller: _nimController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'NIM / Nomor identitas',
                  prefixIcon: Icon(Icons.badge_outlined),
                  hintText: 'Masukkan NIM atau nomor identitas',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'NIM atau nomor identitas wajib diisi.';
                  }

                  if (value.trim().length < 3) {
                    return 'Nomor identitas minimal 3 karakter.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  hintText: 'nama@email.com',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email wajib diisi.';
                  }

                  final emailPattern =
                      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                  if (!emailPattern.hasMatch(value.trim())) {
                    return 'Format email tidak valid.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // WhatsApp
              TextFormField(
                controller: _whatsappController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor WhatsApp',
                  prefixIcon: Icon(Icons.phone_android),
                  hintText: 'Contoh: 081234567890',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nomor WhatsApp wajib diisi.';
                  }

                  final phone = value.trim();

                  if (!RegExp(r'^\+?[0-9]{9,15}$')
                      .hasMatch(phone)) {
                    return 'Masukkan nomor telepon yang valid.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Jenis peserta
              DropdownButtonFormField<String>(
                value: _participantType,
                decoration: const InputDecoration(
                  labelText: 'Jenis peserta',
                  prefixIcon: Icon(Icons.groups_outlined),
                ),
                items: _participantTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _participantType = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Silakan pilih jenis peserta.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              const Text(
                'Detail Kehadiran',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Tanggal kehadiran
              FormField<DateTime>(
                validator: (_) {
                  if (_attendanceDate == null) {
                    return 'Tanggal kehadiran wajib dipilih.';
                  }

                  return null;
                },
                builder: (field) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _isLoading
                            ? null
                            : _selectAttendanceDate,
                        icon: const Icon(Icons.calendar_month),
                        label: Text(
                          _attendanceDate == null
                              ? 'Pilih tanggal kehadiran'
                              : 'Tanggal: ${_formatDate(_attendanceDate!)}',
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(
                            double.infinity,
                            50,
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      if (field.hasError)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 12,
                            top: 6,
                          ),
                          child: Text(
                            field.errorText!,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 16),

              // Paket kit
              Card(
                child: CheckboxListTile(
                  value: _withKit,
                  onChanged: _isLoading
                      ? null
                      : (value) {
                          setState(() {
                            _withKit = value ?? false;
                          });
                        },
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Paket kit peserta'),
                  subtitle: const Text(
                    'Termasuk seminar kit jika tersedia.',
                  ),
                  secondary: const Icon(Icons.card_giftcard),
                ),
              ),

              const SizedBox(height: 16),

              // Donasi
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Donasi sukarela',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Atur nominal donasi jika ingin berkontribusi.',
                      ),
                      Slider(
                        value: _donation,
                        min: 0,
                        max: 100000,
                        divisions: 20,
                        label: _formatRupiah(_donation),
                        onChanged: _isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  _donation = value;
                                });
                              },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _formatRupiah(_donation),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Persetujuan syarat
              Card(
                child: CheckboxListTile(
                  value: _agreedToTerms,
                  onChanged: _isLoading
                      ? null
                      : (value) {
                          setState(() {
                            _agreedToTerms = value ?? false;
                          });
                        },
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text(
                    'Saya menyetujui syarat dan ketentuan pendaftaran.',
                  ),
                  subtitle: const Text(
                    'Pastikan data yang diberikan sudah benar.',
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Tombol submit
              FilledButton(
                onPressed: _isLoading ? null : _submitForm,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(
                    double.infinity,
                    52,
                  ),
                ),
                child: _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Memproses pendaftaran...'),
                        ],
                      )
                    : const Text('Daftar Sekarang'),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
