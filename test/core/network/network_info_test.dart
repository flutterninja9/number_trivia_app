import 'package:clean_architecture_tdd/core/network/network_info.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfoImpl;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });
  group('checkNetworkConnection', () {
    test(
        'should forward the call to DataConnectionChecker.hasConnection() on true condition',
        () async {
      // arrange
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) async => true);
      //act
      final result = await networkInfoImpl.isConnected;
      //assert
      verify(mockDataConnectionChecker.hasConnection);
      expect(result, true);
    });
    test(
        'should forward the call to DataConnectionChecker.hasConnection() on false condition',
        () async {
      // arrange
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) async => false);
      //act
      final result = await networkInfoImpl.isConnected;
      //assert
      verify(mockDataConnectionChecker.hasConnection);
      expect(result, false);
    });
  });
}
