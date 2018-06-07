// NOTE: This file was generated by the ServiceGenerator.

// ----------------------------------------------------------------------------
// API:
//   Cloud Speech API (speech/v1)
// Description:
//   Converts audio to text by applying powerful neural network models.
// Documentation:
//   https://cloud.google.com/speech/

#import "GTLRSpeechObjects.h"

// ----------------------------------------------------------------------------
// Constants

// GTLRSpeech_RecognitionConfig.encoding
NSString * const kGTLRSpeech_RecognitionConfig_Encoding_Amr    = @"AMR";
NSString * const kGTLRSpeech_RecognitionConfig_Encoding_AmrWb  = @"AMR_WB";
NSString * const kGTLRSpeech_RecognitionConfig_Encoding_EncodingUnspecified = @"ENCODING_UNSPECIFIED";
NSString * const kGTLRSpeech_RecognitionConfig_Encoding_Flac   = @"FLAC";
NSString * const kGTLRSpeech_RecognitionConfig_Encoding_Linear16 = @"LINEAR16";
NSString * const kGTLRSpeech_RecognitionConfig_Encoding_Mulaw  = @"MULAW";
NSString * const kGTLRSpeech_RecognitionConfig_Encoding_OggOpus = @"OGG_OPUS";
NSString * const kGTLRSpeech_RecognitionConfig_Encoding_SpeexWithHeaderByte = @"SPEEX_WITH_HEADER_BYTE";

// ----------------------------------------------------------------------------
//
//   GTLRSpeech_Context
//

@implementation GTLRSpeech_Context
@dynamic phrases;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"phrases" : [NSString class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSpeech_LongRunningRecognizeRequest
//

@implementation GTLRSpeech_LongRunningRecognizeRequest
@dynamic audio, config;
@end


// ----------------------------------------------------------------------------
//
//   GTLRSpeech_Operation
//

@implementation GTLRSpeech_Operation
@dynamic done, error, metadata, name, response;
@end


// ----------------------------------------------------------------------------
//
//   GTLRSpeech_Operation_Metadata
//

@implementation GTLRSpeech_Operation_Metadata

+ (Class)classForAdditionalProperties {
  return [NSObject class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSpeech_Operation_Response
//

@implementation GTLRSpeech_Operation_Response

+ (Class)classForAdditionalProperties {
  return [NSObject class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSpeech_RecognitionAlternative
//

@implementation GTLRSpeech_RecognitionAlternative
@dynamic confidence, transcript, words;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"words" : [GTLRSpeech_WordInfo class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSpeech_RecognitionAudio
//

@implementation GTLRSpeech_RecognitionAudio
@dynamic content, uri;
@end


// ----------------------------------------------------------------------------
//
//   GTLRSpeech_RecognitionConfig
//

@implementation GTLRSpeech_RecognitionConfig
@dynamic enableWordTimeOffsets, encoding, languageCode, maxAlternatives,
         profanityFilter, sampleRateHertz, speechContexts;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"speechContexts" : [GTLRSpeech_Context class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSpeech_RecognitionResult
//

@implementation GTLRSpeech_RecognitionResult
@dynamic alternatives;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"alternatives" : [GTLRSpeech_RecognitionAlternative class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSpeech_RecognizeRequest
//

@implementation GTLRSpeech_RecognizeRequest
@dynamic audio, config;
@end


// ----------------------------------------------------------------------------
//
//   GTLRSpeech_RecognizeResponse
//

@implementation GTLRSpeech_RecognizeResponse
@dynamic results;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"results" : [GTLRSpeech_RecognitionResult class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSpeech_Status
//

@implementation GTLRSpeech_Status
@dynamic code, details, message;

+ (NSDictionary<NSString *, Class> *)arrayPropertyToClassMap {
  NSDictionary<NSString *, Class> *map = @{
    @"details" : [GTLRSpeech_Status_Details_Item class]
  };
  return map;
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSpeech_Status_Details_Item
//

@implementation GTLRSpeech_Status_Details_Item

+ (Class)classForAdditionalProperties {
  return [NSObject class];
}

@end


// ----------------------------------------------------------------------------
//
//   GTLRSpeech_WordInfo
//

@implementation GTLRSpeech_WordInfo
@dynamic endTime, startTime, word;
@end
