# abgabe_http_api.api.AbgabeApi

## Load the API package
```dart
import 'package:abgabe_http_api/api.dart';
```

All URIs are relative to *https://api.sharezone.net*

Method | HTTP request | Description
------------- | ------------- | -------------
[**publishSubmission**](AbgabeApi.md#publishSubmission) | **patch** /v1/submissions/{id} | 


# **publishSubmission**
> publishSubmission(id, submissionDto)



### Example 
```dart
import 'package:abgabe_http_api/api.dart';

var api_instance = new AbgabeApi();
var id = id_example; // String | 
var submissionDto = new SubmissionDto(); // SubmissionDto | 

try { 
    api_instance.publishSubmission(id, submissionDto);
} catch (e) {
    print("Exception when calling AbgabeApi->publishSubmission: $e\n");
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | [default to null]
 **submissionDto** | [**SubmissionDto**](SubmissionDto.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

