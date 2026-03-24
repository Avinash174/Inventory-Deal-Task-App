import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/deal.dart';
import '../../../domain/repositories/deal_repository.dart';

// Events
abstract class DealListEvent extends Equatable {
  const DealListEvent();
  @override
  List<Object> get props => [];
}

class FetchDeals extends DealListEvent {}
class ToggleDealInterest extends DealListEvent {
  final String dealId;
  const ToggleDealInterest(this.dealId);
}
class FilterDealsRequested extends DealListEvent {
  final String? searchQuery;
  final String? riskLevel;
  final String? industry;
  final String? status;
  final double? minRoi;
  const FilterDealsRequested({this.searchQuery, this.riskLevel, this.industry, this.status, this.minRoi});
}

// States
abstract class DealListState extends Equatable {
  const DealListState();
  @override
  List<Object?> get props => [];
}

class DealListInitial extends DealListState {}
class DealListLoading extends DealListState {}
class DealListLoaded extends DealListState {
  final List<Deal> allDeals;
  final List<Deal> filteredDeals;
  final String? searchQuery;
  final String? riskFilter;
  final String? industryFilter;
  final String? statusFilter;
  final double? minRoiFilter;

  const DealListLoaded({
    required this.allDeals,
    required this.filteredDeals,
    this.searchQuery,
    this.riskFilter,
    this.industryFilter,
    this.statusFilter,
    this.minRoiFilter,
  });

  @override
  List<Object?> get props => [allDeals, filteredDeals, searchQuery, riskFilter, industryFilter, statusFilter, minRoiFilter];
}

class DealListError extends DealListState {
  final String message;
  const DealListError(this.message);
  @override
  List<Object> get props => [message];
}

class DealListBloc extends Bloc<DealListEvent, DealListState> {
  final DealRepository repository;

  DealListBloc({required this.repository}) : super(DealListInitial()) {
    on<FetchDeals>(_onFetchDeals);
    on<ToggleDealInterest>(_onToggleInterest);
    on<FilterDealsRequested>(_onFilterDeals);
  }

  Future<void> _onFetchDeals(FetchDeals event, Emitter<DealListState> emit) async {
    emit(DealListLoading());
    final result = await repository.getDeals();
    result.fold(
      (failure) => emit(DealListError(failure.message)),
      (deals) => emit(DealListLoaded(allDeals: deals, filteredDeals: deals)),
    );
  }

  Future<void> _onToggleInterest(ToggleDealInterest event, Emitter<DealListState> emit) async {
    final currentState = state;
    if (currentState is DealListLoaded) {
      final toggleResult = await repository.toggleInterest(event.dealId);
      
      await toggleResult.fold(
        (failure) async => emit(DealListError(failure.message)),
        (_) async {
          final updatedResult = await repository.getDeals();
          updatedResult.fold(
            (failure) => emit(DealListError(failure.message)),
            (updatedDeals) {
              final List<Deal> filtered = _applyFilters(
                updatedDeals,
                searchQuery: currentState.searchQuery,
                riskLevel: currentState.riskFilter,
                industry: currentState.industryFilter,
                status: currentState.statusFilter,
                minRoi: currentState.minRoiFilter,
              );

              emit(DealListLoaded(
                allDeals: updatedDeals,
                filteredDeals: filtered,
                searchQuery: currentState.searchQuery,
                riskFilter: currentState.riskFilter,
                industryFilter: currentState.industryFilter,
                statusFilter: currentState.statusFilter,
                minRoiFilter: currentState.minRoiFilter,
              ));
            },
          );
        },
      );
    }
  }

  Future<void> _onFilterDeals(FilterDealsRequested event, Emitter<DealListState> emit) async {
    final currentState = state;
    if (currentState is DealListLoaded) {
      final List<Deal> filtered = _applyFilters(
        currentState.allDeals,
        searchQuery: event.searchQuery,
        riskLevel: event.riskLevel,
        industry: event.industry,
        status: event.status,
        minRoi: event.minRoi,
      );

      emit(DealListLoaded(
        allDeals: currentState.allDeals,
        filteredDeals: filtered,
        searchQuery: event.searchQuery,
        riskFilter: event.riskLevel,
        industryFilter: event.industry,
        statusFilter: event.status,
        minRoiFilter: event.minRoi,
      ));
    }
  }

  List<Deal> _applyFilters(
    List<Deal> deals, {
    String? searchQuery,
    String? riskLevel,
    String? industry,
    String? status,
    double? minRoi,
  }) {
    return deals.where((deal) {
      bool matchesSearch = searchQuery == null || 
        deal.companyName.toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesRisk = riskLevel == null || riskLevel == 'All' || deal.riskLevel == riskLevel;
      bool matchesIndustry = industry == null || industry == 'All' || deal.industry == industry;
      bool matchesStatus = status == null || status == 'All' || deal.status.toLowerCase() == status.toLowerCase();
      bool matchesRoi = minRoi == null || deal.expectedRoi >= minRoi;
      
      return matchesSearch && matchesRisk && matchesIndustry && matchesStatus && matchesRoi;
    }).toList();
  }
}
