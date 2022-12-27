import '../../core/error/failure.dart';

extension FailureParsing on Failure {
  String toStringMessage() {
    if (this is ServerFailure) {
      return "Server failure";
    } else if (this is NetworkFailure) {
      return "Please check your network connection";
    } else {
      return "Someting wrong, please try again in few minutes";
    }
  }
}