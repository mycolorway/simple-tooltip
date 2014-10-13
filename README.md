# Simple Tooltip

一个简单的

依赖项：

- JQuery 2.0+
- [Simple Module](https://github.com/mycolorway/simple-module)

### 使用方法
首先，需要在页面里引用相关脚本以及css

```html
<link media="all" rel="stylesheet" type="text/css" href="path/to/tooltip.css" />
<script type="text/javascript" src="path/to/jquery.min.js"></script>
<script type="text/javascript" src="path/to/module.js"></script>
<script type="text/javascript" src="path/to/tooltip.js"></script>

```

可以通过simple.dialog下的三个方法，实例化dialog组件

```js
simple.tooltip({
  el: $('.tooltip'),
  content: 'this is a tooltip',
  position: 'top'
});

```

### API 文档

####初始化选项

__el__

tooltip指向对象的Selector，必选
  
__content__

String，tooltip的内容，必选

__position__
String，tooltip出现的位置

```
[
  'top',
  'bottom',
  'left',
  'right'
]
```

#### 方法

__hide()__ 

显示tooltip

__hide()__ 

隐藏tooltip

__destroy()__

销毁tooltip对象