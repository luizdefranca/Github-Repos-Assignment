//
//  GithubReposTableViewController.m
//  GithubRepos
//
//  Created by Luiz on 5/16/19.
//  Copyright © 2019 Luiz. All rights reserved.
//



#import "GithubReposTableViewController.h"
#import "Repo.h"

@interface GithubReposTableViewController () <UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *myTableVeiw;

@property (nonatomic, strong) NSMutableArray * objects;
@end

@implementation GithubReposTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.objects = [NSMutableArray array];
    [self loadRepo];
}

-(void)viewWillAppear:(BOOL)animated{

}
-(void) loadRepo{
    NSURL *url = [NSURL URLWithString:@"https://api.github.com/users/lighthouse-labs/repos"]; // 1
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url]; // 2

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 3
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 4

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        if (error) { // 1
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }

        NSError *jsonError = nil;
        NSArray *repos = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError]; // 2

        if (jsonError) { // 3
            // Handle the error
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return;
        }


        for (NSDictionary *obj in repos) { // 4
            NSString *name = obj[@"name"];
            NSString *url = obj[@"html_url"];
            Repo * repoobject = [[Repo alloc] initWithName: name andURL: url];

            [self.objects addObject: repoobject];


            NSString *repoName = obj[@"name"];
            NSLog(@"repo: %@", repoName);
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.myTableVeiw reloadData];
        }];


    }];

    [dataTask resume]; // 6
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier: @"cell"];
    Repo *repo = self.objects[indexPath.row];
    cell.textLabel.text = repo.name ;
    cell.detailTextLabel.text = repo.url;
    return cell;
}

@end
