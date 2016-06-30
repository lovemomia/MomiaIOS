'use script';

var React = require('react');
var ReactNative = require('react-native');

var {
	View,
	ListView,
	Text,
	Image,
	TouchableHighlight,
	NativeModules
} = ReactNative;

var Common = require('../Common');
var SGStyles = require('../SGStyles');
var HttpService = require('../HttpService');
var LoadingEffect = require('react-native-loading-effect');

let RNCommon = NativeModules.RNCommon;

var styles = ReactNative.StyleSheet.create({
	container: {
		flex: 1,
	},
	viewpagerHead:{
		flexDirection: 'row',
		height: 45
	},
	viewpagerHeadLeftText: {
		flex: 0.5,
		alignItems: 'center',
		justifyContent: 'center'
	},
	viewpagerHeadRightText: {
		flex: 0.5,
		alignItems: 'center',
		justifyContent: 'center'
	},
	viewpager: {
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

var DS = new ListView.DataSource({
	rowHasChanged: (r1, r2) => r1 !== r2
});

var ViewPager = require('react-native-viewpager');

var PagerDataSource = new ViewPager.DataSource({
      pageHasChanged: (p1, p2) => p1 !== p2,
});

var MyAnswerComponent = React.createClass({

	//一些描述
	statics: {
		title: 'MyAnswerComponent',
    	description: 'MyAnswerComponent View'
	},

	componentDidMount: function() {

		 HttpService.get(Common.domain() + '/v1/wd_myAnswer?', {
     	 	utoken:this.props.utoken,
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
	},

	_handlerResponse: function(data) {

		let needAnswerList = new Array();
		let allAnswerList = new Array();

		if (data.nullAnswer) {

			for (var i = 0; i < data.nullAnswer.list.length ; i++){
				needAnswerList.push(
					data.nullAnswer.list[i]
				);
			}
		}


		if (data.allAnswer) {

			for (var i = 0 ; i < data.allAnswer.list.length; i++ ){
				allAnswerList.push(
					data.allAnswer.list[i]
				);
			}
		}


		let needAnswerDataSource = DS.cloneWithRows(
				needAnswerList
			);

		let allAnswerDataSource = DS.cloneWithRows(
				allAnswerList
			);

		this.setState({
			isLoading: false,
			viewpagerDataSource: PagerDataSource.cloneWithPages([
				needAnswerDataSource,allAnswerDataSource
			])
		});
	},

	//初始化 State
	getInitialState: function() {

		let needAnswerDataSource = DS.cloneWithRows([
				new Array()
			]);

		let allAnswerDataSource = DS.cloneWithRows([
				new Array()
			]);

		return {
			viewpagerDataSource: PagerDataSource.cloneWithPages([
				needAnswerDataSource,allAnswerDataSource
			])
		};
	},

	//渲染视图
	render: function() {

		if (this.state.isLoading) {

			return Common.loading();
		}
		return (
			<View style={styles.container} >
				<View style={styles.viewpagerHead} >
					<View style={{flex: 0.5}}>
					<TouchableHighlight 
						style={styles.viewpagerHeadLeftText}
						onPress={this._leftPagePressed}
						underlayColor= '#999999'>
						<Text>待回答</Text>
					</TouchableHighlight>
					<View style={{backgroundColor: '#999999',height: 1}} />
					</View>
					<View style={{backgroundColor: '#999999',width: 1,height: 45}} />
					<View style={{flex: 0.5}}>
					<TouchableHighlight 
						style={styles.viewpagerHeadRightText}
						onPress={this._rightPagePressed}
						underlayColor= '#999999'>
						<Text>全部</Text>
					</TouchableHighlight>
					<View style={{backgroundColor: '#999999',height: 1}} />
					</View>
				</View>
				<ViewPager
					style={styles.viewpager}
          			ref={(viewpager) => {this.viewpager = viewpager}}
          			dataSource={this.state.viewpagerDataSource}
          			renderPage={this._renderPage}
          			renderPageIndicator={this._renderPageIndicator}
          			isLoop={false}
          			autoPlay={false} />
			</View>
		);
	},

	//渲染row
	_renderRow: function(rowData, sectionID, rowID) {

		return (
			<TouchableHighlight
				onPress={() => this._pressQuestionView(rowData)}
				underlayColor='white' >
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
						<Text>{rowData.content}</Text>
					</View>
					<View style={styles.tailContainer}>
						<Text style={styles.time}>{rowData.addTime}</Text>
						<Text>100个人偷偷听</Text>
					</View>
				</View>
				<View style={styles.seperator} />
			</View>
			</TouchableHighlight>
		);
	},

	_pressQuestionView: function(data) {

		//未回答
		if (data.status == 1) {
			//跳到回答页面

			RNCommon.openUrl('answeraudio?qid=' + data.id);

			console.log('open url');
		} else { //已回答
			//跳转到问答详情
			
		}
	},

	//渲染 Page
	_renderPage: function(data: Object,pageID: number | string) {
		return (
			<View style={styles.container}>
				<ListView
					dataSource={data}
					renderRow = {this._renderRow} />
			</View>
		);
	},

	//渲染viewPager的指示器
	_renderPageIndicator: function() {

		return (
			<View />
		);
	},

	//点击row
	_pressRow: function(rowID: number) {

	},

	_leftPagePressed: function() {
		console.log("left page onclick");
	},

	_rightPagePressed: function() {
		console.log("right page onclick");
	},

});

//注册组件
ReactNative.AppRegistry.registerComponent('MyAnswerComponent', () => MyAnswerComponent);

