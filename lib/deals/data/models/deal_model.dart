import '../../domain/entities/deal.dart';

class DealModel extends Deal {
  const DealModel({
    required super.id,
    required super.companyName,
    required super.industry,
    required super.investmentRequired,
    required super.expectedRoi,
    required super.riskLevel,
    required super.status,
    required super.companyOverview,
    required super.financialHighlights,
    required super.roiProjections,
    required super.riskExplanation,
    super.isInterested = false,
  });

  factory DealModel.fromJson(Map<String, dynamic> json) {
    return DealModel(
      id: json['id'] as String,
      companyName: json['companyName'] as String,
      industry: json['industry'] as String,
      investmentRequired: (json['investmentRequired'] as num).toDouble(),
      expectedRoi: (json['expectedRoi'] as num).toDouble(),
      riskLevel: json['riskLevel'] as String,
      status: json['status'] as String,
      companyOverview: json['companyOverview'] as String,
      financialHighlights: List<String>.from(json['financialHighlights']),
      roiProjections: List<double>.from((json['roiProjections'] as List).map((e) => (e as num).toDouble())),
      riskExplanation: json['riskExplanation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'industry': industry,
      'investmentRequired': investmentRequired,
      'expectedRoi': expectedRoi,
      'riskLevel': riskLevel,
      'status': status,
      'companyOverview': companyOverview,
      'financialHighlights': financialHighlights,
      'roiProjections': roiProjections,
      'riskExplanation': riskExplanation,
    };
  }

  factory DealModel.fromEntity(Deal deal) {
    return DealModel(
      id: deal.id,
      companyName: deal.companyName,
      industry: deal.industry,
      investmentRequired: deal.investmentRequired,
      expectedRoi: deal.expectedRoi,
      riskLevel: deal.riskLevel,
      status: deal.status,
      companyOverview: deal.companyOverview,
      financialHighlights: deal.financialHighlights,
      roiProjections: deal.roiProjections,
      riskExplanation: deal.riskExplanation,
      isInterested: deal.isInterested,
    );
  }
}
