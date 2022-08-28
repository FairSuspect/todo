import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/src/repos/todo_repository.dart';
import 'package:todo/src/services/local_service/hive.dart';
import 'package:todo/src/services/remote_service/remote_service.dart';

final repositoryManager = Provider(
  (ref) {
    return TodoRepository(
        remoteService: RemoteTodoService(), localService: HiveService());
  },
);
