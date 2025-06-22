import 'package:commons_domain/data/models/markets/enum/markets_enum.dart';
import 'package:commons_domain/domain/repository/market_repository.dart';

class StreamMarketStatus {
  final MarketRepository marketRepository;

  StreamMarketStatus(this.marketRepository);

  Stream<ConnectionStatus> call() {
    return marketRepository.getConnectionStatus();
  }
}
