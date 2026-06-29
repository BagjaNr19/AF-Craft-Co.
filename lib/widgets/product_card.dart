import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_theme.dart';
import '../models/product_model.dart';
import '../utils/currency_formatter.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.softShadow,
          border: Border.all(color: const Color(0xFFF0E8DF), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Product Image ──────────────────────────────────────────────
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20)),
                    child: product.thumbnail.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: product.thumbnail,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => _PlaceholderImage(),
                            errorWidget: (_, __, ___) => _PlaceholderImage(),
                          )
                        : _PlaceholderImage(),
                  ),
                  if (product.hasDiscount)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.terracotta,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${product.discountPercent}%',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        product.isWishlisted
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 16,
                        color: product.isWishlisted
                            ? AppTheme.terracotta
                            : AppTheme.warmBrown.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Product Info ───────────────────────────────────────────────
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.category != null) ...[
                      Text(
                        product.category!.toUpperCase(),
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.terracotta,
                          letterSpacing: 0.8,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      product.name,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkBrown,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    if (product.rating != null) ...[
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 12, color: Color(0xFFD4AF7A)),
                          const SizedBox(width: 3),
                          Text(
                            product.rating!.toStringAsFixed(1),
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 11,
                              color: AppTheme.warmBrown.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      CurrencyFormatter.format(product.price),
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.terracotta,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(gradient: AppTheme.roseGradient),
      child: const Center(
        child: Icon(Icons.card_giftcard_rounded,
            size: 40, color: AppTheme.dustyRose),
      ),
    );
  }
}
