import 'package:flutter_bloc/flutter_bloc.dart';

/// Processes events one-by-one (no concurrent handler overlap).
EventTransformer<T> sequential<T>() {
  return (events, mapper) => events.asyncExpand(mapper);
}
