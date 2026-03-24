import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/deal_list/deal_list_bloc.dart';
import '../widgets/deal_card.dart';
import 'deal_details_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class MyInterestsScreen extends StatelessWidget {
  const MyInterestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Interests')),
      body: BlocBuilder<DealListBloc, DealListState>(
        builder: (context, state) {
          if (state is DealListLoaded) {
            final interestedDeals = state.allDeals.where((deal) => deal.isInterested).toList();

            if (interestedDeals.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: interestedDeals.length,
              itemBuilder: (context, index) {
                final deal = interestedDeals[index];
                return DealCard(
                  deal: deal,
                  onToggleInterest: () {
                    context.read<DealListBloc>().add(ToggleDealInterest(deal.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Removed from interest'),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DealDetailsScreen(deal: deal)),
                    );
                  },
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_outline, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            'You haven\'t expressed interest in any deals yet.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
