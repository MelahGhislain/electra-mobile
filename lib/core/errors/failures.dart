abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  final String? code;
  final String? details;
  const ServerFailure(super.message, {this.code, this.details});
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super('No internet connection. Please try again.');
}

class UnauthorisedFailure extends Failure {
  const UnauthorisedFailure() : super('Session expired. Please log in again.');
}

class UnknownFailure extends Failure {
  const UnknownFailure() : super('Something went wrong. Please try again.');
}
