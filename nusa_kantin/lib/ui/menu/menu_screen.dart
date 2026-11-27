
import 'package:flutter/material.dart';

import '../../domain/models/menu_item.dart';
import '../core/window_size.dart';
import 'menu_view_model.dart';
import 'widgets/menu_list.dart';
import 'widgets/menu_grid.dart';
import 'widgets/menu_detail.dart';

class MenuScreen extends StatelessWidget {
  final MenuViewModel viewModel;

  const MenuScreen({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, child) {
        final ukuran = WindowSizeHelper.getWindowSize(context);

        final compact = ukuran == WindowSize.compact;
        final expanded = ukuran == WindowSize.expanded;

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, Selamat Datang!',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Menu Kantin',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Temukan makanan dan minuman favoritmu.',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: viewModel.daftarKategori.map((kategori) {
                        final aktif =
                            viewModel.kategoriAktif == kategori;

                        return ChoiceChip(
                          label: Text(kategori),
                          selected: aktif,
                          onSelected: (_) {
                            viewModel.pilihKategori(kategori);
                          },
                          selectedColor: Colors.green.shade100,
                          labelStyle: TextStyle(
                            color: aktif
                                ? Colors.green.shade900
                                : Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: compact
                    ? MenuList(
                        menus: viewModel.menuTerfilter,
                        menuTerpilih: viewModel.menuTerpilih,
                        onMenuTap: viewModel.pilihMenu,
                        onTambah: (menu) {
                          viewModel.tambahPesanan(menu);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${menu.nama} ditambahkan ke pesanan',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      )
                    : expanded
                        ? Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: MenuGrid(
                                  menus: viewModel.menuTerfilter,
                                  menuTerpilih: viewModel.menuTerpilih,
                                  onMenuTap: viewModel.pilihMenu,
                                  onTambah: viewModel.tambahPesanan,
                                ),
                              ),
                              const VerticalDivider(width: 1),
                              Expanded(
                                flex: 2,
                                child: MenuDetail(
                                  menu: viewModel.menuTerpilih,
                                  onTambah: viewModel.menuTerpilih == null
                                      ? null
                                      : () => viewModel.tambahPesanan(
                                            viewModel.menuTerpilih!,
                                          ),
                                ),
                              ),
                            ],
                          )
                        : MenuGrid(
                            menus: viewModel.menuTerfilter,
                            menuTerpilih: viewModel.menuTerpilih,
                            onMenuTap: (MenuItem menu) {
                              viewModel.pilihMenu(menu);

                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return SizedBox(
                                    height: MediaQuery.sizeOf(context).height *
                                        0.65,
                                    child: MenuDetail(
                                      menu: menu,
                                      onTambah: () {
                                        viewModel.tambahPesanan(menu);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            onTambah: viewModel.tambahPesanan,
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}
