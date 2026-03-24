import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../domain/entities/deal.dart';
import '../../domain/repositories/deal_repository.dart';
import '../datasources/deal_local_data_source.dart';
import '../datasources/deal_remote_data_source.dart';

class DealRepositoryImpl implements DealRepository {
  final DealRemoteDataSource remoteDataSource;
  final DealLocalDataSource localDataSource;

  DealRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Deal>>> getDeals() async {
    try {
      final List<Deal> remoteDeals = await remoteDataSource.getDeals();
      final List<String> interestedIds = await localDataSource.getInterestedDealIds();

      final combinedDeals = remoteDeals.map((deal) {
        if (interestedIds.contains(deal.id)) {
          return deal.copyWith(isInterested: true);
        }
        return deal;
      }).toList();
      
      return Right(combinedDeals);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> toggleInterest(String dealId) async {
    try {
      await localDataSource.toggleInterest(dealId);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getInterestedDealIds() async {
    try {
      final ids = await localDataSource.getInterestedDealIds();
      return Right(ids);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
