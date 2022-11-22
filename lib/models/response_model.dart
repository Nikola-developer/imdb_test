class MyResponseModel {
  int errorCode;
  String errorText;
  dynamic data;

  MyResponseModel({
    this.errorCode = 0,
    this.errorText = '',
    this.data,
  });
}
