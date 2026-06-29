import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_theme.dart';
import '../../models/product_model.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/af_button.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _qty = 1;
  int _selectedImageIndex = 0;

  void _increment() => setState(() => _qty++);
  void _decrement() => setState(() {
        if (_qty > 1) _qty--;
      });

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: CustomScrollView(
        slivers: [
          // ── Image SliverAppBar ───────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            backgroundColor: AppTheme.cream,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 16, color: AppTheme.darkBrown),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  product.thumbnail.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl:
                              product.images.isNotEmpty
                                  ? product.images[_selectedImageIndex]
                                  : '',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            color: AppTheme.softRose,
                            child: const Center(
                              child: Icon(Icons.card_giftcard_rounded,
                                  size: 80, color: AppTheme.dustyRose),
                            ),
                          ),
                        )
                      : Container(
                          decoration: const BoxDecoration(
                              gradient: AppTheme.roseGradient),
                          child: const Center(
                            child: Icon(Icons.card_giftcard_rounded,
                                size: 80, color: AppTheme.dustyRose),
                          ),
                        ),
                  // Gradient overlay at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppTheme.cream.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Product Info ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  if (product.category != null)
                    Text(
                      product.category!.toUpperCase(),
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.terracotta,
                        letterSpacing: 1.0,
                      ),
                    ),
                  const SizedBox(height: 8),

                  // Name
                  Text(
                    product.name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.darkBrown,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Rating & Review count
                  Row(
                    children: [
                      if (product.rating != null) ...[
                        const Icon(Icons.star_rounded,
                            size: 16, color: Color(0xFFD4AF7A)),
                        const SizedBox(width: 4),
                        Text(
                          product.rating!.toStringAsFixed(1),
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.darkBrown,
                          ),
                        ),
                        if (product.reviewCount != null) ...[
                          const SizedBox(width: 4),
                          Text(
                            '(${product.reviewCount} ulasan)',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 13,
                              color: AppTheme.warmBrown.withOpacity(0.6),
                            ),
                          ),
                        ],
                        const SizedBox(width: 16),
                      ],
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: product.isInStock
                              ? AppTheme.successGreen.withOpacity(0.15)
                              : AppTheme.errorRed.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          product.isInStock
                              ? 'Stok: ${product.stock}'
                              : 'Habis',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 12,
                            color: product.isInStock
                                ? AppTheme.successGreen
                                : AppTheme.errorRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        CurrencyFormatter.format(product.price),
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.terracotta,
                        ),
                      ),
                      if (product.originalPrice != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          CurrencyFormatter.format(product.originalPrice!),
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.warmBrown.withOpacity(0.5),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Divider
                  Container(
                      height: 1,
                      color: const Color(0xFFF0E8DF)),

                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'Deskripsi Produk',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.description,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 14,
                      color: AppTheme.warmBrown,
                      height: 1.7,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Qty selector
                  Row(
                    children: [
                      Text(
                        'Jumlah:',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkBrown,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFFE8DDD0)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: _decrement,
                              icon: const Icon(Icons.remove_rounded,
                                  size: 18),
                              color: AppTheme.terracotta,
                              constraints: const BoxConstraints(
                                  minWidth: 40, minHeight: 40),
                            ),
                            Text(
                              '$_qty',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.darkBrown,
                              ),
                            ),
                            IconButton(
                              onPressed: _increment,
                              icon: const Icon(Icons.add_rounded, size: 18),
                              color: AppTheme.terracotta,
                              constraints: const BoxConstraints(
                                  minWidth: 40, minHeight: 40),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Add to cart button
                  AfButton(
                    label: 'Tambah ke Keranjang',
                    onPressed: product.isInStock ? () {} : null,
                    isFullWidth: true,
                    icon: Icons.shopping_bag_outlined,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
