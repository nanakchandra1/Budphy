// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Google Cloud Functions API (cloudfunctions/v1)
// Description:
//   API for managing lightweight user-provided functions executed in response
//   to events.
// Documentation:
//   https://cloud.google.com/functions

#import "GTLRCloudFunctionsObjects.h"

// ----------------------------------------------------------------------------
// Constants

// GTLRCloudFunctions_CloudFunction.status
NSString * const kGTLRCloudFunctions_CloudFunction_Status_Active = @"ACTIVE";
NSString * const kGTLRCloudFunctions_CloudFunction_Status_CloudFunctionStatusUnspecified = @"CLOUD_FUNCTION_STATUS_UNSPECIFIED";
NSString * const kGTLRCloudFunctions_CloudFunction_Status_DeleteInProgress = @"DELETE_IN_PROGRESS";
NSString * const kGTLRCloudFunctions_CloudFunction_Status_DeployInProgress = @"DEPLOY_IN_PROGRESS";
NSString * const kGTLRCloudFunctions_CloudFunction_Status_Offline = @"OFFLINE";
NSString * const kGTLRCloudFunctions_CloudFunction_Status_Unknown = @"UNKNOWN";

// GTLRCloudFunctions_OperationMetadataV1.type
NSString * const kGTLRCloudFunctions_OperationMetadataV1_Type_CreateFunction = @"CREATE_FUNCTION";
NSString * const kGTLRCloudFunctions_OperationMetadataV1_Type_DeleteFunction = @"DELETE_FUNCTION";
NSString * const kGTLRCloudFunctions_OperationMetadataV1_Type_OperationUnspecified = @"OPERATION_UNSPECIFIED";
NSString * const kGTLRCloudFunctions_OperationMetadataV1_Type_UpdateFunction = @"UPDATE_FUNCTION";

// GTLRCloudFunctions_OperationMetadataV1Beta2.type
NSString * const kGTLRCloudFunctions_OperationMetadataV1Beta2_Type_CreateFunction = @"CREATE_FUNCTION";
NSString * const kGTLRCloudFunctions_OperationMetadataV1Beta2_Type_DeleteFunction = @"DELETE_FUNCTION";
NSString * const kGTLRCloudFunctions_OperationMetadataV1Beta2_Type_OperationUnspecified = @"OPERATION_UNSPECIFIED";
NSString * const kGTLRCloudFunctions_OperationMetadataV1Beta2_Type_UpdateFunction = @"UPDATE_FUNCTION";

// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_CallFunctionRequest
//

@implementation GTLRCloudFunctions_CallFunctionRequest
@dynamic data;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_CallFunctionResponse
//

@implementation GTLRCloudFunctions_CallFunctionResponse
@dynamic error, executionId, result;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_CloudFunction
//

@implementation GTLRCloudFunctions_CloudFunction
@dynamic availableMemoryMb, descriptionProperty, entryPoint, eventTrigger,
         httpsTrigger, labels, name, serviceAccountEmail, sourceArchiveUrl,
         sourceRepository, sourceUploadUrl, status, timeout, updateTime,
         versionId;

+ (NSDictionary<NSString *, NSString *> *)propertyToJSONKeyMap {
  return @{ @"descriptionProperty" : @"description" };
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_CloudFunction_Labels
//

@implementation GTLRCloudFunctions_CloudFunction_Labels

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_EventTrigger
//

@implementation GTLRCloudFunctions_EventTrigger
@dynamic eventType, failurePolicy, resource, service;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_FailurePolicy
//

@implementation GTLRCloudFunctions_FailurePolicy
@dynamic retry;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_GenerateDownloadUrlRequest
//

@implementation GTLRCloudFunctions_GenerateDownloadUrlRequest
@dynamic versionId;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_GenerateDownloadUrlResponse
//

@implementation GTLRCloudFunctions_GenerateDownloadUrlResponse
@dynamic downloadUrl;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_GenerateUploadUrlRequest
//

@implementation GTLRCloudFunctions_GenerateUploadUrlRequest
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_GenerateUploadUrlResponse
//

@implementation GTLRCloudFunctions_GenerateUploadUrlResponse
@dynamic uploadUrl;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_HttpsTrigger
//

@implementation GTLRCloudFunctions_HttpsTrigger
@dynamic url;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_ListFunctionsResponse
//

@implementation GTLRCloudFunctions_ListFunctionsResponse
@dynamic functions, nextPageToken;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"functions" : [GTLRCloudFunctions_CloudFunction class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"functions";
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_ListLocationsResponse
//

@implementation GTLRCloudFunctions_ListLocationsResponse
@dynamic locations, nextPageToken;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"locations" : [GTLRCloudFunctions_Location class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"locations";
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_ListOperationsResponse
//

@implementation GTLRCloudFunctions_ListOperationsResponse
@dynamic nextPageToken, operations;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"operations" : [GTLRCloudFunctions_Operation class]
  };
  return map;
}

+ (NSString *)collectionItemsKey {
  return @"operations";
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_Location
//

@implementation GTLRCloudFunctions_Location
@dynamic labels, locationId, metadata, name;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_Location_Labels
//

@implementation GTLRCloudFunctions_Location_Labels

+ (Class)classForAdditionalProperties {
  return [NSString class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_Location_Metadata
//

@implementation GTLRCloudFunctions_Location_Metadata

+ (Class)classForAdditionalProperties {
  return [NSObject class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_Operation
//

@implementation GTLRCloudFunctions_Operation
@dynamic done, error, metadata, name, response;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_Operation_Metadata
//

@implementation GTLRCloudFunctions_Operation_Metadata

+ (Class)classForAdditionalProperties {
  return [NSObject class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_Operation_Response
//

@implementation GTLRCloudFunctions_Operation_Response

+ (Class)classForAdditionalProperties {
  return [NSObject class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_OperationMetadataV1
//

@implementation GTLRCloudFunctions_OperationMetadataV1
@dynamic request, target, type, updateTime, versionId;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_OperationMetadataV1_Request
//

@implementation GTLRCloudFunctions_OperationMetadataV1_Request

+ (Class)classForAdditionalProperties {
  return [NSObject class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_OperationMetadataV1Beta2
//

@implementation GTLRCloudFunctions_OperationMetadataV1Beta2
@dynamic request, target, type, updateTime, versionId;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_OperationMetadataV1Beta2_Request
//

@implementation GTLRCloudFunctions_OperationMetadataV1Beta2_Request

+ (Class)classForAdditionalProperties {
  return [NSObject class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_Retry
//

@implementation GTLRCloudFunctions_Retry
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_SourceRepository
//

@implementation GTLRCloudFunctions_SourceRepository
@dynamic deployedUrl, url;
@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_Status
//

@implementation GTLRCloudFunctions_Status
@dynamic code, details, message;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"details" : [GTLRCloudFunctions_Status_Details_Item class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRCloudFunctions_Status_Details_Item
//

@implementation GTLRCloudFunctions_Status_Details_Item

+ (Class)classForAdditionalProperties {
  return [NSObject class];
}

@end
