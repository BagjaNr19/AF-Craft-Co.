import 'package:flutter/foundation.dart';

import '../core/api_constants.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

enum ProductLoadState { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  // ── State ─────────────────────────────────────────────────────────────────────
  ProductLoadState _state = ProductLoadState.initial;
  List<ProductModel> _products = [];
  List<ProductModel> _featuredProducts = [];
  List<String> _categories = [];
  String? _selectedCategory;
  String _searchQuery = '';
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMore = true;

  // ── Getters ───────────────────────────────────────────────────────────────────
  ProductLoadState get state => _state;
  List<ProductModel> get products => _products;
  List<ProductModel> get featuredProducts => _featuredProducts;
  List<String> get categories => _categories;
  String? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == ProductLoadState.loading;
  bool get hasMore => _hasMore;

  // ── Load Products ─────────────────────────────────────────────────────────────
  Future<void> loadProducts({bool refresh = false}) async {
    if (_state == ProductLoadState.loading) return;
    if (refresh) {
      _currentPage = 1;
      _products = [];
      _hasMore = true;
    }
    if (!_hasMore && !refresh) return;

    _setState(ProductLoadState.loading);
    try {
      final queryParams = <String, String>{
        'page': _currentPage.toString(),
        'limit': '10',
        if (_selectedCategory != null) 'category': _selectedCategory!,
        if (_searchQuery.isNotEmpty) 'search': _searchQuery,
      };

      final response = await ApiService.instance.get(
        ApiConstants.products,
        queryParams: queryParams,
      );

      final List rawList = _extractList(response);
      final newProducts = rawList
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();

      if (refresh) {
        _products = newProducts;
      } else {
        _products = [..._products, ...newProducts];
      }

      _hasMore = newProducts.length >= 10;
      _currentPage++;
      _setState(ProductLoadState.loaded);
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _setState(ProductLoadState.error);
    } catch (e) {
      _errorMessage = 'Gagal memuat produk';
      _setState(ProductLoadState.error);
    }
  }

  // ── Load Categories ───────────────────────────────────────────────────────────
  Future<void> loadCategories() async {
    try {
      final response =
          await ApiService.instance.get(ApiConstants.productCategories);
      final List raw = _extractList(response);
      _categories = raw.map((e) => e.toString()).toList();
      notifyListeners();
    } catch (_) {
      // Non-critical, silently ignore
    }
  }

  // ── Filter by Category ────────────────────────────────────────────────────────
  Future<void> filterByCategory(String? category) async {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    await loadProducts(refresh: true);
  }

  // ── Search ────────────────────────────────────────────────────────────────────
  Future<void> search(String query) async {
    _searchQuery = query;
    await loadProducts(refresh: true);
  }

  void clearSearch() {
    _searchQuery = '';
    loadProducts(refresh: true);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────────
  List _extractList(dynamic response) {
    if (response is List) return response;
    if (response is Map) {
      return response['data'] as List? ??
          response['products'] as List? ??
          response['items'] as List? ??
          [];
    }
    return [];
  }

  void _setState(ProductLoadState state) {
    _state = state;
    notifyListeners();
  }
}
