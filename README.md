本工程为基于高德地图iOS SDK进行封装，实现了兴趣点搜索的功能。
## 前述 ##
- [高德官网申请Key](http://lbs.amap.com/dev/#/).
- 阅读[开发指南](http://lbs.amap.com/api/ios-sdk/summary/).
- 工程基于iOS 3D地图SDK和搜索SDK实现

## 功能描述 ##
基于3D地图SDK和搜索SDK进行封装，通过搜索提示进行关键字提示，然后再进行兴趣点关键字查询。

## 核心类/接口 ##
| 类    | 接口  | 说明   | 版本  |
| -----|:-----:|:-----:|:-----:|
| AMapSearchAPI	| - (void)AMapInputTipsSearch:(AMapInputTipsSearchRequest *)request; | 输入提示查询接口 | v4.0.0 |
| AMapSearchAPI	| - (void)AMapPOIKeywordsSearch:(AMapPOIKeywordsSearchRequest *)request; | POI 关键字查询接口 | v4.0.0 |

## 核心难点 ##
`Objective-c`
```
/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    if (response.count == 0)
    {
        return;
    }
    
    [self.tips setArray:response.tips];
    [self.tableView reloadData];
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (response.pois.count == 0)
    {
        return;
    }
    
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
        
    }];
    
    /* 将结果以annotation的形式加载到地图上. */
    [self.mapView addAnnotations:poiAnnotations];
    
    /* 如果只有一个结果，设置其为中心点. */
    if (poiAnnotations.count == 1)
    {
        [self.mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
    }
    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
    else
    {
        [self.mapView showAnnotations:poiAnnotations animated:NO];
    }
}
```
`swift`
```
/* 输入提示回调. */
func onInputTipsSearchDone(_ request: AMapInputTipsSearchRequest!, response: AMapInputTipsSearchResponse!) {

    if currentRequest == nil || currentRequest! != request {
        return
    }

    if response.count == 0 {
        return
    }

    tableData.removeAll()
    for aTip in response.tips {
        tableData.append(aTip)
    }
    tableView.reloadData()
}

/* POI 搜索回调. */
func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
    if response.count == 0 {
        return
    }

    var poiAnnotations: [POIAnnotation] = Array()

        for poi in response.pois {
        let anno = POIAnnotation(poi: poi)
        poiAnnotations.append(anno!)
    }

    mapView.addAnnotations(poiAnnotations)

    if poiAnnotations.count == 1 {
        mapView.centerCoordinate = (poiAnnotations.first?.coordinate)!
    }
    else {
        mapView.showAnnotations(poiAnnotations, animated: false)
    }

}
```
