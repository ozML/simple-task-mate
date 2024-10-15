import 'package:equatable/equatable.dart';

class Tuple<T0, T1> with EquatableMixin {
  Tuple(this.value0, this.value1);

  final T0 value0;
  final T1 value1;

  Tuple<T0, T1> copyWith({T0? value0, T1? value1}) =>
      Tuple(value0 ?? this.value0, value1 ?? this.value1);

  @override
  List<Object?> get props => [value0, value1];
}
