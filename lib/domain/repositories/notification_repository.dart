import 'package:fpdart/fpdart.dart';

import '../../core/error/failure.dart';
import '../entities/app_notification.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<AppNotification>>> list();
}
