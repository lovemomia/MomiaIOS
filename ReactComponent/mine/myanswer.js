'use script';

var React = require('react');
var ReactNative = require('react-native');

var {
	View,
	ListView,
	Text,
	Image,
	TouchableHighlight,
} = ReactNative;

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
		justifyContent: 'center',
		backgroundColor: 'green'
	},
	viewpagerHeadRightText: {
		flex: 0.5,
		alignItems: 'center',
		justifyContent: 'center',
		backgroundColor: 'red'
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

	//初始化 State
	getInitialState: function() {
		return {
			dataSource: DS.cloneWithRows([
				{id: 1},{id: 2},{id: 3},{id: 4}
			]),
			viewpagerDataSource: PagerDataSource.cloneWithPages([
				{id: 1},{id: 2}
			])
		};
	},

	//渲染视图
	render: function() {
		return (
			<View style={styles.container} >
				<View style={styles.viewpagerHead} >
					<TouchableHighlight 
						style={styles.viewpagerHeadLeftText}
						onPress={this._leftPagePressed}>
						<Text>待回答</Text>
					</TouchableHighlight>
					<TouchableHighlight 
						style={styles.viewpagerHeadRightText}
						onPress={this._rightPagePressed}>
						<Text>全部</Text>
					</TouchableHighlight>
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
	_renderRow: function(rowData: string, sectionID: number, rowID: number) {
		return (
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
				<View style={styles.seperator} />
			</View>
		);
	},

	//渲染 Page
	_renderPage: function(data: Object,pageID: number | string) {
		return (
			<View style={styles.container}>
				<ListView
					dataSource={this.state.dataSource}
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
		// ViewPager.goToPage(0,true);
		console.log(ViewPager);
	},

	_rightPagePressed: function() {
		console.log("right page onclick");
		// ViewPager.goToPage(1,true);
	},

});

//注册组件
ReactNative.AppRegistry.registerComponent('MyAnswerComponent', () => MyAnswerComponent);

