import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/src/repos/todo_repository.dart';
import 'package:todo/src/services/local_service/hive.dart';
import 'package:todo/src/services/remote_service/remote_service.dart';

final repositoryManager = Provider(
  (ref) {
    final hiveService = HiveService()..init();
    return TodoRepository(
        remoteService: RemoteTodoService(), localService: hiveService);
  },
);
