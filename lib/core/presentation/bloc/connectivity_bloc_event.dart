part of 'connectivity_bloc_bloc.dart';

abstract class ConnectivityBlocEvent extends Equatable {
  const ConnectivityBlocEvent();

  @override
  List<Object> get props => [];
}

class LostConnectivityEvent extends ConnectivityBlocEvent {}
