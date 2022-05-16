import 'dart:isolate';
import 'package:core/network/wraper/resource.dart';

import 'wraper/status.dart';

class DataBoundResource<T> {
  Function createCall = () async => Resource<T>;
  Function fetchFromDatabase = <T>() async => T;
  Function saveCallResult = (T data) => {};

  //TODO: Should fetch (need to fetch from database before create api call)
  DataBoundResource(
      {required this.createCall,
      required this.fetchFromDatabase,
      required this.saveCallResult});

  ReceivePort build() {
    var receivePort = ReceivePort();
    var sendPort = receivePort.sendPort;

    sendPort.send(Resource.loading());

    _fetchFromDatabase(sendPort);
    _crateCall(sendPort);

    return receivePort;
  }

  void _fetchFromDatabase(SendPort sendPort) async {
    var result = await fetchFromDatabase();
    if (result != null) {
      sendPort.send(Resource.success(result));
    }
  }

  void _crateCall(SendPort sendPort) async {
    Resource result = await createCall();
    if (result.status == Status.success) {
      sendPort.send(Resource.success(result.data));
      saveCallResult(result.data);
    }
    if (result.status == Status.error) {
      sendPort.send(Resource.error(result.message ?? ""));
    }
  }
}
