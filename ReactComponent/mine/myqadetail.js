'use script';

var React = require('react');
var ReactNative = require('react-native');

var SGStyles = require('../SGStyles');

var {
	View,
	Text,
	ListView,
	ActivityIndicatorIOS,
	Image,
} = ReactNative;

var styles = ReactNative.StyleSheet.create({
	loadingContainer: {
		alignItems: 'center',
    	justifyContent: 'center',
	},

});

var ds = new ListView.DataSource({
	rowHasChanged: (r1, r2) => r1 !== r2
});

var MyQADetailComponent = React.createClass({

	getDefaultProps: function() {
		return {
			id:1
		};
	},

	getInitialState: function() {
		return {
			id:1,
			loading:false,
			dataSource: ds.cloneWithRows([
				 {id: 0},{id: 1}
			])
		};
	},

	render: function() {

		if (this.state.loading) {
			return this._renderLoadingView();
		}
		return (
			<View>
				<ListView
					dataSource={this.state.dataSource}
					renderRow={this._renderRow} />
			</View>
		);
	},

	//渲染RowItem
	_renderRow: function(rowData,sectionID,rowID) {

		if (rowID == 0) {
			return (
				<View>
					<View style={{height: 20, backgroundColor:'red'}} />
					<View style={{padding: 10}}>
						<View style={{flexDirection: 'row', alignItems: 'center'}}>
							<Image style={{height: 48, width: 48, borderRadius: 24, backgroundColor: 'red'}} />
							<Text style={{flex: 1}}>DayBreak</Text>
							<Text>￥2</Text>
						</View>
						<View>
							<Text>创业历程如何</Text>
						</View>
						<View>
							<Image />
						</View>
						<View style={{flexDirection:'row'}}>
							<Text style={{flex: 1}}>13天前</Text>
							<Text>私密回答，问答仅双方可见</Text>
						</View>
					</View>
				</View>
			);
		} else if (rowID == 1) {
			return (
				<View>
					<View style={{height: 10, backgroundColor:'red'}} />
					<View style={{padding: 10}}>
						<Image />
						<View>
							<View style={{flexDirection: 'row'}}>
								<Text>张乐Biran</Text>
								<Text>1人收听</Text>
							</View>
							<Text>前大众点评产品汪，现松果亲子创业狗</Text>
						</View>
						<Image style={{width: 50, height: 50, borderRadius: 25}} />
					</View>
				</View>
			);
		}
	},

	//点击Row
	_pressRow: function(rowID) {

	},

	//Loading
	_renderLoadingView: function() {
		return (
			<View style={[SGStyles.container, styles.loadingContainer]}>
				<ActivityIndicatorIOS
					hidden='true'
       				size='small'/>
       		</View>
       	);
	},

});

//注册组件
ReactNative.AppRegistry.registerComponent('MyQADetailComponent', () => MyQADetailComponent);