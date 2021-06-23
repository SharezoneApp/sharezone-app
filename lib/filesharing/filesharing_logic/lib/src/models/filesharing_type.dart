enum FileSharingType {
  personal,
  course,
}

FileSharingType fileSharingTypeEnumFromString(String data) {
  return FileSharingType.values
      .firstWhere((e) => e.toString() == 'FileSharingType.$data');
}

String fileSharingTypeEnumToString(FileSharingType referenceType) {
  return referenceType.toString().split('.')[1];
}
