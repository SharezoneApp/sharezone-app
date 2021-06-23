import 'package:sharezone_widgets/state_sheet.dart';

final stateSheetContentLoading = StateSheetContent(
  body: StateSheetLoadingBody(),
);

final stateSheetContentSuccessfull =
    StateSheetContent.fromSimpleData(SimpleData.successful());

final stateSheetContentFailed =
    StateSheetContent.fromSimpleData(SimpleData.failed());

final stateSheetContentUnknownException =
    StateSheetContent.fromSimpleData(SimpleData.unkonwnException());

final stateSheetContentNoInternetException =
    StateSheetContent.fromSimpleData(SimpleData.noInternet());
