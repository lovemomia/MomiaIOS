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
var Swiper = require('../swiper.js');

let RNCommon = NativeModules.RNCommon;

var styles = ReactNative.StyleSheet.create({
	container: {
		flex: 1,
		backgroundColor: '#f1f1f1',
	},
	viewpagerHead:{
		flexDirection: 'row',
		height: 45,
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
		backgroundColor: 'white',
		marginTop: 10
	},
	contentContainer: {
		padding: 10,
		flexDirection: 'column'
	},
	image: {
		height: 44,
		width: 44,
		borderRadius: 22,
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
     		}
      		console.log(resp.data);
    	});
	},

	_handlerResponse: function(data) {

		let needAnswerList = new Array();
		let allAnswerList = new Array();

		if (data.nullAnswer) {

			for (var i = 0; i < data.nullAnswer.list.length ; i++){
				needAnswerList.push({
					data:data.nullAnswer.list[i],
					type: 1
				}
				);
			}
		}


		if (data.allAnswer) {

			for (var i = 0 ; i < data.allAnswer.list.length; i++ ){
				allAnswerList.push({

					data: data.allAnswer.list[i],
					type: 1
				}
				);
			}
		}

		if (needAnswerList.length == 0) {
			needAnswerList.push({
				type: 0,//没数据
				data: '没有需要回答的问题'
			});
		} 

		if (allAnswerList.length == 0) {
			allAnswerList.push({
				type: 0,
				data: '没有回答过的问题'
			});
		}
		let needAnswerDataSource = DS.cloneWithRows(
				needAnswerList
			);	
		let allAnswerDataSource = DS.cloneWithRows(
				allAnswerList
			);


		this.setState({
			isLoading: false,
			needAnswerDataSource: needAnswerDataSource,
			allAnswerDataSource: allAnswerDataSource,
			index: 0
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
			]),
			isLoading: true,
			needAnswerDataSource: needAnswerDataSource,
			allAnswerDataSource: allAnswerDataSource,
			Index: 0
		};
	},

	//渲染视图
	render: function() {

		if (this.state.isLoading) {

			return Common.loading();
		}

		return (

			<View style={styles.container}
				   >
				<View style={styles.viewpagerHead}
				      ref={component => this.head = component} >
					<View style={{flex: 0.5}}
					      backgroundColor={this.state.Index == 1? 'black': 'white'}>
					<TouchableHighlight 
						style={styles.viewpagerHeadLeftText}
						onPress={this._leftPagePressed}
						underlayColor= '#999999'
						>
						<Text>待回答</Text>
					</TouchableHighlight>
					<View style={{backgroundColor: '#999999',height: 1}} />
					</View>
					<View style={{backgroundColor: '#999999',width: 1,height: 45}} />
					<View style={{flex: 0.5}}
					      backgroundColor={this.state.Index == 1? 'black': 'white'}>
					<TouchableHighlight 
						style={styles.viewpagerHeadRightText}
						onPress={this._rightPagePressed}
						underlayColor= '#999999'
						>
						<Text>全部</Text>
					</TouchableHighlight>
					<View style={{backgroundColor: '#999999',height: 1}} />
					</View>
				</View>
				<Swiper style={{flex: 1}}
						loop={false}
						ref={component => this.swiper = component} >
					<ListView
						style={{flex: 1}}
						dataSource={this.state.needAnswerDataSource}
						renderRow={this._renderRow}
					/>
					<ListView
						style={{flex: 1}}
						dataSource={this.state.allAnswerDataSource}
						renderRow={this._renderRow}
					/>
				</Swiper>
			</View>
		);
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

		//这里，如果数据为空的话返回的是一个空数组
		if (rowData instanceof Array) {
			return <View />
		}

		let type = rowData.type;
		let data = rowData.data;

		if (type == 0) {

			return (
				<View style={{flex: 1,alignItems: 'center',marginTop: 40}}>
					<Text>{data}</Text>
				</View>
		    );
		}
		var status = '';
		if (rowData.status == 1) {
			stauts = '未回答';
		} else if (rowData.status == 3) {
			status = '已回答';
		} else {
			status = '已过期';
		}
		console.log(status);
		return (
			<TouchableHighlight
				onPress={() => this._pressQuestionView(data)}
				underlayColor='#f1f1f1' >
			<View style={styles.rowContainer}>
				<View style={styles.contentContainer}>
					<View style={styles.headContainer}>
						<View style={styles.leftContainer}>
							<Image style={styles.image}
							       source={{uri: data.userAvatar}} />
							<Text style={{marginLeft: 10}}>{data.userName}</Text>
						</View>
						<View style={styles.rightContainer}>
							<Text style={styles.money}>￥{data.price}</Text>
							<Text style={{marginLeft: 10,fontSize: 12,color: '#999999'}}>{status}</Text>
						</View>
					</View>
					<View style={styles.middleContainer}>
						<Text style={{flex: 1}}>{data.content}</Text>
					</View>
					<View style={styles.tailContainer}>
						<Text style={{fontSize: 12,color: '#999999',flex: 1}}>{data.addTime}</Text>
						<Text style={{fontSize: 12,color: '#999999'}}>{rowData.count}个人偷偷听</Text>
					</View>
				</View>
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
			RNCommon.openUrl('myqadetail?qid=' + data.id);
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

		if(this.state.index == 0) return;
		this.swiper.scrollIndex(0);
		this.setState({
			index: 0
		});
		// this.state.Index = 0;

		// this.head.shouldComponentUpdate();
	},

	_rightPagePressed: function() {
		console.log("right page onclick");
		if(this.state.index == 1) return;
		this.swiper.scrollIndex(1);
		this.setState({
			index: 1
		});
		// this.state.Index = 1;

		// this.head.shouldComponentUpdate();
	},

});

//注册组件
module.exports = MyAnswerComponent;

