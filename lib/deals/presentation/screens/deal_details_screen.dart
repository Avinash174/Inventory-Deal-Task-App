import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/deal.dart';
import '../bloc/deal_list/deal_list_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DealDetailsScreen extends StatelessWidget {
  final Deal deal;

  const DealDetailsScreen({super.key, required this.deal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(deal.companyName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(deal),
            const SizedBox(height: 32),
            _buildSectionTitle('Company Overview'),
            const SizedBox(height: 8),
            Text(
              deal.companyOverview,
              style: GoogleFonts.inter(fontSize: 16, height: 1.5, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('Financial Highlights'),
            const SizedBox(height: 12),
            ...deal.financialHighlights.map((highlight) => _buildHighlightItem(highlight)),
            const SizedBox(height: 32),
            _buildSectionTitle('ROI Projection (5 Year)'),
            const SizedBox(height: 24),
            _buildRoiChart(deal.roiProjections),
            const SizedBox(height: 32),
            _buildSectionTitle('Risk Assessment'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.riskMedium.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.riskMedium.withValues(alpha: 0.2)),
              ),
              child: Text(
                deal.riskExplanation,
                style: GoogleFonts.inter(fontSize: 15, color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<DealListBloc, DealListState>(
            builder: (context, state) {
              final isInterested = (state is DealListLoaded) && 
                state.allDeals.firstWhere((d) => d.id == deal.id).isInterested;

              return ElevatedButton(
                onPressed: () {
                  context.read<DealListBloc>().add(ToggleDealInterest(deal.id));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isInterested ? 'Removed from interests' : 'Interest Expressed Successfully!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isInterested ? Colors.grey[200] : AppColors.primary,
                  foregroundColor: isInterested ? AppColors.textPrimary : Colors.white,
                ),
                child: Text(isInterested ? 'Remove Interest' : 'I\'m Interested'),
              ).animate().scale(delay: 400.ms);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
    );
  }

  Widget _buildHighlightItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.secondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(fontSize: 15, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Deal deal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatusChip(deal.status),
            _buildIndustryChip(deal.industry),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Target ROI',
                  style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
                ),
                Text(
                  '${deal.expectedRoi}%',
                  style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.secondary),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Required',
                  style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
                ),
                Text(
                  '₹${(deal.investmentRequired / 100000).toStringAsFixed(1)}L',
                  style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    final bool isOpen = status.toLowerCase() == 'open';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (isOpen ? AppColors.statusOpen : AppColors.statusClosed).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isOpen ? AppColors.statusOpen : AppColors.statusClosed,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            status.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isOpen ? AppColors.statusOpen : AppColors.statusClosed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndustryChip(String industry) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        industry,
        style: GoogleFonts.inter(
          fontSize: 13,
          color: AppColors.secondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRoiChart(List<double> projections) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: projections
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              isCurved: true,
              color: AppColors.secondary,
              barWidth: 4,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.secondary.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
