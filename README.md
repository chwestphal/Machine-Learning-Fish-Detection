# Machine-Learning-Fish-Detection
This is an iOS prototype to determine regional fish species on images. 🎣 🎣 🎣 🎣

<img src="./images/mockup_iphone_functionality.jpg" width="1000" style="display: block; padding:50px;"><br>

## Install the App:
Download the App by cloning the repository or download the zip file.<br>
Open up the terminal and go to the root of the folder.

```
cd path/to/bei_fisch_frag_chrisch_version1.6
```

Make sure that you have [Homebrew](https://brew.sh/index_de) and [Carthage](https://github.com/Carthage/Carthage) installed.

### Homebrew
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### Carthage
```
brew install carthage
carthage update
```
If it was successful, it should look like this:

<img src="./images/carthage_update.png" width="600" style="display: block; padding:50px;"><br>

### Problems

It can happen, that Xcode is complaining about finding neccessary libraries. Therefore go to the Carthage folder and add
**CropViewController.framework** and **PaperOnboarding.framework** to your Linked Frameworks and Libraries via drag and drop. This should look like this in the end:
  
<img src="./images/xcode_frameworks_preview.png" width="1000" style="display: block; padding:50px;"><br>

