'use script';

var React = require('react');
var ReactNative = require('react-native');

var {
	View,
	Text,
	ListView,
	Image,
	TextInput
} = ReactNative;

var CheckBox = require('react-native-checkbox');

var styles = ReactNative.StyleSheet.create({

});

var ds = new ListView.DataSource({
	rowHasChanged: (r1, r2) => r1 !== r2
});

var AskQuestionComponent = React.createClass({

	getDefaultProps: function() {
		return {
			
		};
	},

	getInitialState: function() {
		return {
			loading: true,
			dataSource: ds.cloneWithRows([
				{id:1},{id:2},{id: 3},{id: 4}
			]),
		};
	},

	render: function() {
		return (
			<View style={{flex: 1,backgroundColor: '#f1f1f1'}} >
				<ListView
					style={{flex: 1}}
					dataSource={this.state.dataSource}
					renderRow={this._renderRow} />
			</View>
		);
	},

	_renderRow: function(rowData,sectionID,rowID) {

		if (rowID == 0) {
			return (
				<View style={{padding: 10, marginTop: 10, flexDirection: 'row',alignItems: 'center',backgroundColor: 'white'}}>
					<View>
						<Image style={{width: 68,height: 68, borderRadius: 34, backgroundColor: 'green'}} />
					</View>
					<View style={{flex: 1, padding: 10}}>
						<Text>方菁</Text>
						<Text>美国宾夕法尼亚大学访问者，教育专家</Text>
						<Text>已回答20次</Text>
					</View>
				</View>
			);
		} else if (rowID == 1 ) {
			return (
				<View style={{marginTop: 10}}>
					<View style={{height: 120, backgroundColor: 'white'}}>
						<TextInput />
					</View>
					<View style={{flexDirection: 'row', backgroundColor: 'white'}}>
						<View style={{flex: 1}} />
						<Text>0/140</Text>
					</View>
				</View>
			);
		} else if (rowID == 2 ) {
			return (
				<View style={{padding: 10,flexDirection:'row',alignItems: 'center'}}>
					<CheckBox
						label=''
  						checked={true}
  						onChange={(checked) => console.log('I am checked', checked)}
					/>
					<Text style={{flex: 1}}>公开提问，答案每被人偷听一次，你将从中分成0.5元</Text>
				</View>
			);
		}
	}
});

ReactNative.AppRegistry.registerComponent('AskQuestionComponent', () => AskQuestionComponent);
