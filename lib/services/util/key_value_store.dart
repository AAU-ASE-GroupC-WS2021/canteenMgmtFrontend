class KeyValueStore {
  Map<String, String> _store = {};

  /// Get a stored value.
  ///
  /// Returns null if there is no value for the given key.
  String? get(String key) => _store[key];

  /// Store a value.
  ///
  /// If the value is null, the key will be deleted.
  void set(String key, String? value) =>
      value == null ? delete(key) : _store[key] = value;

  /// Delete a value.
  void delete(String key) => _store.remove(key);

  /// Delete all values
  void reset() => _store = {};
}
