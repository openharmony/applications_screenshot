# ScreenShot<a name="ZH-CN_TOPIC_0000001103330836"></a>

- [Introduction](#section11660541593)
    - [Architecture diagram](#section125101832114213)
- [Contents](#section161941989596)
- [Instructions](#section123459000)
- [Related warehouse](#section1371113476307)

## Introduction<a name="section11660541593"></a>

The ScreenShot application is a preset system application in OpenHarmony, which provides users with the function of capturing the current screen and saving the current picture.

## content<a name="section161941989596"></a>

```
/applications/standard/screenshot
     ├── entry # entry module directory
     ├── common # Common tool class directory
     ├── build.gradle # Global build configuration file
     ├── settings.gradle # Compile the module configuration file
     ├── LICENSE # License file
     ├── signature # Certificate file directory
     ├── features # subcomponent directory
     │ ├── screenshot # screenshot component
     │ ├── screenShotModel # Save screenshots, etc.
     ├── product # ScreenShot general function catalog
    
```

## Signature package <a name="section1371113476308"></a>
1. For each module under product/phone, configure signingConfigs in build.gradle

2. Put screenshot.p7b in the signature directory on the corresponding path configured in the build.gradle directory.

## Related warehouse<a name="section1371113476307"></a>

system applications

**applications\_screenshot**
