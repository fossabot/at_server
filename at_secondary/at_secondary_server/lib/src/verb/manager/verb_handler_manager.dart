import 'package:at_secondary/src/verb/handler/config_verb_handler.dart';
import 'package:at_secondary/src/verb/handler/cram_verb_handler.dart';
import 'package:at_secondary/src/verb/handler/delete_verb_handler.dart';
import 'package:at_secondary/src/verb/handler/from_verb_handler.dart';
import 'package:at_secondary/src/verb/handler/local_lookup_verb_handler.dart';
import 'package:at_secondary/src/verb/handler/lookup_verb_handler.dart';
import 'package:at_secondary/src/verb/handler/monitor_verb_handler.dart';
import 'package:at_secondary/src/verb/handler/notify_list_verb_handler.dart';
import 'package:at_secondary/src/verb/handler/notify_verb_handler.dart';
import 'package:at_secondary/src/verb/handler/pkam_verb_handler.dart';
import 'package:at_secondary/src/verb/handler/pol_verb_handler.dart';
import 'package:at_secondary/src/verb/handler/proxy_lookup_verb_handler.dart';
import 'package:at_secondary/src/verb/handler/scan_verb_handler.dart';
import 'package:at_secondary/src/verb/handler/stats_verb_handler.dart';
import 'package:at_secondary/src/verb/handler/stream_verb_handler.dart';
import 'package:at_secondary/src/verb/handler/sync_verb_handler.dart';
import 'package:at_secondary/src/verb/handler/update_meta_verb_handler.dart';
import 'package:at_secondary/src/verb/handler/update_verb_handler.dart';
import 'package:at_server_spec/at_verb_spec.dart';
import 'package:at_persistence_secondary_server/src/keystore/secondary_keystore_manager.dart';

/// The default implementation of [VerbHandlerManager].
class DefaultVerbHandlerManager implements VerbHandlerManager {
  static List<VerbHandler> _verbHandlers = _loadVerbHandlers();

  static final DefaultVerbHandlerManager _singleton =
      DefaultVerbHandlerManager._internal();

  DefaultVerbHandlerManager._internal();

  factory DefaultVerbHandlerManager() {
    return _singleton;
  }

  ///Accepts the command in UTF-8 format and returns the appropriate verbHandler.
  ///@param - utf8EncodedCommand: command in UTF-8 format.
  ///@return - VerbHandler: returns the appropriate verb handler.
  @override
  VerbHandler getVerbHandler(String utf8EncodedCommand) {
    for (var handler in _verbHandlers) {
      if (handler.accept(utf8EncodedCommand)) {
        if (handler is MonitorVerbHandler) {
          return handler.clone();
        }
        return handler;
      }
    }
    return null;
  }

  static List<VerbHandler> _loadVerbHandlers() {
    var keyStore = SecondaryKeyStoreManager.getInstance().getKeyStore();
    _verbHandlers = [];
    _verbHandlers.add(FromVerbHandler(keyStore));
    _verbHandlers.add(CramVerbHandler(keyStore));
    _verbHandlers.add(PkamVerbHandler(keyStore));
    _verbHandlers.add(UpdateVerbHandler(keyStore));
    _verbHandlers.add(UpdateMetaVerbHandler(keyStore));
    _verbHandlers.add(LocalLookupVerbHandler(keyStore));
    _verbHandlers.add(ProxyLookupVerbHandler(keyStore));
    _verbHandlers.add(LookupVerbHandler(keyStore));
    _verbHandlers.add(ScanVerbHandler(keyStore));
    _verbHandlers.add(PolVerbHandler(keyStore));
    _verbHandlers.add(DeleteVerbHandler(keyStore));
    _verbHandlers.add(StatsVerbHandler(keyStore));
    _verbHandlers.add(SyncVerbHandler(keyStore));
    _verbHandlers.add(ConfigVerbHandler(keyStore));
    _verbHandlers.add(MonitorVerbHandler(keyStore));
    _verbHandlers.add(StreamVerbHandler(keyStore));
    _verbHandlers.add(NotifyVerbHandler(keyStore));
    _verbHandlers.add(NotifyListVerbHandler(keyStore));

    return _verbHandlers;
  }
}
