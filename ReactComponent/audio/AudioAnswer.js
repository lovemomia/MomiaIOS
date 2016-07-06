/*
  专家回答问题的页面
  mosl
 */

'use strict';

var React = require('react');

var ReactNative = require('react-native');
var {
  Text,
  ListView,
  View,
  Image,
  TouchableHighlight,
  NativeModules
} = ReactNative;

const timer = require('react-native-timer');

var LoadingEffect = require('react-native-loading-effect');

import {AudioRecorder, AudioUtils} from 'react-native-audio';
let audioPath = AudioUtils.DocumentDirectoryPath + '/test.aac';

//语音播放录制管理
var AudioPlayerManager = require('NativeModules').AudioPlayerManager;

var CustomAlertViewManager = NativeModules.CustomAlertViewManager;
var Common = require('../Common');
var SGStyles = require('../SGStyles');
var HttpService = require('../HttpService');
var LoadingEffect = require('react-native-loading-effect');

var styles = ReactNative.StyleSheet.create({
	container: {
		flex: 1,
		backgroundColor: '#f1f1f1'
	},
	headContainer: {
		flexDirection: 'row',
		alignItems: 'center',
		height: 60,
		marginLeft: 10,
		marginRight: 10
	},
	headImage: {
		height: 44,
		width: 44,
		borderRadius: 22
	},
	headText: {
		marginLeft: 10
	},
	titleContainer: {
		flexDirection: 'row',
		flex: 1,
		height: 25,
		marginLeft: 10,
		marginRight: 10,
		alignItems: 'center',
	},
	audioBox: {
		alignItems:'center',
		flexDirection: 'column',
		flex: 1,
		paddingTop: 60,
		height: 240,
		marginLeft: 10,
		marginRight: 10
	},
	audioImage: {
		flex: 1,
		height: 120,
		width: 120,
		alignItems: 'center'
	},
	audioTitle: {
		fontSize: 17
	},
	audioText: {
		width: 120,
		fontSize: 17
	},
	buttonBox: {
		flex: 1,
		flexDirection: 'row',
		marginLeft: 10,
		marginRight: 10,
		paddingLeft: 10,
		paddingRight: 10,
		height: 120,
		alignItems: 'center'
	},
	buttonLeft: {
		flex: 0.5,
		justifyContent: 'center',
		flexDirection: 'row',
		height: 45,
		alignItems: 'center',
		borderRadius: 4,
		backgroundColor: 'gray'
	},
	buttonRight: {
		flex: 0.5,
		justifyContent: 'center',
		flexDirection: 'row',
		height: 45,
		marginLeft: 20,
		alignItems: 'center',
		borderRadius: 4,
		backgroundColor: 'gray'
	},
	button: {
		flex: 1,
		justifyContent: 'center',
		flexDirection: 'row',
		height: 45,
		marginLeft: 20,
		marginRight: 20,
		alignItems: 'center',
		borderRadius: 4,
		backgroundColor: 'gray'
	},
	buttonText: {
		color: 'white',
		fontSize: 16
	}
});

let ds = new ListView.DataSource({
      rowHasChanged: (r1, r2) => r1 !== r2
});

class AudioAnswerComponent extends React.Component {

	constructor(props) {
	  super(props);
	 
	  this.state = {
	  	isLoadingDialogVisible:false,
	  	isLoading: true,
	  	seconds: 0,
	  	isRecord: false,
	  	question: '',
	  	dataSource: ds.cloneWithRows([
	  		new Array()
	  	])
	  };
	}

	componentDidMount() {

		 HttpService.get(Common.domain() + '/v1/wd_qExpert?', {
     	 	qid:this.props.qid
    	}, (resp) => {
      		if (resp.errno == 0) {

        		this._handlerResponse(1,resp.data);
     	 	} else {

     		}
      		console.log(resp.data);
    	});

		 /*
		  *   设置录音压缩率，质量,
		  *   SampleRate: 压缩率
		  *   Channels: 频道
		  *
		  */
		 console.log(audioPath);
		 AudioRecorder.prepareRecordingAtPath(audioPath, {
  			SampleRate: 22050,
  			Channels: 1,
  			AudioQuality: "Low",
  			AudioEncoding: "aac"
		});
	}

	render() {

		if (this.state.isLoading) {
			return Common.loading();
		}

		return (
			<View style={styles.container}>
				<ListView
					dataSource = {this.state.dataSource}
					renderRow = {this.renderRow.bind(this)} />
			</View>
        );
	}

	_showLoadingEffect() {
    	this.setState({
      		isLoadingDialogVisible: true
    	});
 	}

  _dismissLoadingEffect() {
    	this.setState({
      		isLoadingDialogVisible: false
    	});
  	}

	renderRow(rowData, sectionID, rowID) {
		if (rowID == 0 ) {

			return (
				<View style={styles.headContainer } >
					<Image style = {styles.headImage }
						   source={{uri: this.state.question.userAvatar}} />
					<Text style={styles.headText}>{this.state.question.userName}</Text>
				</View>
			);
		} else if (rowID == 1 ) {

			return (
				<Text style={{marginLeft: 10,marginRight: 10,backgroundColor: 'white',padding: 10}}>{this.state.question.content}</Text>
			);
		} else if (rowID == 2 ) {

			return (
				<View style = {styles.titleContainer } >
					<Text style={{fontSize: 11,color: '#999999'}}>公开提问，公开回答，答案被人偷听一次，你就赚0.5元. </Text>
				</View>
			);
		} else if (rowID == 3 ) {

			return (
				<View style = {styles.audioBox}>
					<Text style={styles.audioTitle}> 语音回答 </Text>
					<TouchableHighlight onPress={this.pressAudioImage}>
						<Image style={styles.audioImage}
								source={require('image!audio')} />
					</TouchableHighlight>
					<Text style={styles.audioText}> 点击开始录音最多可录120s </Text>
					<Text> { this.state.seconds } ‘</Text>
				</View>
			);
		} else if (rowID == 4 ) {

			return (
				<View style={styles.buttonBox}>
					<TouchableHighlight style={styles.buttonLeft}
										onPress={() => this._reRecord()}
										underlayColor='gray'
					>
						<Text style={styles.buttonText}>重录</Text>
					</TouchableHighlight>
					<TouchableHighlight 
						style={styles.buttonRight}
						onPress={() => this._stopRecord()}
						underlayColor='gray'
					>
						<Text style={styles.buttonText}>停止</Text>
					</TouchableHighlight>
				</View>
			);
		}
		return (
				<View>
					<TouchableHighlight style={styles.button}
										onPress={() => this._submit()}
										underlayColor='gray'
					>
						<Text style={styles.buttonText}>确认发送</Text>
					</TouchableHighlight>
				</View>
			);
	}
	
	pressAudioImage = () => {

		if (this.state.isRecord == false ) {
			this.state.isRecord = true;
    		// timer.setInterval('test', () => {
    		// 	this.setState({ seconds: this.state.seconds + 1 });
    		// 	console.log(this.state.seconds);
    		// } , 1000);
    		// this.setState({
      // 			dataSource: this.state.dataSource.cloneWithRows([
      // 				{id: 0}, {id: 1},{id: 2},{id: 3},{id: 4}]),
    		// });
    		//AudioPlayerManager.startRecord();

    		AudioRecorder.startRecording();
		} 
	}

	playAudio = () => {
		// AudioPlayerManager.play();
	}

	//重录
	_reRecord = () => {
		// AudioPlayerManager.reRecord((error,msg) => {
		// 	console.log(msg);
		// });

		if(this.state.isRecord) { //true
			AudioRecorder.stopRecording();
		    AudioRecorder.startRecording();
		} else { //false
			AudioRecorder.startRecording();
		}
	}

	//停止
	_stopRecord = () => {

		AudioRecorder.stopRecording();
		this.setState({
			isRecord: false
		});
	}

	//提交答案
	_submit() {
		this._showLoadingEffect();
		//第一步，上传文件
		AudioPlayerManager.uploadAudioFile((error,filePath)=> {
			console.log(filePath);
			this._submitAnswer(filePath);
		});
	}

	_submitAnswer(url) {

		//提交答案
		HttpService.get(Common.domain() + '/v1/wd_qAnswer?', {
     	 	questionId: this.props.qid,
     	 	mins: 30,
     	 	answer: url
    	}, (resp) => {
      		if (resp.errno == 0) {
        		// this._handlerResponse(2,resp.data);

        		CustomAlertViewManager.show('回答成功,感谢您的回答！',() => {

        			//
        		});

     	 	} else {

     		}
      		console.log(resp.data);
    	});
	}

	//处理返回的数据
	_handlerResponse(type,data) {

		if (type == 1) { // 初始时返回的数据处理

			this.setState({
				isLoading: false,
				question:data.question,
				dataSource: ds.cloneWithRows([
	  				{id: 0}, {id: 1},{id: 2},{id: 3},{id: 4},{id: 5}
	  			])
			})
		} else if (type == 2) { //提交以后返回的数据处理

		}
	}
}

module.exports = AudioAnswerComponent;
