'use script';

var React = require('react');
var ReactNative = require('react-native');

var {
	Text,
	View,
	Image,
	ListView,
	AppRegistry,
	NativeModules,
	TouchableHighlight
} = ReactNative;

var ds = new ListView.DataSource({
	rowHasChanged: (r1,r2) => r1!==r2
});

var RNCommon = NativeModules.RNCommon;

var styles = ReactNative.StyleSheet.create({

});

var WendaCourseDetailComponent = React.createClass({

	getDefaultProps: function() {
		return {
			
		};
	},


	getInitialState: function() {
		return {
			dataSource: ds.cloneWithRows([
				{id: 0},{id: 1}
			]) 
		};
	},

	render: function() {
		return (
			<View style={{flex: 1}}>
				<View style={{flex: 1}}>
				<ListView
					style={{flex: 1}}
					dataSource={this.state.dataSource}
					renderRow={this._renderRow} />
				</View>
				<TouchableHighlight 
					style={{height: 48, backgroundColor: '#FF6634', justifyContent: 'center',alignItems: 'center'}}
					onPress={() => this._pressAskExpretButton()} >
					<Text>向专家提问</Text>
				</TouchableHighlight>
			</View>
		);
	},

	_renderRow: function(rowData,sectionID,rowID) {

		if (rowID == 0) {

			return this._renderHeaderView();
		}
		return (
			<View>
				<Text>Hello CourseComponent!</Text>
			</View>
		);
	},

	_renderHeaderView: function(data) {

		return (
			<View style={{padding: 10}}>
				<View style={{flexDirection: 'row'}}>
					<View>
						<Image style={{width: 40,height: 40, backgroundColor: 'red'}}/>
					</View>
					<View>
						<Text>在孩子教育过程中，如何做到零吼叫？</Text>
						<View style={{flexDirection: 'row'}}>
							<Image style={{width: 20,height: 20, backgroundColor: 'red'}}/>
							<Text>20000次</Text>
							<Image style={{width: 20,height: 20, backgroundColor: 'red'}}/>
							<Text> 20分钟</Text>
						</View>
						<Text>2016年五月一日</Text>
					</View>
					<Image style={{width: 10,height: 10,backgroundColor: 'green'}}/>
				</View>
			</View>
		);
	},

	_pressRowItem: function(rowData) {

	},

	_pressAskExpretButton: function() {

		RNCommon.openUrl('askquestion');
	},

});

AppRegistry.registerComponent('WendaCourseDetailComponent', () => WendaCourseDetailComponent);