import 'package:sharezone_widgets/src/state_sheet/state_dialog_content.dart';
import 'package:sharezone_widgets/state_sheet.dart';

final stateDialogContentLoading = StateDialogContent(
  title: 'Bitte warten...',
  body: StateDialogLoadingBody(),
);

final stateDialogContentSuccessfull =
    StateDialogContent.fromSimpleData(SimpleData.successful());

final stateDialogContentFailed =
    StateDialogContent.fromSimpleData(SimpleData.failed());

final stateDialogContentUnknownException =
    StateDialogContent.fromSimpleData(SimpleData.unkonwnException());

final stateDialogContentNoInternetException =
    StateDialogContent.fromSimpleData(SimpleData.noInternet());
