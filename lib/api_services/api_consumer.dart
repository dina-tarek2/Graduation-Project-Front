
abstract class ApiConsumer {
 Future<dynamic> get(
    String path ,{
    Object? data ,
    Map<String,dynamic> quiryParameters,
});
 Future<dynamic> post(
    String path ,{
    dynamic data ,
    Map<String,dynamic> quiryParameters,
    bool isFromData = false,
});
 Future<dynamic> patch(
    String path ,{
    dynamic data ,
    Map<String,dynamic> quiryParameters,
        bool isFromData = false,
}
  );
 Future<dynamic> delete(
    String path ,{
    dynamic data ,
    Map<String,dynamic> quiryParameters,
    bool isFromData = false,
}
  );

}