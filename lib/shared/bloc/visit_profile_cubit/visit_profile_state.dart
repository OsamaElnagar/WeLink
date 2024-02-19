part of 'visit_profile_cubit.dart';

@immutable
abstract class VisitProfileStates {}

class VisitProfileInitial extends VisitProfileStates {}


class SearchForUserLoadingState extends VisitProfileStates {}

class SearchForUserSuccessState extends VisitProfileStates {}

class SearchForUserErrorState extends VisitProfileStates {
  final String error;

  SearchForUserErrorState(this.error);
}

class GetVisitedUserLinksLoadingState extends VisitProfileStates {}

class GetVisitedUserLinksSuccessState extends VisitProfileStates {}

class GetVisitedUserPostsLoadingState extends VisitProfileStates {}

class GetVisitedUserPostsSuccessState extends VisitProfileStates {}

class GetVisitedUserPostsErrorState extends VisitProfileStates {
  final String error;

  GetVisitedUserPostsErrorState(this.error);
}


