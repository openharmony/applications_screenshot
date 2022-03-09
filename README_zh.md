# ScreenShot<a name="ZH-CN_TOPIC_0000001103330836"></a>

- [简介](#section11660541593)
    -   [架构图](#section125101832114213)
- [目录](#section161941989596)
- [使用说明](#section123459000)
- [相关仓](#section1371113476307)
- [签名打包](#section1371113476308)

## 简介<a name="section11660541593"></a>

ScreenShot应用是OpenHarmony中预置的系统应用，为用户提供截取当前屏幕，并保存当前图片的功能。

## 目录<a name="section161941989596"></a>

```
/applications/standard/screenshot
    ├── entry                           # entry模块目录
    ├── common                          # 通用工具类目录
    ├── build.gradle                    # 全局编译配置文件
    ├── settings.gradle                 # 编译模块配置文件
    ├── LICENSE                         # 许可文件
    ├── signature                       # 证书文件目录
    ├── features                        # 子组件目录
    │   ├── screenshot                  # 截屏组件   
    │       ├── screenShotModel         # 截屏图片保存等   
    ├── product                         # ScreenShot总体功能目录
```

## 签名打包<a name="section1371113476308"></a>
1.针对product/phone下的每一个模块，配置build.gradle中的signingConfigs

2.将signature目录下的screenshot.p7b放在build.gradle目录中配置的相应路径即可

## 相关仓<a name="section1371113476307"></a>

系统应用

**applications\_screenshot**