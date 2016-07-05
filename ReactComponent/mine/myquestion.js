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
	NativeModules,
	RefreshControl
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
		marginLeft: 10,
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
	  		{id: 0}
	  	]) 
	  };
	}

	_handlerResponse(data) {

		let list = new Array();

		for (var i = 0; i < data.list.length; i++ ) {
			list.push(data.list[i]);
		}
		this.setState({
			isLoading: false,
			dataSource: ds.cloneWithRows(list),
			isRefreshing: false
		});
	}

	//渲染视图
	render() {

		if (this.state.isLoading) {
			return Common.loading();
		}
		return (
			<View style={{flex: 1}}>
				<ListView
					dataSource={this.state.dataSource}
					renderRow = {this.renderRow.bind(this)}
				/>
			</View>
		);
	}

	_onRefresh() {

		//设置刷新状态
		this.setState({isRefreshing: true});

		//获取数据
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

	//渲染rowItem View
	renderRow(rowData, sectionID, rowID) {
		return (
			<TouchableHighlight 
				onPress={() => {
          		this.onPressRowItem(rowData);}}
          		underlayColor="#f1f1f1">
			<View style={styles.rowContainer}>
				<View style={styles.contentContainer}>
					<View style={styles.headContainer}>
						<View style={styles.leftContainer}>
							<Image style={styles.image}
								   source={{uri:rowData.expert.cover}} />
							<Text style={{marginLeft: 10}}>{rowData.expert.name}</Text>
						</View>
						<View style={styles.rightContainer}>
							<Text style={styles.money}>￥{rowData.price}</Text>
							<Text style={styles.status}>{rowData.status == 3 ? '已回答' : '未回答'}</Text>
						</View>
					</View>
					<View style={styles.middleContainer}>
						<Text>{rowData.content}</Text>
					</View>
					<View style={styles.tailContainer}>
						<Text style={styles.time}>{rowData.addTime}</Text>
						<Text>{rowData.count}个人偷偷听</Text>
					</View>
				</View>
				<View style={styles.seperator}/>
			</View>
			</TouchableHighlight>
		);
	}

	onPressRowItem(question) {

		//判断问题是否已回答  问题的状态，1: 未回答  3: 已回答  4: 已过期
		RNCommon.openUrl('myqadetail?qid=' + question.id);
	}
}

//注册组件
ReactNative.AppRegistry.registerComponent('MyQuestionComponent', () => MyQuestionComponent);