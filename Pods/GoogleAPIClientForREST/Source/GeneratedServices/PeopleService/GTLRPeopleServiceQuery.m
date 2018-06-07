// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   People API (people/v1)
// Description:
//   Provides access to information about profiles and contacts.
// Documentation:
//   https://developers.google.com/people/

#import "GTLRPeopleServiceQuery.h"

#import "GTLRPeopleServiceObjects.h"

// ----------------------------------------------------------------------------
// Constants

// sortOrder
NSString * const kGTLRPeopleServiceSortOrderFirstNameAscending = @"FIRST_NAME_ASCENDING";
NSString * const kGTLRPeopleServiceSortOrderLastModifiedAscending = @"LAST_MODIFIED_ASCENDING";
NSString * const kGTLRPeopleServiceSortOrderLastNameAscending  = @"LAST_NAME_ASCENDING";

// ----------------------------------------------------------------------------
// Query Classes
//

@implementation GTLRPeopleServiceQuery

@dynamic fields;

@end

@implementation GTLRPeopleServiceQuery_ContactGroupsBatchGet

@dynamic maxMembers, resourceNames;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"resourceNames" : [NSString class]
  };
  return map;
}

+ (instancetype)query {
  NSString *pathURITemplate = @"v1/contactGroups:batchGet";
  GTLRPeopleServiceQuery_ContactGroupsBatchGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:nil];
  query.expectedObjectClass = [GTLRPeopleService_BatchGetContactGroupsResponse class];
  query.loggingName = @"people.contactGroups.batchGet";
  return query;
}

@end

@implementation GTLRPeopleServiceQuery_ContactGroupsCreate

+ (instancetype)queryWithObject:(GTLRPeopleService_CreateContactGroupRequest *)object {
  if (object == nil) {
    GTLR_DEBUG_ASSERT(object != nil, @"Got a nil object");
    return nil;
  }
  NSString *pathURITemplate = @"v1/contactGroups";
  GTLRPeopleServiceQuery_ContactGroupsCreate *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:nil];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLRPeopleService_ContactGroup class];
  query.loggingName = @"people.contactGroups.create";
  return query;
}

@end

@implementation GTLRPeopleServiceQuery_ContactGroupsDelete

@dynamic deleteContacts, resourceName;

+ (instancetype)queryWithResourceName:(NSString *)resourceName {
  NSArray *pathParams = @[ @"resourceName" ];
  NSString *pathURITemplate = @"v1/{+resourceName}";
  GTLRPeopleServiceQuery_ContactGroupsDelete *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"DELETE"
                       pathParameterNames:pathParams];
  query.resourceName = resourceName;
  query.expectedObjectClass = [GTLRPeopleService_Empty class];
  query.loggingName = @"people.contactGroups.delete";
  return query;
}

@end

@implementation GTLRPeopleServiceQuery_ContactGroupsGet

@dynamic maxMembers, resourceName;

+ (instancetype)queryWithResourceName:(NSString *)resourceName {
  NSArray *pathParams = @[ @"resourceName" ];
  NSString *pathURITemplate = @"v1/{+resourceName}";
  GTLRPeopleServiceQuery_ContactGroupsGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.resourceName = resourceName;
  query.expectedObjectClass = [GTLRPeopleService_ContactGroup class];
  query.loggingName = @"people.contactGroups.get";
  return query;
}

@end

@implementation GTLRPeopleServiceQuery_ContactGroupsList

@dynamic pageSize, pageToken, syncToken;

+ (instancetype)query {
  NSString *pathURITemplate = @"v1/contactGroups";
  GTLRPeopleServiceQuery_ContactGroupsList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:nil];
  query.expectedObjectClass = [GTLRPeopleService_ListContactGroupsResponse class];
  query.loggingName = @"people.contactGroups.list";
  return query;
}

@end

@implementation GTLRPeopleServiceQuery_ContactGroupsMembersModify

@dynamic resourceName;

+ (instancetype)queryWithObject:(GTLRPeopleService_ModifyContactGroupMembersRequest *)object
                   resourceName:(NSString *)resourceName {
  if (object == nil) {
    GTLR_DEBUG_ASSERT(object != nil, @"Got a nil object");
    return nil;
  }
  NSArray *pathParams = @[ @"resourceName" ];
  NSString *pathURITemplate = @"v1/{+resourceName}/members:modify";
  GTLRPeopleServiceQuery_ContactGroupsMembersModify *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.resourceName = resourceName;
  query.expectedObjectClass = [GTLRPeopleService_ModifyContactGroupMembersResponse class];
  query.loggingName = @"people.contactGroups.members.modify";
  return query;
}

@end

@implementation GTLRPeopleServiceQuery_ContactGroupsUpdate

@dynamic resourceName;

+ (instancetype)queryWithObject:(GTLRPeopleService_UpdateContactGroupRequest *)object
                   resourceName:(NSString *)resourceName {
  if (object == nil) {
    GTLR_DEBUG_ASSERT(object != nil, @"Got a nil object");
    return nil;
  }
  NSArray *pathParams = @[ @"resourceName" ];
  NSString *pathURITemplate = @"v1/{+resourceName}";
  GTLRPeopleServiceQuery_ContactGroupsUpdate *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"PUT"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.resourceName = resourceName;
  query.expectedObjectClass = [GTLRPeopleService_ContactGroup class];
  query.loggingName = @"people.contactGroups.update";
  return query;
}

@end

@implementation GTLRPeopleServiceQuery_PeopleConnectionsList

@dynamic pageSize, pageToken, personFields, requestMaskIncludeField,
         requestSyncToken, resourceName, sortOrder, syncToken;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  return @{ @"requestMaskIncludeField" : @"requestMask.includeField" };
}

+ (instancetype)queryWithResourceName:(NSString *)resourceName {
  NSArray *pathParams = @[ @"resourceName" ];
  NSString *pathURITemplate = @"v1/{+resourceName}/connections";
  GTLRPeopleServiceQuery_PeopleConnectionsList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.resourceName = resourceName;
  query.expectedObjectClass = [GTLRPeopleService_ListConnectionsResponse class];
  query.loggingName = @"people.people.connections.list";
  return query;
}

@end

@implementation GTLRPeopleServiceQuery_PeopleCreateContact

@dynamic parent;

+ (instancetype)queryWithObject:(GTLRPeopleService_Person *)object {
  if (object == nil) {
    GTLR_DEBUG_ASSERT(object != nil, @"Got a nil object");
    return nil;
  }
  NSString *pathURITemplate = @"v1/people:createContact";
  GTLRPeopleServiceQuery_PeopleCreateContact *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:nil];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLRPeopleService_Person class];
  query.loggingName = @"people.people.createContact";
  return query;
}

@end

@implementation GTLRPeopleServiceQuery_PeopleDeleteContact

@dynamic resourceName;

+ (instancetype)queryWithResourceName:(NSString *)resourceName {
  NSArray *pathParams = @[ @"resourceName" ];
  NSString *pathURITemplate = @"v1/{+resourceName}:deleteContact";
  GTLRPeopleServiceQuery_PeopleDeleteContact *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"DELETE"
                       pathParameterNames:pathParams];
  query.resourceName = resourceName;
  query.expectedObjectClass = [GTLRPeopleService_Empty class];
  query.loggingName = @"people.people.deleteContact";
  return query;
}

@end

@implementation GTLRPeopleServiceQuery_PeopleGet

@dynamic personFields, requestMaskIncludeField, resourceName;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  return @{ @"requestMaskIncludeField" : @"requestMask.includeField" };
}

+ (instancetype)queryWithResourceName:(NSString *)resourceName {
  NSArray *pathParams = @[ @"resourceName" ];
  NSString *pathURITemplate = @"v1/{+resourceName}";
  GTLRPeopleServiceQuery_PeopleGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.resourceName = resourceName;
  query.expectedObjectClass = [GTLRPeopleService_Person class];
  query.loggingName = @"people.people.get";
  return query;
}

@end

@implementation GTLRPeopleServiceQuery_PeopleGetBatchGet

@dynamic personFields, requestMaskIncludeField, resourceNames;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  return @{ @"requestMaskIncludeField" : @"requestMask.includeField" };
}

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"resourceNames" : [NSString class]
  };
  return map;
}

+ (instancetype)query {
  NSString *pathURITemplate = @"v1/people:batchGet";
  GTLRPeopleServiceQuery_PeopleGetBatchGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:nil];
  query.expectedObjectClass = [GTLRPeopleService_GetPeopleResponse class];
  query.loggingName = @"people.people.getBatchGet";
  return query;
}

@end

@implementation GTLRPeopleServiceQuery_PeopleUpdateContact

@dynamic resourceName, updatePersonFields;

+ (instancetype)queryWithObject:(GTLRPeopleService_Person *)object
                   resourceName:(NSString *)resourceName {
  if (object == nil) {
    GTLR_DEBUG_ASSERT(object != nil, @"Got a nil object");
    return nil;
  }
  NSArray *pathParams = @[ @"resourceName" ];
  NSString *pathURITemplate = @"v1/{+resourceName}:updateContact";
  GTLRPeopleServiceQuery_PeopleUpdateContact *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"PATCH"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.resourceName = resourceName;
  query.expectedObjectClass = [GTLRPeopleService_Person class];
  query.loggingName = @"people.people.updateContact";
  return query;
}

@end
