import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Which product the Shop is currently showing. The H5 has the same two-way
/// segmented toggle at the top of the Shop page.
enum SimType { physical, esim }

class SimTypeController extends StateNotifier<SimType> {
  SimTypeController() : super(SimType.esim);

  void set(SimType type) => state = type;
  void toggle() =>
      state = state == SimType.esim ? SimType.physical : SimType.esim;
}

final simTypeControllerProvider =
    StateNotifierProvider<SimTypeController, SimType>((ref) {
  return SimTypeController();
});
