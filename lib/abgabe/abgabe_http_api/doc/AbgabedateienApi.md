# abgabe_http_api.api.AbgabedateienApi

## Load the API package
```dart
import 'package:abgabe_http_api/api.dart';
```

All URIs are relative to *https://api.sharezone.net*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addFiles**](AbgabedateienApi.md#addFiles) | **post** /v1/submissions/{submissionId}/files/addList | 


# **addFiles**
> addFiles(submissionId, dateienHinzufuegenCommandDto)



### Example 
```dart
import 'package:abgabe_http_api/api.dart';

var api_instance = new AbgabedateienApi();
var submissionId = submissionId_example; // String | 
var dateienHinzufuegenCommandDto = new DateienHinzufuegenCommandDto(); // DateienHinzufuegenCommandDto | 

try { 
    api_instance.addFiles(submissionId, dateienHinzufuegenCommandDto);
} catch (e) {
    print("Exception when calling AbgabedateienApi->addFiles: $e\n");
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submissionId** | **String**|  | [default to null]
 **dateienHinzufuegenCommandDto** | [**DateienHinzufuegenCommandDto**](DateienHinzufuegenCommandDto.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

