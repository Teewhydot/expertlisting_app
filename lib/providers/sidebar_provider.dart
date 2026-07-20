import 'package:flutter/material.dart';
import '../data/api_service.dart';

class SidebarProvider extends ChangeNotifier {
  List<dynamic> _trendingLocations = [];
  List<dynamic> _hotRequests = [];
  List<dynamic> _topCommunities = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<dynamic> get trendingLocations => _trendingLocations;
  List<dynamic> get hotRequests => _hotRequests;
  List<dynamic> get topCommunities => _topCommunities;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  SidebarProvider() {
    fetchSidebarData();
  }

  Future<void> fetchSidebarData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await ApiService.getSidebarData();
      _trendingLocations = data['trending_locations'] ?? [];
      _hotRequests = data['hot_requests'] ?? [];
      _topCommunities = data['top_communities'] ?? [];
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error fetching sidebar data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
