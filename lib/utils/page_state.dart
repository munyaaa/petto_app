enum StateType {
  loading,
  success,
  error,
}

class PageState<T> {
  StateType _state = StateType.loading;
  late T _data;
  late String _errorMessage;

  PageState.loading() {
    _state = StateType.loading;
  }

  PageState.success(T data) {
    _data = data;
    _state = StateType.success;
  }

  PageState.error(String errorMessage) {
    _errorMessage = errorMessage;
    _state = StateType.error;
  }

  StateType getState() => _state;

  String getError() {
    assert(_state == StateType.error);
    return _errorMessage;
  }

  T getData() {
    assert(_state == StateType.success);
    return _data;
  }
}
