//import 'dart:io';
//import 'dart:convert';
//import 'package:crypto/crypto.dart';
//import 'package:at_persistence_secondary_server/at_persistence_secondary_server.dart';
//import 'package:at_persistence_spec/at_persistence_spec.dart';
//import 'package:hive/hive.dart';
//import 'package:test/test.dart';
//
//void main() async {
//  var storageDir = Directory.current.path + '/test/hive';
//  var keyStoreManager;
//  setUp(() async => await setUpFunc(storageDir));
//  group('A group of hive keystore impl tests', () {
//    test('test update', () async {
//      var keyStoreManager = SecondaryKeyStoreManager.getInstance();
//      keyStoreManager.init();
//      var keyStore = keyStoreManager.getKeyStore();
//      var atData = AtData();
//      atData.data = '123';
//      var result = await keyStore.create('phone', atData);
//      expect(result, isNotNull);
//    });
//
//    test('test create and get', () async {
//      var keyStoreManager = SecondaryKeyStoreManager.getInstance();
//      keyStoreManager.init();
//      var keyStore = keyStoreManager.getKeyStore();
//      var atData = AtData();
//      atData.data = '123';
//      await keyStore.create('phone', atData);
//      AtData dataFromHive = await keyStore.get('phone');
//      expect(dataFromHive.data, '123');
//    });
//
//    test('test create, update and get', () async {
//      var keyStoreManager = SecondaryKeyStoreManager.getInstance();
//      keyStoreManager.init();
//      var keyStore = keyStoreManager.getKeyStore();
//      var atData = AtData();
//      atData.data = 'india';
//      await keyStore.create('location', atData);
//      var updateData = AtData();
//      updateData.data = 'united states';
//      await keyStore.put('location', updateData);
//      var dataFromHive = await keyStore.get('location');
//      expect(dataFromHive.data, 'united states');
//    });
//
//    test('test update and get', () async {
//      var keyStoreManager = SecondaryKeyStoreManager.getInstance();
//      keyStoreManager.init();
//      var keyStore = keyStoreManager.getKeyStore();
//      var updateData = AtData();
//      updateData.data = 'alice';
//      var result = await keyStore.put('last_name', updateData);
//      var dataFromHive = await keyStore.get('last_name');
//      expect(dataFromHive.data, 'alice');
//    });
//
//    test('test update and remove', () async {
//      var keyStoreManager = SecondaryKeyStoreManager.getInstance();
//      keyStoreManager.init();
//      var keyStore = keyStoreManager.getKeyStore();
//      var updateData = AtData();
//      updateData.data = 'alice';
//      var result = await keyStore.put('last_name', updateData);
//      await keyStore.remove('last_name');
//      var dataFromHive = await keyStore.get('last_name');
//      expect(dataFromHive, isNull);
//    });
//
//    test('get keys', () async {
//      var keyStoreManager = SecondaryKeyStoreManager.getInstance();
//      keyStoreManager.init();
//      var keyStore = keyStoreManager.getKeyStore();
//      var data_1 = AtData();
//      data_1.data = 'alice';
//      await keyStore.put('last_name', data_1);
//      var data_2 = AtData();
//      data_2.data = 'bob';
//      await keyStore.put('first_name', data_2);
//      var keys = keyStore.getKeys();
//      expect(keys.length, 2);
//    });
//
//    test('test get null key', () {
//      var keyStoreManager = SecondaryKeyStoreManager.getInstance();
//      keyStoreManager.init();
//      var keyStore = keyStoreManager.getKeyStore();
//      expect(() async => await keyStore.get(null),
//          throwsA(predicate((e) => e is AssertionError)));
//    });
//
//    test('test get expired keys - no data', () {
//      var keyStoreManager = SecondaryKeyStoreManager.getInstance();
//      keyStoreManager.init();
//      var keyStore = keyStoreManager.getKeyStore();
//      List<String> expiredKeys = keyStore.getExpiredKeys();
//      expect(expiredKeys.length, 0);
//    });
//
//    test('test hive files deleted - get - box not available', () async {
//      var keyStoreManager = SecondaryKeyStoreManager.getInstance();
//      keyStoreManager.init();
//      await Hive.deleteBoxFromDisk(_getShaForAtsign('@test_user_1'));
//      var keyStore = keyStoreManager.getKeyStore();
//      expect(
//          () async => await keyStore.get('abc'),
//          throwsA(predicate((e) =>
//              e is DataStoreException &&
//              e.message == 'Box has already been closed.')));
//    });
//
//    test('test hive files deleted - put - box not available', () async {
//      var keyStoreManager = SecondaryKeyStoreManager.getInstance();
//      keyStoreManager.init();
//      await Hive.deleteBoxFromDisk(_getShaForAtsign('@test_user_1'));
//      var keyStore = keyStoreManager.getKeyStore();
//      expect(
//          () async => await keyStore.put('abc', null),
//          throwsA(predicate((e) =>
//              e is DataStoreException &&
//              e.message == 'Box has already been closed.')));
//    });
//
//    test('test delete expired keys - no data', () {
//      var keyStoreManager = SecondaryKeyStoreManager.getInstance();
//      keyStoreManager.init();
//      var keyStore = keyStoreManager.getKeyStore();
//      var result = keyStore.deleteExpiredKeys();
//      expect(result, true);
//    });
//
//    test('get keys by regex', () async {
//      var keyStoreManager = SecondaryKeyStoreManager.getInstance();
//      keyStoreManager.init();
//      var keyStore = keyStoreManager.getKeyStore();
//      var data_1 = AtData();
//      data_1.data = 'alice';
//      await keyStore.put('last_name', data_1);
//      var data_2 = AtData();
//      data_2.data = 'bob';
//      await keyStore.put('first_name', data_2);
//      var keys = keyStore.getKeys(regex: '^first');
//      expect(keys.length, 1);
//    });
//// tests commented for coverage. runs fine with pub run test or in IDE
////    test('test expired keys - 1 key', ()  async {
////      var keyStore = keyStoreManager.getKeyStore();
////      AtData updateData = new AtData();
////      updateData.data = 'alice';
////      bool result = await keyStore.put('last_name', updateData,expiry:Duration(seconds: 5));
////      expect(result, true);
////      AtData expiredValue  = await Future.delayed(Duration(minutes: 1,seconds: 30), () => keyStoreManager.getKeyStore().get('last_name'));
////      expect(expiredValue, isNull);
////    }, timeout: Timeout(Duration(minutes: 3)));
////
////    test('test get expired keys - 1 key', ()  async {
////      var keyStore = keyStoreManager.getKeyStore();
////      AtData updateData = new AtData();
////      updateData.data = 'alice';
////      bool result = await keyStore.put('last_name', updateData,expiry:Duration(milliseconds: 10));
////      expect(result, true);
////      List<String> expiredKeys  = await Future.delayed(Duration(seconds: 1), () => keyStoreManager.getKeyStore().getExpiredKeys());
////      print(expiredKeys);
////      expect(expiredKeys[0], 'last_name');
////    }, timeout: Timeout(Duration(minutes: 1)));
////
////    test('test get expired keys - no expired key', ()  async {
////      var keyStore = keyStoreManager.getKeyStore();
////      AtData updateData = new AtData();
////      updateData.data = 'alice';
////      bool result = await keyStore.put('last_name', updateData,expiry:Duration(minutes: 10));
////      expect(result, true);
////      List<String> expiredKeys  = await Future.delayed(Duration(seconds: 30), () => keyStoreManager.getKeyStore().getExpiredKeys());
////      print(expiredKeys);
////      expect(expiredKeys.length, 0);
////    }, timeout: Timeout(Duration(minutes: 1)));
//  });
//  try {
//    tearDown(() async => await tearDownFunc());
//  } on Exception catch (e) {
//    print('error in tear down:${e.toString()}');
//  }
//}
//
//void tearDownFunc() async {
//  await Hive.deleteBoxFromDisk('commit_log_@test_user_1');
//  await Hive.deleteBoxFromDisk(_getShaForAtsign('@test_user_1'));
//}
//
//void setUpFunc(storageDir) async {
//  await AtCommitLog.getInstance().init('commit_log_@test_user_1', storageDir);
//  var persistenceManager = HivePersistenceManager.getInstance();
//  await persistenceManager.init('@test_user_1', storageDir);
////  persistenceManager.scheduleKeyExpireTask(1); //commented this line for coverage test
//}
//
//String _getShaForAtsign(String atsign) {
//  var bytes = utf8.encode(atsign);
//  return sha256.convert(bytes).toString();
//}
