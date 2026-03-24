import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/deal_list/deal_list_bloc.dart';
import '../widgets/deal_card.dart';
import '../widgets/deal_shimmer.dart';
import 'deal_details_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class DealListScreen extends StatefulWidget {
  const DealListScreen({super.key});

  @override
  State<DealListScreen> createState() => _DealListScreenState();
}

class _DealListScreenState extends State<DealListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedRisk = 'All';
  String _selectedIndustry = 'All';
  String _selectedStatus = 'All';
  String _selectedRoi = 'All';

  final List<String> _riskLevels = ['All', 'Low', 'Medium', 'High'];
  final List<String> _industries = ['All', 'FinTech', 'CleanTech', 'Healthcare', 'Logistics', 'AI'];
  final List<String> _statuses = ['All', 'Open', 'Closed'];
  final List<String> _roiOptions = ['All', '10%+', '20%+', '30%+'];

  @override
  void initState() {
    super.initState();
    context.read<DealListBloc>().add(FetchDeals());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            String name = 'Guest';
            String email = '';
            if (state is AuthAuthenticated) {
              name = state.user.name;
              email = state.user.email;
            }
            return Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(name, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  accountEmail: Text(email, style: GoogleFonts.inter()),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: AppColors.secondary,
                    child: Text(name[0].toUpperCase(), style: const TextStyle(fontSize: 24, color: Colors.white)),
                  ),
                  decoration: const BoxDecoration(color: AppColors.primary),
                ),
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text('My Interests'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/my-interests');
                  },
                ),
                const Spacer(),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.riskHigh),
                  title: const Text('Logout', style: TextStyle(color: AppColors.riskHigh)),
                  onTap: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                  },
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
      appBar: AppBar(
        title: const Text('Investment Deals'),
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(
            child: BlocBuilder<DealListBloc, DealListState>(
              builder: (context, state) {
                if (state is DealListLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: DealShimmer(),
                  );
                } else if (state is DealListLoaded) {
                  if (state.filteredDeals.isEmpty) {
                    return _buildEmptyState();
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: state.filteredDeals.length,
                    itemBuilder: (context, index) {
                      final deal = state.filteredDeals[index];
                      return DealCard(
                        deal: deal,
                        onToggleInterest: () {
                          context.read<DealListBloc>().add(ToggleDealInterest(deal.id));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(deal.isInterested ? 'Removed interest' : 'Interest Expressed!'),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DealDetailsScreen(deal: deal),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (state is DealListError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.riskHigh, size: 48),
                        const SizedBox(height: 16),
                        Text(state.message, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<DealListBloc>().add(FetchDeals()),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (value) => _triggerFilter(),
            decoration: InputDecoration(
              hintText: 'Search companies...',
              prefixIcon: const Icon(Icons.search),
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildFilterDropdown(
                label: 'Risk',
                value: _selectedRisk,
                items: _riskLevels,
                onChanged: (val) {
                  setState(() => _selectedRisk = val!);
                  _triggerFilter();
                },
              ),
              const SizedBox(width: 8),
              _buildFilterDropdown(
                label: 'Industry',
                value: _selectedIndustry,
                items: _industries,
                onChanged: (val) {
                  setState(() => _selectedIndustry = val!);
                  _triggerFilter();
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildFilterDropdown(
                label: 'Status',
                value: _selectedStatus,
                items: _statuses,
                onChanged: (val) {
                  setState(() => _selectedStatus = val!);
                  _triggerFilter();
                },
              ),
              const SizedBox(width: 8),
              _buildFilterDropdown(
                label: 'ROI',
                value: _selectedRoi,
                items: _roiOptions,
                onChanged: (val) {
                  setState(() => _selectedRoi = val!);
                  _triggerFilter();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.divider),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            iconSize: 20,
            style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 13),
            onChanged: onChanged,
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _triggerFilter() {
    double? minRoi;
    if (_selectedRoi != 'All') {
      minRoi = double.tryParse(_selectedRoi.replaceAll('%+', ''));
    }

    context.read<DealListBloc>().add(
          FilterDealsRequested(
            searchQuery: _searchController.text,
            riskLevel: _selectedRisk,
            industry: _selectedIndustry,
            status: _selectedStatus,
            minRoi: minRoi,
          ),
        );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            'No matching deals found.',
            style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
