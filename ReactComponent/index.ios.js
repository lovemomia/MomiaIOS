'use strict';

const WDHomeComponent = require('./wenda/wdhome.js');
const AskQuestionComponent = require('./audio/askquestion.js');
const AudioAnswerComponent = require('./audio/audioanswer.js');
const HomeComponent = require('./home/home.js');
const MyAnswerComponent = require('./mine/myanswer.js');
const MyAssetComponent = require('./mine/myasset.js');
const MyQADetailComponent = require('./mine/myqadetail.js');
const MyQuestionComponent = require('./mine/myquestion.js');
const AboutComponent = require('./setting/about.js');
const FeedBackComponent = require('./setting/feedback.js');
const AskExpertComponent = require('./wenda/wdaskexpert.js');
const WendaCourseDetailComponent = require('./wenda/wdcoursedetail.js');
const WendaCourseIntroComponent = require('./wenda/wdcourseintro.js');
const WDCourseListComponent = require('./wenda/wdcourselist.js');
const WDQuestionListComponent = require('./wenda/wdquestionlist.js');
const Common = require('./Common.js');
const SGStyles = require('./SGStyles.js');
const HttpService = require('./HttpService.js');

const WaitExpertComponent = require('./wenda/waitexpert.js');

const ReactNative = require('react-native');

ReactNative.AppRegistry.registerComponent('SimpleApp', () => SimpleApp);
ReactNative.AppRegistry.registerComponent('WDHomeComponent', () => WDHomeComponent);
ReactNative.AppRegistry.registerComponent('AskQuestionComponent', () => AskQuestionComponent);
ReactNative.AppRegistry.registerComponent('AudioAnswerComponent', () => AudioAnswerComponent);
ReactNative.AppRegistry.registerComponent('HomeComponent', () => HomeComponent);
ReactNative.AppRegistry.registerComponent('MyAnswerComponent', () => MyAnswerComponent);
//注册组件
ReactNative.AppRegistry.registerComponent('MyAssetComponent', () => MyAssetComponent);
//注册组件
ReactNative.AppRegistry.registerComponent('MyQADetailComponent', () => MyQADetailComponent);
//注册组件
ReactNative.AppRegistry.registerComponent('MyQuestionComponent', () => MyQuestionComponent);

ReactNative.AppRegistry.registerComponent('AboutComponent', () => AboutComponent);
ReactNative.AppRegistry.registerComponent('FeedBackComponent', () => FeedBackComponent);

ReactNative.AppRegistry.registerComponent('AskExpertComponent', () => AskExpertComponent);

ReactNative.AppRegistry.registerComponent('WendaCourseDetailComponent', () => WendaCourseDetailComponent);

ReactNative.AppRegistry.registerComponent('WendaCourseIntroComponent',() => WendaCourseIntroComponent);

ReactNative.AppRegistry.registerComponent('WDCourseListComponent', () => WDCourseListComponent);

ReactNative.AppRegistry.registerComponent('WDQuestionListComponent', () => WDQuestionListComponent);

ReactNative.AppRegistry.registerComponent('WaitExpertComponent', () => WaitExpertComponent);