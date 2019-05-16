# Github-Repos-Assignment

Learning Outcomes
Understand how to use NSURLSession to get JSON from a web API.
Understand how to parse JSON into arrays and dictionaries.
Introduction
We are going to make a request to github's API to get a list of all our repos.

This is the URL we will be using (replace {github-username} with your github username):

https://api.github.com/users/{github-username}/repos

For example, this would be the URL for lighthouse-labs:

https://api.github.com/users/lighthouse-labs/repos

If you enter this URL into your browser, your should get a large JSON response that starts something like this:

[
    {
        "id": 21934510,
        "name": "angular_bookstore",
        "full_name": "lighthouse-labs/angular_bookstore",
        "owner": {
        "login": "lighthouse-labs",
        "id": 5753105,
...
If you’d like to see it nicely formatted and you use Chrome, you can download this extention: Chrome JSON Formatter, if you use Safari, download this extension Safari JSON Formatter. This formatting will help going forward because it makes it easier to notice dictionaries and arrays.

JSON Dictionaries and Arrays
JSON Dictionaries start and end with curly brackets { } and arrays start and end with square brackets [ ].

Let’s look closely as the JSON response. Notice that we are dealing with an array of dictionaries. If we look through these dictionaries we can find a key called name which tells us the name of the repo. Let's make an iOS app that gets the names of all our repos.

Making the request
We are going to make a request to this API from an iOS app. Create a new single view application and add the following code to your view controller's viewDidLoad, using your github URL:

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSURL *url = [NSURL URLWithString:@"https://api.github.com/users/lighthouse-labs/repos"]; // 1
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url]; // 2

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 3
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 4

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {



    }]; // 5

    [dataTask resume]; // 6

}
Create a new NSURL object from the github url string.
Create a new NSURLRequest object using the URL object. Use this object to make configurations specific to the URL. For example, specifying if this is a GET or POST request, or how we should cache data.
An NSURLSessionConfiguration object defines the behavior and policies to use when making a request with an NSURLSession object. We can set things like the caching policy on this object, similar to the NSURLRequest object, but we can use the session configuration to create many different requests, where any configurations we make to the NSURLRequest object will only apply to that single request. The default system values are good for now, so we'll just grab the default configuration.
Create an NSURLSession object using our session configuration. Any changes we want to make to our configuration object must be done before this.
We create a task that will actually get the data from the server. The session creates and configures the task and the task makes the request. Data tasks send and receive data using NSData objects. Data tasks are intended for short, often interactive requests to a server. Check out the NSURLSession API Referece for more info on this. We could optionally use a delegate to get notified when the request has completed, but we're going to use a completion block instead. This block will get called when the network request is complete, weather it was successful or not.
A task is created in a suspended state, so we need to resume it. We can also suspend, resume, and cancel tasks whenever we want. This can be incredibly useful when downloading larger files using a download task.
We are doing nothing in the completion handler, so if we were to run this, we would see no evidence of a request being made.

Let's add the following code to the completion handler:

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

    // If we reach this point, we have successfully retrieved the JSON from the API
    for (NSDictionary *repo in repos) { // 4

        NSString *repoName = repo[@"name"];
        NSLog(@"repo: %@", repoName);
    }
}];
The completion handler takes 3 parameters:

data: The data returned by the server, most of the time this will be JSON or XML.
response: Response metadata such as HTTP headers and status codes.
error: An NSError that indicates why the request failed, or nil when the request is successful.
If there was an error, we want to handle it straight away so we can fix it. Here we're checking if there was an error, logging the description, then returning out of the block since there's no point in continuing.
The data task retrieves data from the server as an NSData object because the server could return anything. We happen to know that this server is returning JSON so we need a way to convert this data to JSON. Luckily we can just use the NSJSONSerialization object to do just that. We know that the top level object in the JSON response is a JSON object (not an array or string) so we're setting the json as a dictionary.
If there was an error getting JSON from the NSData, like if the server actually returned XML to us, then we want to handle it here.
If we get to this point, we have the JSON data back from our request, so let's use it. When we made this request in our browser, we saw something similar to this:
[
    {
        "id": 21934510,
        "name": "angular_bookstore",
        "full_name": "lighthouse-labs/angular_bookstore",
        "owner": {
So we can see that we have an array of dictionaries that have the key 'name'. In order to access this in Objective-C, we can just loop through each dictionary element of the array and grab the name object and save it to a string.

Run your app now and you should see a list of all your github repos printed to the screen.

Present your Repos in a Table View
Add a Tableview to your View Controller, and assign the View Controller as its delegate and datasource.
Once a successful request has been made, present each repo's name in a tableview cell.
Things to keep in mind:

Remember that when we update a table view's data, we have to reload the tableview.
We always have to perform UI updates on the main thread.
[[NSOperationQueue mainQueue] addOperationWithBlock:^{
    // This will run on the main queue
}];
Create objects for your repos
Up until this point we have been using an NSDictionary to represent a repo, but that's not a very Object Oriented way of doing things.

Create a new Repo class.
When the network request is successful, convert the NSDictionaries to Repo objects.
Use those repo objects everywhere else in your app.
