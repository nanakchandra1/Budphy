// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Cloud Data Loss Prevention (DLP) API (dlp/v2)
// Description:
//   Provides methods for detection, risk analysis, and de-identification of
//   privacy-sensitive fragments in text, images, and Google Cloud Platform
//   storage repositories.
// Documentation:
//   https://cloud.google.com/dlp/docs/

#import "GTLRDLP.h"

// ----------------------------------------------------------------------------
// Authorization scope

NSString * const kGTLRAuthScopeDLPCloudPlatform = @"https://www.googleapis.com/auth/cloud-platform";

// ----------------------------------------------------------------------------
//   GTLRDLPService
//

@implementation GTLRDLPService

- (instancetype)init {
  self = [super init];
  if (self) {
    // From discovery.
    self.rootURLString = @"https://dlp.googleapis.com/";
    self.batchPath = @"batch";
    self.prettyPrintQueryParameterNames = @[ @"prettyPrint", @"pp" ];
  }
  return self;
}

@end
