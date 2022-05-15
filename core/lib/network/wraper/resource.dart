import 'status.dart';

class Resource<T> {
  String? message;
  Status status;
  T? data;

  Resource({this.message, required this.status, this.data});

  static Resource success<T>(dynamic data) {
    return Resource(status: Status.success, data: data);
  }

  static Resource error<T>(String message) {
    return Resource(message: message, status: Status.error);
  }

  static Resource loading<T>({String? message}) {
    return Resource(message: message, status: Status.loading);
  }
}
