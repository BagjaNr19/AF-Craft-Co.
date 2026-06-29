import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_routes.dart';
import '../../core/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/category_chip.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pp = context.read<ProductProvider>();
      pp.loadProducts(refresh: true);
      pp.loadCategories();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<ProductProvider>().loadProducts();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildBody() {
    switch (_selectedTab) {
      case 0:
        return _ShopTab(
          searchController: _searchController,
          scrollController: _scrollController,
        );
      case 1:
        return const _WishlistTab();
      case 2:
        return const _OrdersTab();
      case 3:
        return const ProfileScreen(isEmbedded: true);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppTheme.warmBrown.withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: AppTheme.softRose.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) => setState(() => _selectedTab = index),
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedItemColor: AppTheme.terracotta,
        unselectedItemColor: const Color(0xFFC8B8AC),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.playfairDisplay(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.playfairDisplay(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            activeIcon: Icon(Icons.storefront_rounded),
            label: 'Toko',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline_rounded),
            activeIcon: Icon(Icons.favorite_rounded),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long_rounded),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// ── Shop Tab ──────────────────────────────────────────────────────────────────

class _ShopTab extends StatelessWidget {
  final TextEditingController searchController;
  final ScrollController scrollController;

  const _ShopTab({
    required this.searchController,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>();
    final auth = context.watch<AuthProvider>();

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          backgroundColor: AppTheme.cream,
          elevation: 0,
          scrolledUnderElevation: 0,
          expandedHeight: 130,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: AppTheme.cream,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hai, ${auth.user?.name.split(' ').first ?? 'Kamu'} 👋',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 14,
                          color: AppTheme.warmBrown,
                        ),
                      ),
                      Text(
                        'Temukan Hadiah Estetik',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkBrown,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => AppRoutes.push(context, AppRoutes.profile),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [AppTheme.terracotta, AppTheme.dustyRose],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          auth.user?.initials ?? 'U',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              color: AppTheme.cream,
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
              child: _SearchBar(controller: searchController),
            ),
          ),
        ),

        // Hero Banner
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: _HeroBanner(),
          ),
        ),

        // Categories
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 0, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kategori',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.darkBrown,
                  ),
                ),
                const SizedBox(height: 12),
                _CategoryList(products: products),
              ],
            ),
          ),
        ),

        // Section title
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Produk',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.darkBrown,
                  ),
                ),
                if (products.selectedCategory != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.softRose.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      products.selectedCategory!,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 12,
                        color: AppTheme.darkBrown,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Product Grid
        if (products.isLoading && products.products.isEmpty)
          const SliverFillRemaining(
            child: Center(child: _LoadingDots()),
          )
        else if (products.state == ProductLoadState.error &&
            products.products.isEmpty)
          SliverFillRemaining(
            child: _ErrorState(
              message: products.errorMessage ?? 'Gagal memuat produk',
              onRetry: () =>
                  context.read<ProductProvider>().loadProducts(refresh: true),
            ),
          )
        else if (products.products.isEmpty)
          const SliverFillRemaining(child: _EmptyState())
        else ...[
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < products.products.length) {
                    return ProductCard(product: products.products[index]);
                  }
                  return null;
                },
                childCount: products.products.length,
              ),
            ),
          ),
          if (products.isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: _LoadingDots()),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ],
    );
  }
}

// ── Search Bar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;

  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppTheme.warmWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8DDD0)),
        boxShadow: AppTheme.softShadow,
      ),
      child: TextField(
        controller: controller,
        onChanged: (v) => context.read<ProductProvider>().search(v),
        style: GoogleFonts.playfairDisplay(
          fontSize: 14,
          color: AppTheme.charcoal,
        ),
        decoration: InputDecoration(
          hintText: 'Cari hadiah estetik...',
          hintStyle: GoogleFonts.playfairDisplay(
            fontSize: 14,
            color: AppTheme.warmBrown.withOpacity(0.5),
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppTheme.terracotta,
            size: 20,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

// ── Hero Banner ───────────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A2E1A), Color(0xFF8B5E47)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.mutedGold.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '✨ Koleksi Spesial',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 11,
                      color: AppTheme.champagne,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Hadiah Estetik\nTerbaik Untukmu',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: AppTheme.goldGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Belanja Sekarang →',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.darkBrown,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 24,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.10),
                ),
                child: const Icon(
                  Icons.card_giftcard_rounded,
                  size: 44,
                  color: AppTheme.champagne,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Category List ─────────────────────────────────────────────────────────────

class _CategoryList extends StatelessWidget {
  final ProductProvider products;

  const _CategoryList({required this.products});

  @override
  Widget build(BuildContext context) {
    final cats = ['Semua', ...products.categories];

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = cats[i];
          final isAll = cat == 'Semua';
          final isSelected = isAll
              ? products.selectedCategory == null
              : products.selectedCategory == cat;

          return CategoryChip(
            label: cat,
            isSelected: isSelected,
            onTap: () => context
                .read<ProductProvider>()
                .filterByCategory(isAll ? null : cat),
          );
        },
      ),
    );
  }
}

// ── Wishlist Tab ──────────────────────────────────────────────────────────────

class _WishlistTab extends StatelessWidget {
  const _WishlistTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist'), automaticallyImplyLeading: false),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border_rounded, size: 64,
                color: AppTheme.softRose.withOpacity(0.7)),
            const SizedBox(height: 16),
            Text('Wishlist masih kosong',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.warmBrown,
                )),
            const SizedBox(height: 8),
            Text('Simpan produk favoritmu di sini',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 13,
                  color: AppTheme.warmBrown.withOpacity(0.6),
                )),
          ],
        ),
      ),
    );
  }
}

// ── Orders Tab ────────────────────────────────────────────────────────────────

class _OrdersTab extends StatelessWidget {
  const _OrdersTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesanan Saya'), automaticallyImplyLeading: false),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 64,
                color: AppTheme.softRose.withOpacity(0.7)),
            const SizedBox(height: 16),
            Text('Belum ada pesanan',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.warmBrown,
                )),
            const SizedBox(height: 8),
            Text('Yuk mulai berbelanja!',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 13,
                  color: AppTheme.warmBrown.withOpacity(0.6),
                )),
          ],
        ),
      ),
    );
  }
}

// ── Loading Dots ──────────────────────────────────────────────────────────────

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      )..repeat(reverse: true),
    );
    _animations = List.generate(3, (i) {
      return Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(parent: _controllers[i], curve: Curves.easeInOut),
      );
    });
    Future.delayed(
        const Duration(milliseconds: 200), () {
      if (mounted) _controllers[1].forward();
    });
    Future.delayed(
        const Duration(milliseconds: 400), () {
      if (mounted) _controllers[2].forward();
    });
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (_, __) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Opacity(
              opacity: _animations[i].value,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.terracotta,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ── Error & Empty States ──────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off_rounded,
              size: 64, color: AppTheme.softRose.withOpacity(0.7)),
          const SizedBox(height: 16),
          Text(message,
              style: GoogleFonts.playfairDisplay(
                fontSize: 14,
                color: AppTheme.warmBrown,
              )),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 64, color: AppTheme.softRose.withOpacity(0.7)),
          const SizedBox(height: 16),
          Text('Produk tidak ditemukan',
              style: GoogleFonts.playfairDisplay(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.warmBrown,
              )),
        ],
      ),
    );
  }
}
