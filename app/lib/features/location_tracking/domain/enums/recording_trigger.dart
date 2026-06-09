/// What caused a location point to be recorded.
///
/// Values mirror the `location_recording_trigger` Postgres enum.
enum RecordingTrigger {
  /// Normal periodic or motion-based update.
  standard,

  /// iOS significant-change location event.
  significantChange;

  /// Creates a [RecordingTrigger] from its storage string.
  ///
  /// Parameters:
  /// - value: [String] storage value to convert
  ///
  /// Returns:
  /// - [RecordingTrigger] matching [value], or [RecordingTrigger.standard] for
  ///   unrecognised values
  static RecordingTrigger fromString(String value) {
    switch (value) {
      case 'significant_change':
        return RecordingTrigger.significantChange;
      default:
        return RecordingTrigger.standard;
    }
  }

  /// Returns the storage string for this trigger.
  @override
  String toString() {
    switch (this) {
      case RecordingTrigger.standard:
        return 'standard';
      case RecordingTrigger.significantChange:
        return 'significant_change';
    }
  }
}
