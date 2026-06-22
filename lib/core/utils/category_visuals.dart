import 'package:flutter/material.dart';

class CategoryVisuals {
  final IconData icon;
  final List<Color> gradient;
  final Color primaryColor;

  const CategoryVisuals({
    required this.icon,
    required this.gradient,
    required this.primaryColor,
  });

  static CategoryVisuals get(String category) {
    final clean = category
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ñ', 'n');
    if (clean.contains('imag') || clean == 'images') {
      return const CategoryVisuals(
        icon: Icons.image_rounded,
        gradient: [Color(0xFFEC4899), Color(0xFFF43F5E)],
        primaryColor: Color(0xFFEC4899),
      );
    }
    if (clean.contains('aud') || clean == 'audio') {
      return const CategoryVisuals(
        icon: Icons.music_note_rounded,
        gradient: [Color(0xFF10B981), Color(0xFF059669)],
        primaryColor: Color(0xFF10B981),
      );
    }
    if (clean.contains('vid') || clean == 'video') {
      return const CategoryVisuals(
        icon: Icons.play_circle_fill_rounded,
        gradient: [Color(0xFFF59E0B), Color(0xFFD97706)],
        primaryColor: Color(0xFFF59E0B),
      );
    }
    if (clean.contains('doc') || clean == 'documents') {
      return const CategoryVisuals(
        icon: Icons.description_rounded,
        gradient: [Color(0xFF3B82F6), Color(0xFF2563EB)],
        primaryColor: Color(0xFF3B82F6),
      );
    }
    if (clean.contains('comp') || clean == 'compressed') {
      return const CategoryVisuals(
        icon: Icons.inventory_2_rounded,
        gradient: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
        primaryColor: Color(0xFF8B5CF6),
      );
    }
    if (clean.contains('cod') || clean == 'code') {
      return const CategoryVisuals(
        icon: Icons.code_rounded,
        gradient: [Color(0xFF06B6D4), Color(0xFF0891B2)],
        primaryColor: Color(0xFF06B6D4),
      );
    }
    return const CategoryVisuals(
      icon: Icons.insert_drive_file_rounded,
      gradient: [Color(0xFF64748B), Color(0xFF475569)],
      primaryColor: Color(0xFF64748B),
    );
  }
}
