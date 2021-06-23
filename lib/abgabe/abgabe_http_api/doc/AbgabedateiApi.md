# abgabe_http_api.api.AbgabedateiApi

## Load the API package
```dart
import 'package:abgabe_http_api/api.dart';
```

All URIs are relative to *https://api.sharezone.net*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addFile**](AbgabedateiApi.md#addFile) | **post** /v1/submissions/{submissionId}/files | 
[**deleteFile**](AbgabedateiApi.md#deleteFile) | **delete** /v1/submissions/{submissionId}/files/{fileId} | 
[**renameFile**](AbgabedateiApi.md#renameFile) | **post** /v1/submissions/{submissionId}/files/{fileId} | 


# **addFile**
> addFile(submissionId, dateiHinzufuegenCommandDto)



### Example 
```dart
import 'package:abgabe_http_api/api.dart';

var api_instance = new AbgabedateiApi();
var submissionId = submissionId_example; // String | 
var dateiHinzufuegenCommandDto = new DateiHinzufuegenCommandDto(); // DateiHinzufuegenCommandDto | 

try { 
    api_instance.addFile(submissionId, dateiHinzufuegenCommandDto);
} catch (e) {
    print("Exception when calling AbgabedateiApi->addFile: $e\n");
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submissionId** | **String**|  | [default to null]
 **dateiHinzufuegenCommandDto** | [**DateiHinzufuegenCommandDto**](DateiHinzufuegenCommandDto.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteFile**
> deleteFile(submissionId, fileId)



### Example 
```dart
import 'package:abgabe_http_api/api.dart';

var api_instance = new AbgabedateiApi();
var submissionId = submissionId_example; // String | 
var fileId = fileId_example; // String | 

try { 
    api_instance.deleteFile(submissionId, fileId);
} catch (e) {
    print("Exception when calling AbgabedateiApi->deleteFile: $e\n");
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submissionId** | **String**|  | [default to null]
 **fileId** | **String**|  | [default to null]

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **renameFile**
> renameFile(submissionId, fileId, dateinameDto)



### Example 
```dart
import 'package:abgabe_http_api/api.dart';

var api_instance = new AbgabedateiApi();
var submissionId = submissionId_example; // String | 
var fileId = fileId_example; // String | 
var dateinameDto = new DateinameDto(); // DateinameDto | 

try { 
    api_instance.renameFile(submissionId, fileId, dateinameDto);
} catch (e) {
    print("Exception when calling AbgabedateiApi->renameFile: $e\n");
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submissionId** | **String**|  | [default to null]
 **fileId** | **String**|  | [default to null]
 **dateinameDto** | [**DateinameDto**](DateinameDto.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

