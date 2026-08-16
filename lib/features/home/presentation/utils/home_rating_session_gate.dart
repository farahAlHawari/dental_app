/// Session-scoped gate for the home pending-rating dialog.
/// Survives HomePage rebuilds; resets only when the app process restarts.
class HomeRatingSessionGate {
  HomeRatingSessionGate._();

  /// Once true, rating prompt will not show again until app is killed & reopened.
  static bool handledThisLaunch = false;
}
