// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Google Mirror API (mirror/v1)
// Description:
//   Interacts with Glass users via the timeline.
// Documentation:
//   https://developers.google.com/glass

#import "GTLRMirrorQuery.h"

#import "GTLRMirrorObjects.h"

// ----------------------------------------------------------------------------
// Constants

// orderBy
NSString * const kGTLRMirrorOrderByDisplayTime = @"displayTime";
NSString * const kGTLRMirrorOrderByWriteTime   = @"writeTime";

// ----------------------------------------------------------------------------
// Query Classes
//

@implementation GTLRMirrorQuery

@dynamic fields;

@end

@implementation GTLRMirrorQuery_AccountsInsert

@dynamic accountName, accountType, userToken;

+ (instancetype)queryWithObject:(GTLRMirror_Account *)object
                      userToken:(NSString *)userToken
                    accountType:(NSString *)accountType
                    accountName:(NSString *)accountName {
  if (object == nil) {
    GTLR_DEBUG_ASSERT(object != nil, @"Got a nil object");
    return nil;
  }
  NSArray *pathParams = @[
    @"accountName", @"accountType", @"userToken"
  ];
  NSString *pathURITemplate = @"accounts/{userToken}/{accountType}/{accountName}";
  GTLRMirrorQuery_AccountsInsert *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.userToken = userToken;
  query.accountType = accountType;
  query.accountName = accountName;
  query.expectedObjectClass = [GTLRMirror_Account class];
  query.loggingName = @"mirror.accounts.insert";
  return query;
}

@end

@implementation GTLRMirrorQuery_ContactsDelete

@dynamic identifier;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  return @{ @"identifier" : @"id" };
}

+ (instancetype)queryWithIdentifier:(NSString *)identifier {
  NSArray *pathParams = @[ @"id" ];
  NSString *pathURITemplate = @"contacts/{id}";
  GTLRMirrorQuery_ContactsDelete *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"DELETE"
                       pathParameterNames:pathParams];
  query.identifier = identifier;
  query.loggingName = @"mirror.contacts.delete";
  return query;
}

@end

@implementation GTLRMirrorQuery_ContactsGet

@dynamic identifier;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  return @{ @"identifier" : @"id" };
}

+ (instancetype)queryWithIdentifier:(NSString *)identifier {
  NSArray *pathParams = @[ @"id" ];
  NSString *pathURITemplate = @"contacts/{id}";
  GTLRMirrorQuery_ContactsGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.identifier = identifier;
  query.expectedObjectClass = [GTLRMirror_Contact class];
  query.loggingName = @"mirror.contacts.get";
  return query;
}

@end

@implementation GTLRMirrorQuery_ContactsInsert

+ (instancetype)queryWithObject:(GTLRMirror_Contact *)object {
  if (object == nil) {
    GTLR_DEBUG_ASSERT(object != nil, @"Got a nil object");
    return nil;
  }
  NSString *pathURITemplate = @"contacts";
  GTLRMirrorQuery_ContactsInsert *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:nil];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLRMirror_Contact class];
  query.loggingName = @"mirror.contacts.insert";
  return query;
}

@end

@implementation GTLRMirrorQuery_ContactsList

+ (instancetype)query {
  NSString *pathURITemplate = @"contacts";
  GTLRMirrorQuery_ContactsList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:nil];
  query.expectedObjectClass = [GTLRMirror_ContactsListResponse class];
  query.loggingName = @"mirror.contacts.list";
  return query;
}

@end

@implementation GTLRMirrorQuery_ContactsPatch

@dynamic identifier;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  return @{ @"identifier" : @"id" };
}

+ (instancetype)queryWithObject:(GTLRMirror_Contact *)object
                     identifier:(NSString *)identifier {
  if (object == nil) {
    GTLR_DEBUG_ASSERT(object != nil, @"Got a nil object");
    return nil;
  }
  NSArray *pathParams = @[ @"id" ];
  NSString *pathURITemplate = @"contacts/{id}";
  GTLRMirrorQuery_ContactsPatch *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"PATCH"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.identifier = identifier;
  query.expectedObjectClass = [GTLRMirror_Contact class];
  query.loggingName = @"mirror.contacts.patch";
  return query;
}

@end

@implementation GTLRMirrorQuery_ContactsUpdate

@dynamic identifier;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  return @{ @"identifier" : @"id" };
}

+ (instancetype)queryWithObject:(GTLRMirror_Contact *)object
                     identifier:(NSString *)identifier {
  if (object == nil) {
    GTLR_DEBUG_ASSERT(object != nil, @"Got a nil object");
    return nil;
  }
  NSArray *pathParams = @[ @"id" ];
  NSString *pathURITemplate = @"contacts/{id}";
  GTLRMirrorQuery_ContactsUpdate *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"PUT"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.identifier = identifier;
  query.expectedObjectClass = [GTLRMirror_Contact class];
  query.loggingName = @"mirror.contacts.update";
  return query;
}

@end

@implementation GTLRMirrorQuery_LocationsGet

@dynamic identifier;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  return @{ @"identifier" : @"id" };
}

+ (instancetype)queryWithIdentifier:(NSString *)identifier {
  NSArray *pathParams = @[ @"id" ];
  NSString *pathURITemplate = @"locations/{id}";
  GTLRMirrorQuery_LocationsGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.identifier = identifier;
  query.expectedObjectClass = [GTLRMirror_Location class];
  query.loggingName = @"mirror.locations.get";
  return query;
}

@end

@implementation GTLRMirrorQuery_LocationsList

+ (instancetype)query {
  NSString *pathURITemplate = @"locations";
  GTLRMirrorQuery_LocationsList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:nil];
  query.expectedObjectClass = [GTLRMirror_LocationsListResponse class];
  query.loggingName = @"mirror.locations.list";
  return query;
}

@end

@implementation GTLRMirrorQuery_SettingsGet

@dynamic identifier;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  return @{ @"identifier" : @"id" };
}

+ (instancetype)queryWithIdentifier:(NSString *)identifier {
  NSArray *pathParams = @[ @"id" ];
  NSString *pathURITemplate = @"settings/{id}";
  GTLRMirrorQuery_SettingsGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.identifier = identifier;
  query.expectedObjectClass = [GTLRMirror_Setting class];
  query.loggingName = @"mirror.settings.get";
  return query;
}

@end

@implementation GTLRMirrorQuery_SubscriptionsDelete

@dynamic identifier;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  return @{ @"identifier" : @"id" };
}

+ (instancetype)queryWithIdentifier:(NSString *)identifier {
  NSArray *pathParams = @[ @"id" ];
  NSString *pathURITemplate = @"subscriptions/{id}";
  GTLRMirrorQuery_SubscriptionsDelete *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"DELETE"
                       pathParameterNames:pathParams];
  query.identifier = identifier;
  query.loggingName = @"mirror.subscriptions.delete";
  return query;
}

@end

@implementation GTLRMirrorQuery_SubscriptionsInsert

+ (instancetype)queryWithObject:(GTLRMirror_Subscription *)object {
  if (object == nil) {
    GTLR_DEBUG_ASSERT(object != nil, @"Got a nil object");
    return nil;
  }
  NSString *pathURITemplate = @"subscriptions";
  GTLRMirrorQuery_SubscriptionsInsert *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:nil];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLRMirror_Subscription class];
  query.loggingName = @"mirror.subscriptions.insert";
  return query;
}

@end

@implementation GTLRMirrorQuery_SubscriptionsList

+ (instancetype)query {
  NSString *pathURITemplate = @"subscriptions";
  GTLRMirrorQuery_SubscriptionsList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:nil];
  query.expectedObjectClass = [GTLRMirror_SubscriptionsListResponse class];
  query.loggingName = @"mirror.subscriptions.list";
  return query;
}

@end

@implementation GTLRMirrorQuery_SubscriptionsUpdate

@dynamic identifier;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  return @{ @"identifier" : @"id" };
}

+ (instancetype)queryWithObject:(GTLRMirror_Subscription *)object
                     identifier:(NSString *)identifier {
  if (object == nil) {
    GTLR_DEBUG_ASSERT(object != nil, @"Got a nil object");
    return nil;
  }
  NSArray *pathParams = @[ @"id" ];
  NSString *pathURITemplate = @"subscriptions/{id}";
  GTLRMirrorQuery_SubscriptionsUpdate *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"PUT"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.identifier = identifier;
  query.expectedObjectClass = [GTLRMirror_Subscription class];
  query.loggingName = @"mirror.subscriptions.update";
  return query;
}

@end

@implementation GTLRMirrorQuery_TimelineAttachmentsDelete

@dynamic attachmentId, itemId;

+ (instancetype)queryWithItemId:(NSString *)itemId
                   attachmentId:(NSString *)attachmentId {
  NSArray *pathParams = @[
    @"attachmentId", @"itemId"
  ];
  NSString *pathURITemplate = @"timeline/{itemId}/attachments/{attachmentId}";
  GTLRMirrorQuery_TimelineAttachmentsDelete *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"DELETE"
                       pathParameterNames:pathParams];
  query.itemId = itemId;
  query.attachmentId = attachmentId;
  query.loggingName = @"mirror.timeline.attachments.delete";
  return query;
}

@end

@implementation GTLRMirrorQuery_TimelineAttachmentsGet

@dynamic attachmentId, itemId;

+ (instancetype)queryWithItemId:(NSString *)itemId
                   attachmentId:(NSString *)attachmentId {
  NSArray *pathParams = @[
    @"attachmentId", @"itemId"
  ];
  NSString *pathURITemplate = @"timeline/{itemId}/attachments/{attachmentId}";
  GTLRMirrorQuery_TimelineAttachmentsGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.itemId = itemId;
  query.attachmentId = attachmentId;
  query.expectedObjectClass = [GTLRMirror_Attachment class];
  query.loggingName = @"mirror.timeline.attachments.get";
  return query;
}

+ (instancetype)queryForMediaWithItemId:(NSString *)itemId
                           attachmentId:(NSString *)attachmentId {
  GTLRMirrorQuery_TimelineAttachmentsGet *query =
    [self queryWithItemId:itemId
             attachmentId:attachmentId];
  query.downloadAsDataObjectType = @"media";
  query.loggingName = @"Download mirror.timeline.attachments.get";
  return query;
}

@end

@implementation GTLRMirrorQuery_TimelineAttachmentsInsert

@dynamic itemId;

+ (instancetype)queryWithItemId:(NSString *)itemId
               uploadParameters:(GTLRUploadParameters *)uploadParameters {
  NSArray *pathParams = @[ @"itemId" ];
  NSString *pathURITemplate = @"timeline/{itemId}/attachments";
  GTLRMirrorQuery_TimelineAttachmentsInsert *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:pathParams];
  query.itemId = itemId;
  query.uploadParameters = uploadParameters;
  query.expectedObjectClass = [GTLRMirror_Attachment class];
  query.loggingName = @"mirror.timeline.attachments.insert";
  return query;
}

@end

@implementation GTLRMirrorQuery_TimelineAttachmentsList

@dynamic itemId;

+ (instancetype)queryWithItemId:(NSString *)itemId {
  NSArray *pathParams = @[ @"itemId" ];
  NSString *pathURITemplate = @"timeline/{itemId}/attachments";
  GTLRMirrorQuery_TimelineAttachmentsList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.itemId = itemId;
  query.expectedObjectClass = [GTLRMirror_AttachmentsListResponse class];
  query.loggingName = @"mirror.timeline.attachments.list";
  return query;
}

@end

@implementation GTLRMirrorQuery_TimelineDelete

@dynamic identifier;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  return @{ @"identifier" : @"id" };
}

+ (instancetype)queryWithIdentifier:(NSString *)identifier {
  NSArray *pathParams = @[ @"id" ];
  NSString *pathURITemplate = @"timeline/{id}";
  GTLRMirrorQuery_TimelineDelete *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"DELETE"
                       pathParameterNames:pathParams];
  query.identifier = identifier;
  query.loggingName = @"mirror.timeline.delete";
  return query;
}

@end

@implementation GTLRMirrorQuery_TimelineGet

@dynamic identifier;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  return @{ @"identifier" : @"id" };
}

+ (instancetype)queryWithIdentifier:(NSString *)identifier {
  NSArray *pathParams = @[ @"id" ];
  NSString *pathURITemplate = @"timeline/{id}";
  GTLRMirrorQuery_TimelineGet *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:pathParams];
  query.identifier = identifier;
  query.expectedObjectClass = [GTLRMirror_TimelineItem class];
  query.loggingName = @"mirror.timeline.get";
  return query;
}

@end

@implementation GTLRMirrorQuery_TimelineInsert

+ (instancetype)queryWithObject:(GTLRMirror_TimelineItem *)object
               uploadParameters:(GTLRUploadParameters *)uploadParameters {
  if (object == nil) {
    GTLR_DEBUG_ASSERT(object != nil, @"Got a nil object");
    return nil;
  }
  NSString *pathURITemplate = @"timeline";
  GTLRMirrorQuery_TimelineInsert *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"POST"
                       pathParameterNames:nil];
  query.bodyObject = object;
  query.uploadParameters = uploadParameters;
  query.expectedObjectClass = [GTLRMirror_TimelineItem class];
  query.loggingName = @"mirror.timeline.insert";
  return query;
}

@end

@implementation GTLRMirrorQuery_TimelineList

@dynamic bundleId, includeDeleted, maxResults, orderBy, pageToken, pinnedOnly,
         sourceItemId;

+ (instancetype)query {
  NSString *pathURITemplate = @"timeline";
  GTLRMirrorQuery_TimelineList *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:nil
                       pathParameterNames:nil];
  query.expectedObjectClass = [GTLRMirror_TimelineListResponse class];
  query.loggingName = @"mirror.timeline.list";
  return query;
}

@end

@implementation GTLRMirrorQuery_TimelinePatch

@dynamic identifier;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  return @{ @"identifier" : @"id" };
}

+ (instancetype)queryWithObject:(GTLRMirror_TimelineItem *)object
                     identifier:(NSString *)identifier {
  if (object == nil) {
    GTLR_DEBUG_ASSERT(object != nil, @"Got a nil object");
    return nil;
  }
  NSArray *pathParams = @[ @"id" ];
  NSString *pathURITemplate = @"timeline/{id}";
  GTLRMirrorQuery_TimelinePatch *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"PATCH"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.identifier = identifier;
  query.expectedObjectClass = [GTLRMirror_TimelineItem class];
  query.loggingName = @"mirror.timeline.patch";
  return query;
}

@end

@implementation GTLRMirrorQuery_TimelineUpdate

@dynamic identifier;

+ (NSDictionary<NSString *, NSString *> *)parameterNameMap {
  return @{ @"identifier" : @"id" };
}

+ (instancetype)queryWithObject:(GTLRMirror_TimelineItem *)object
                     identifier:(NSString *)identifier
               uploadParameters:(GTLRUploadParameters *)uploadParameters {
  if (object == nil) {
    GTLR_DEBUG_ASSERT(object != nil, @"Got a nil object");
    return nil;
  }
  NSArray *pathParams = @[ @"id" ];
  NSString *pathURITemplate = @"timeline/{id}";
  GTLRMirrorQuery_TimelineUpdate *query =
    [[self alloc] initWithPathURITemplate:pathURITemplate
                               HTTPMethod:@"PUT"
                       pathParameterNames:pathParams];
  query.bodyObject = object;
  query.identifier = identifier;
  query.uploadParameters = uploadParameters;
  query.expectedObjectClass = [GTLRMirror_TimelineItem class];
  query.loggingName = @"mirror.timeline.update";
  return query;
}

@end
