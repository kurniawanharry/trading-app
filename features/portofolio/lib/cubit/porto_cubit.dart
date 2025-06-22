import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'porto_state.dart';

class PortoCubit extends Cubit<PortoState> {
  PortoCubit() : super(PortoInitial());
}
