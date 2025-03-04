part of 'contact_cubit.dart';

@immutable
sealed class ContactState {}

final class ContactInitial extends ContactState {}
class ContactLoading extends ContactState {}

class ContactSuccess extends ContactState {
   
  ContactSuccess();  
}

class ContactFailure extends ContactState {
  final String error;
  ContactFailure(this.error);
}