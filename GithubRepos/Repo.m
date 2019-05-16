//
//  Repo.m
//  GithubRepos
//
//  Created by Luiz on 5/16/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

#import "Repo.h"

@implementation Repo

- (instancetype)initWithName: (NSString *) name andURL: (NSString*) url
{
    self = [super init];
    if (self) {
        _name = name;
        _url = url;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithName: @"" andURL: @""];
}
@end
