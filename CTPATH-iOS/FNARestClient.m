//
//  FNARestClient.m
//  CTPATH-iOS
//
//  Created by fran on 1/3/16.
//  Copyright © 2016 fran. All rights reserved.
//

#import "FNARestClient.h"

@implementation FNARestClient


+(instancetype) sharedRestClient{
    
    static FNARestClient * restClient;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        restClient = [[FNARestClient alloc] init];
    });
    
    return restClient;
}

-(NSDictionary *) getJSONFromURL:(NSString *)url{
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    NSError * error;
    
    NSDictionary * json = [NSJSONSerialization
                           JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    if(error){
        
        NSLog(@"Hola hay error");
    }

    return json;
}

@end
