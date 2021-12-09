import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_block_rit/app_block_rit.dart';

void main() {
  const MethodChannel channel = MethodChannel('app_block_rit');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

//  test('getPlatformVersion', () async {
//    expect(await AppBlockRit.platformVersion, '42');
//  });
}
