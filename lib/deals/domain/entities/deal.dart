import 'package:equatable/equatable.dart';

class Deal extends Equatable {
  final String id;
  final String companyName;
  final String industry;
  final double investmentRequired;
  final double expectedRoi;
  final String riskLevel;
  final String status;
  final String companyOverview;
  final List<String> financialHighlights;
  final List<double> roiProjections;
  final String riskExplanation;
  final bool isInterested;

  const Deal({
    required this.id,
    required this.companyName,
    required this.industry,
    required this.investmentRequired,
    required this.expectedRoi,
    required this.riskLevel,
    required this.status,
    required this.companyOverview,
    required this.financialHighlights,
    required this.roiProjections,
    required this.riskExplanation,
    this.isInterested = false,
  });

  Deal copyWith({
    String? id,
    String? companyName,
    String? industry,
    double? investmentRequired,
    double? expectedRoi,
    String? riskLevel,
    String? status,
    String? companyOverview,
    List<String>? financialHighlights,
    List<double>? roiProjections,
    String? riskExplanation,
    bool? isInterested,
  }) {
    return Deal(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      industry: industry ?? this.industry,
      investmentRequired: investmentRequired ?? this.investmentRequired,
      expectedRoi: expectedRoi ?? this.expectedRoi,
      riskLevel: riskLevel ?? this.riskLevel,
      status: status ?? this.status,
      companyOverview: companyOverview ?? this.companyOverview,
      financialHighlights: financialHighlights ?? this.financialHighlights,
      roiProjections: roiProjections ?? this.roiProjections,
      riskExplanation: riskExplanation ?? this.riskExplanation,
      isInterested: isInterested ?? this.isInterested,
    );
  }

  @override
  List<Object?> get props => [
        id,
        companyName,
        industry,
        investmentRequired,
        expectedRoi,
        riskLevel,
        status,
        companyOverview,
        financialHighlights,
        roiProjections,
        riskExplanation,
        isInterested,
      ];
}
