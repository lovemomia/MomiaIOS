'use script';

var React = require('react');
var ReactNative = require('react-native');

var {
	View,
	Text,
	ListView,
	TouchableHighlight,
	Image,
	AppRegistry,
	StyleSheet,
} = ReactNative;

var styles = StyleSheet.create({

});

var ds = new ListView.DataSource({
	rowHasChanged: (r1,r2) => r1!==r2
});

var WendaCourseIntroComponent = React.createClass({

	getInitialState: function() {
		return {
			dataSource: ds.cloneWithRows([
				{id: 1},{id: 2},{id: 3},{id: 4}
			])
		};
	},


	render: function() {
		return (
			<View style={{backgroundColor: '#f1f1f1', flex: 1}}>
				<ListView
					dataSource={this.state.dataSource}
					renderRow={this._renderRow} />
			</View>
		);
	},

	_renderRow: function(rowData,sectionID,rowID) {

		if (rowID == 0) {
			return this._renderHeader();
		} else if (rowID == 1) {
			return this._renderTextView();
		} else if (rowID ==2) {
			return this._renderImage();
		} else {
			return this._renderTextView();
		}
		return (
			<TouchableHighlight
				onPress = {() => this._pressRow(rowData,sectionID,rowID)} >
				<View>
					<Text>Hello ,bog</Text>
				</View>
			</TouchableHighlight>
		);
	},

	_renderHeader: function() {
		return (
			<View style={{padding: 10,marginTop: 10,backgroundColor: 'white'}}>
				<View style={{flexDirection: 'row',alignItems: 'center'}}>
					<View>
						<Image style={{width: 40,height: 40, backgroundColor: 'red'}}/>
					</View>
					<View style={{marginLeft: 10,flex: 1}}>
						<Text style={{fontSize: 13}}>在孩子教育过程中，如何做到零吼叫？</Text>
						<View style={{flexDirection: 'row',alignItems: 'center'}}>
							<Image style={{width: 20,height: 20, backgroundColor: 'red'}}/>
							<Text style={{fontSize: 11, color: '#999999'}}>20000次</Text>
							<Image style={{width: 20,height: 20, backgroundColor: 'red'}}/>
							<Text style={{fontSize: 11, color: '#999999'}}> 20分钟</Text>
						</View>
						<Text style={{fontSize: 11, color: '#999999'}}>2016年5月1日</Text>
					</View>
					<Image style={{width: 10,height: 10,backgroundColor: 'green'}}/>
				</View>
			</View>
		);
	},

	_renderImage: function() {
		return (
			<View style={{padding: 10}}>
				<Image style={{height: 120,backgroundColor: 'green'}} />
			</View>
		);
	},

	_renderTextView: function() {
		return (
			<View style={{padding: 10}}>
				<Text>在讨伐克罗诺斯时，独眼巨人送给宙斯闪电火，给波塞冬三叉戟，给哈迪斯黑暗头盔。此后波塞冬经常手持三叉戟，这成了他的标志。当他愤怒时海底就会出现怪物，他挥动三叉戟不但能轻易掀起滔天巨浪引起风暴和海啸、使大陆沉没、天地崩裂，还能将万物打得粉碎，甚至引发震撼整个世界的强大地震，由于过于强悍，就连冥王都惧怕会不会令宇宙裂开导致冥界暴露在人间，但象征他的圣兽海豚则显示出海的宁静和波塞冬亲切的神性。爱琴海附近的希腊海员和渔民对他极为的崇拜</Text>
			</View>
		);
	},

	_pressRow: function(rowData,sectionID,rowID) {

	},

});

AppRegistry.registerComponent('WendaCourseIntroComponent',() => WendaCourseIntroComponent);