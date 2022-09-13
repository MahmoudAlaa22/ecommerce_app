abstract class Failure {}

class OfflineFailure extends Failure {}

class ServerFailure extends Failure {}

class WeakPasswordFailure extends Failure {}

class EmailAlreadyInUseFailure extends Failure {}

class UserNotFoundFailure extends Failure {}

class WrongPasswordFailure extends Failure {}

class GmailAuthFailure extends Failure {}

class FacebookAuthFailure extends Failure {}

class VerificationBySendEmailFailure extends Failure {}

class UpdatePasswordFailure extends Failure {}
