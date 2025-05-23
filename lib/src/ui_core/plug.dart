class Plug<T> {
  Function callback = () async {};
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  then(Function() f) {
    _isConnected = true;
    callback = f;
  }

  take(Function(T) f) {
    _isConnected = true;
    callback = f;
  }

  call() async {
    if (_isConnected) {
      await callback();
    }
  }

  send(T arg) async {
    if (_isConnected) {
      await callback(arg);
    }
  }
}
