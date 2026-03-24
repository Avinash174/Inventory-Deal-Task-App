import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/deal_model.dart';

abstract class DealRemoteDataSource {
  Future<List<DealModel>> getDeals();
}

class DealRemoteDataSourceImpl implements DealRemoteDataSource {
  @override
  Future<List<DealModel>> getDeals() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1500));
    
    final String response = await rootBundle.loadString('assets/json/deals.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => DealModel.fromJson(json)).toList();
  }
}
