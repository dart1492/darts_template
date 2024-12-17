import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../index.dart';

class SimpleStateCubitBuilder<T> extends StatelessWidget {
  final SimpleStateCubit<T> cubit;
  final Widget Function(BuildContext, T) builder;
  const SimpleStateCubitBuilder({
    super.key,
    required this.cubit,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: cubit,
      builder: (context, state) {
        return builder(context, state as T);
      },
    );
  }
}
