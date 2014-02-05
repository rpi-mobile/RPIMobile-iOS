## Requirements

iOS5 or later

## Usage 

1. add files under `ISRefreshControl/` to your project.
2. import `ISRefreshControl.h`. 

Usage of `ISRefreshControl` is almost the same as that of `UIRefreshControl`.  
set `refreshControl` of `UITableViewController` in `viewDidLoad`.

```objectivec
self.refreshControl = (id)[[ISRefreshControl alloc] init];
[self.refreshControl addTarget:self
                        action:@selector(refresh)
              forControlEvents:UIControlEventValueChanged];
```

or just call `addSubview:`

```objectivec
UIScrollView *scrollView = [[UIScrollView alloc] init];
ISRefreshControl *refreshControl = [[ISRefreshControl alloc] init];
[scrollView addSubview:refreshControl];
[refreshControl addTarget:self
                   action:@selector(refresh)
         forControlEvents:UIControlEventValueChanged];
```

NOTE: currently, `ISRefreshControl` does not support setting on storyboard. 


## How it works

#### iOS6

works as real `UIRefreshControl`.  
the constructor of `ISRefreshControl` returns an instance of `UIRefreshControl`.

#### iOS5

imitates `UIRefreshControl`.
`ISRefreshControl` sends `UIControlEventValueChanged` when content offset of `UITableView` overs threshold.
`UITableViewController` is extended to send content offset to `ISRefreshControl`.

## License

MIT
