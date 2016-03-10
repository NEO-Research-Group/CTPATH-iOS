//
//  FNARestClient.h
//  CTPATH-iOS
//
//  Created by fran on 1/3/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNARestClient : NSObject


/*! Secure singleton in parallel environments */
+(instancetype) sharedRestClient;

-(NSDictionary *) getJSONFromURL:(NSString *) url;

@end
