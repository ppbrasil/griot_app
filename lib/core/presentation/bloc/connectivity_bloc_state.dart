part of 'connectivity_bloc_bloc.dart';

abstract class ConnectivityBlocState extends Equatable {
  const ConnectivityBlocState();

  @override
  List<Object> get props => [];
}

class ConnectivityBlocInitial extends ConnectivityBlocState {}

class ConnectivityBlocDisconnected extends ConnectivityBlocState {}
