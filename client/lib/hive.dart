import 'dart:io' show Directory;
import 'package:flutter/foundation.dart';
// TODO(FlutterDevelopers): Import modules here
import 'package:com.whitelabel/chat_view/chat_view.dart';
import 'package:com.whitelabel/chat_group/chat_group.dart';
import 'package:com.whitelabel/enrollment/enrollment.dart';
import 'package:com.whitelabel/news/news.dart';
import 'package:com.whitelabel/services/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:repository/repository.dart';

import 'is_browser/vm.dart' if (dart.library.html) 'is_browser/js.dart';

bool _isHiveInitialized = false;

Future<void> initializeHive() async {
  if (_isHiveInitialized) {
    return;
  }
  _isHiveInitialized = true;

  if (kIsWeb) {
    if (!isBrowser) {
      final Directory dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
    }
  } else {
    final Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  // TODO(FlutterDevelopers): Register the ID adapter generated in data.g here
  // with a unique typeID. Do not change the typeID.
  //
  // App module
  Hive
    ..registerAdapter(IdAdapter<User>(), 0)
    ..registerAdapter(IdAdapter<StorageData>(), 1)
    // News Module
    ..registerAdapter(IdAdapter<News>(), 2)
    // conversations module
    ..registerAdapter(IdAdapter<ChatGroup>(), 3)
    // chat_view module
    ..registerAdapter(IdAdapter<AttachmentType>(), 4)
    ..registerAdapter(IdAdapter<ChatModel>(), 5)
    // Campaign
    ..registerAdapter(IdAdapter<Campaign>(), 13)
    // TODO(FlutterDevelopers): Register the adapter generated in data.g here
    // with a unique typeID. Do not change the typeID.
    //
    // App module
    ..registerAdapter(UserAdapter(), 6)
    ..registerAdapter(StorageDataAdapter(), 7)
    // conversations module
    ..registerAdapter(ChatGroupAdapter(), 9)
    // chat_view module
    ..registerAdapter(AttachmentTypeAdapter(), 10)
    ..registerAdapter(ChatModelAdapter(), 11)
    // News Module
    ..registerAdapter(NewsAdapter(), 8)
    // Campaign
    ..registerAdapter(CampaignAdapter(), 12);
}

class IdAdapter<T> extends TypeAdapter<Id<T>> {
  @override
  Id<T> read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      // ignore: sdk_version_ui_as_code
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    final String returnType = fields[0];
    return Id<T>(returnType);
  }

  @override
  void write(BinaryWriter writer, Id<T> obj) {
    writer.writeByte(1);
    writer.writeByte(0);
    writer.write(obj.id);
  }
}
