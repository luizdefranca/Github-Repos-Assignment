//
//  Repo.h
//  GithubRepos
//
//  Created by Luiz on 5/16/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Repo : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;

- (instancetype)initWithName: (NSString *) name andURL: (NSString *) url;
@end

NS_ASSUME_NONNULL_END
