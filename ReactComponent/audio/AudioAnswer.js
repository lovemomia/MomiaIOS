'use strict';

var React = require('react');

var ReactNative = require('react-native');
var {
  Text,
  ListView,
  View,
  Image,
  TouchableHighlight
} = ReactNative;

const timer = require('react-native-timer');

var AudioPlayerManager = require('NativeModules').AudioPlayerManager;

var styles = ReactNative.StyleSheet.create({
	container: {
		flex: 1
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
		borderRadius: 22,
		backgroundColor: 'green'
	},
	headText: {
		marginLeft: 10
	},
	questionContainer: {
		height: 60,
		padding: 10,
		marginLeft: 10,
		marginRight: 10,
		alignItems: 'center'
	},
	titleContainer: {
		flexDirection: 'row',
		flex: 1,
		height: 25,
		marginLeft: 10,
		marginRight: 10,
		alignItems: 'center',
		backgroundColor: 'green'
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
		alignItems: 'center',
		backgroundColor: 'red'
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
		flex: 1,
		justifyContent: 'center',
		flexDirection: 'row',
		height: 45,
		marginLeft: 20,
		alignItems: 'center',
		borderRadius: 4,
		backgroundColor: 'gray'
	},
	buttonText: {
		color: 'white',
		fontSize: 16
	}
});

class AudioAnswerComponent extends React.Component {

	constructor(props) {
	  super(props);
	  var ds = new ListView.DataSource({
      rowHasChanged: (r1, r2) => r1 !== r2
      });

	  this.state = {
	  	seconds: 0,
	  	isRecord: false,
	  	dataSource: ds.cloneWithRows([
	  		{id: 0}, {id: 1},{id: 2},{id: 3},{id: 4}
	  	])
	  };
	}

	render() {

		return (
			<View style={styles.container}>
				<ListView
					dataSource = {this.state.dataSource}
					renderRow = {this.renderRow.bind(this)} />
			</View>
		);
	}

	renderRow(rowData, sectionID, rowID) {
		if (rowID == 0 ) {

			return (
				<View style={styles.headContainer } >
					<Image style = {styles.headImage } />
					<Text style={styles.headText}>松果麻麻</Text>
				</View>
			);
		} else if (rowID == 1 ) {

			return (
				<View style = {styles.questionContainer } >
					<Text>孩子4岁，好奇心特别强，每次参加比赛只要输了，就不开心发脾气，请问怎么办？</Text>
				</View>
			);
		} else if (rowID == 2 ) {

			return (
				<View style = {styles.titleContainer } >
					<Text>公开提问，公开回答，答案被人偷听一次，你就赚0.5元. </Text>
				</View>
			);
		} else if (rowID == 3 ) {

			return (
				<View style = {styles.audioBox}>
					<Text style={styles.audioTitle}> 语音回答 </Text>
					<TouchableHighlight onPress={this.pressAudioImage}>
						<Image style={styles.audioImage} />
					</TouchableHighlight>
					<Text style={styles.audioText}> 点击开始录音最多可录120s </Text>
					<Text> { this.state.seconds } ‘</Text>
				</View>
			);
		} else if (rowID == 4 ) {

			return (
				<View style={styles.buttonBox}>
					<TouchableHighlight style={styles.buttonLeft}
										onPress={this.playAudio}>
						<Text style={styles.buttonText}>重录</Text>
					</TouchableHighlight>
					<TouchableHighlight style={styles.buttonRight}>
						<Text style={styles.buttonText}>确认发送</Text>
					</TouchableHighlight>
				</View>
			);
		}
		return (
			<View>
				<Text>Hello Row </Text>
			</View>
		);
	}

	pressAudioImage = () => {
		console.log("press image");
		if (this.state.isRecord == false ) {
			this.state.isRecord = true;
    		timer.setInterval('test', () => {
    			this.setState({ seconds: this.state.seconds + 1 });
    			console.log(this.state.seconds);
    		} , 1000);
    		this.setState({
      			dataSource: this.state.dataSource.cloneWithRows([
      				{id: 0}, {id: 1},{id: 2},{id: 3},{id: 4}]),
    		});
    		AudioPlayerManager.startRecord();

		} else {

			AudioPlayerManager.stopRecord();
			timer.clearInterval('test');
			this.state.isRecord = false;
		}
	}

	playAudio = () => {
		AudioPlayerManager.play();
	}

	//发送语音
	sendAnswer = () => {

	}
}

ReactNative.AppRegistry.registerComponent('AudioAnswerComponent', () => AudioAnswerComponent);