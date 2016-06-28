/* 
 * 我的问题列表
 * mosl
 */

'use script';

var React = require('react');
var ReactNative = require('react-native');

var {
	Text,
	View,
	ListView,
	Image,
	TouchableHighlight,
	NativeModules
} = ReactNative;

var RNCommon = NativeModules.RNCommon;

var Common = require('../Common');
var SGStyles = require('../SGStyles');
var HttpService = require('../HttpService');

//样式
var styles = ReactNative.StyleSheet.create({
	container: {
		flex: 1,
	},
	rowContainer: {
		flexDirection: 'column',
	},
	contentContainer: {
		padding: 10,
		flexDirection: 'column'
	},
	image: {
		height: 44,
		width: 44,
		borderRadius: 22,
		backgroundColor: 'green',
	},
	headContainer: {
		flexDirection: 'row',
	},
	leftContainer: {
		flex: 1,
		flexDirection: 'row',
		alignItems: 'center',
	},
	rightContainer: {
		flexDirection: 'row',
		alignItems: 'center',
	},
	middleContainer: {
		flexDirection: 'row',
		alignItems: 'center',
		marginTop: 10
	},
	tailContainer: {
		marginTop: 10,
		flexDirection: 'row'
	},
	bottom: {
		flexDirection: 'row',
		alignItems: 'center'
	},
	time: {
		flex: 1
	},
	seperator: {
		height: 10,
		backgroundColor: '#f1f1f1'
	},
	status: {
		marginLeft: 10
	},
	money: {
		color: 'red'
	}
});

var ds = new ListView.DataSource({
	rowHasChanged: (r1, r2) => r1 !== r2
});

//获取到我问的ViewController
var MyQuestionViewController = require('NativeModules').MyQuestionViewController;

class MyQuestionComponent extends React.Component {

	componentDidMount() {

		 HttpService.get(Common.domain() + '/v1/wd_myQuestion?', {
     	 	utoken: this.props.utoken,
     	 	start: 0
    	}, (resp) => {
      		if (resp.errno == 0) {
        		this._handlerResponse(resp.data);
     	 	} else {
        		// request failed
        		this.setState({
          		isLoading: false
        	});
     	}
      		console.log(resp.data);
    	});
	}

	//构造函数
	constructor(props) {
	  super(props);
	
	  this.state = {
	  	isLoading: true,
	  	dataSource: ds.cloneWithRows([
	  		{id: 0}, {id: 1},{id: 2},{id: 3},{id: 4}
	  	]) 
	  };
	}

	_handlerResponse() {

	}

	//渲染视图
	render() {
		return (
			<View>
				<ListView
					dataSource={this.state.dataSource}
					renderRow = {this.renderRow.bind(this)} />
			</View>
		);
	}

	//渲染rowItem View
	renderRow(rowData, sectionID, rowID) {
		return (
			<TouchableHighlight 
				onPress={() => {
          		this.onPressRowItem(rowID);}}
          		underlayColor="#f1f1f1">
			<View style={styles.rowContainer}>
				<View style={styles.contentContainer}>
					<View style={styles.headContainer}>
						<View style={styles.leftContainer}>
							<Image style={styles.image} />
							<Text>乌鸡国国王</Text>
						</View>
						<View style={styles.rightContainer}>
							<Text style={styles.money}>￥2</Text>
							<Text style={styles.status}>已过期</Text>
						</View>
					</View>
					<View style={styles.middleContainer}>
						<Text>创业历程如何</Text>
					</View>
					<View style={styles.tailContainer}>
						<Text style={styles.time}>13天前</Text>
						<Text>100个人偷偷听</Text>
					</View>
				</View>
				<View style={styles.seperator}/>
			</View>
			</TouchableHighlight>
		);
	}

	onPressRowItem(rowID) {
		console.log("Press Row");
		RNCommon.openUrl('wdquestiondetail?wid=1');
	}

	highlightRow(sectionID, rowID) {
		console.log("highlightRow");
	}
}

//注册组件
ReactNative.AppRegistry.registerComponent('MyQuestionComponent', () => MyQuestionComponent);