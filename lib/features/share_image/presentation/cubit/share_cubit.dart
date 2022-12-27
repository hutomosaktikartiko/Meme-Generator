import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'share_state.dart';

class ShareCubit extends Cubit<ShareState> {
  ShareCubit() : super(ShareInitial());
}
