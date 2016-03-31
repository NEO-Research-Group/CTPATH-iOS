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
    
    NSError * error;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:NSDataReadingUncached error:&error];
    
    if(error){
        
        
        
    }else{
        NSDictionary * json = [NSJSONSerialization
                               JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        return json;
    }
    
    
    
    

    return nil;
}

@end
