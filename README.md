# Simple Tooltip

Simple Tooltip 是一个继承自[Simple Module](https://github.com/mycolorway/simple-module)的组件，同时依赖于JQuery。

#### 初始化
通过`simple.tooltip(opts)`来初始化tooltip组件，其中

```
opts ＝ {
  el: [String],
  content: [String],
  position: [String]
}
```

el是一个字符串，为tooltip指向的Dom的selector。
content为这个tooltip的内容.
postion是这个tooltip的位置，可以是[top, bottom, left, right]
这个函数返回一个实例化的Tooltip对象。

#### Tooltip对象方法

`show()` tooltip出现

`hide()` tooltip消失

`distroy()` 销毁tooltip