'use script';

var React = require('react');
var ReactNative = require('react-native');

var {
	View,
	Text,
	ListView,
	Image,
	TextInput,
	TouchableHighlight
} = ReactNative;

var CheckBox = require('react-native-checkbox');

var styles = ReactNative.StyleSheet.create({
	multiline: {
		height:80,
		fontSize: 14,
		backgroundColor:'white',
    	padding: 4,
    	color: 'black',
  },
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
			textCount: 10,
			dataSource: ds.cloneWithRows([
				{id:1},{id:2},{id: 3},{id: 4},{id: 5}
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
						<TextInput style={styles.multiline}
									placeholder='向方菁老师提问，等TA语音回答，若超过48小时未回答，将按支付路径全额退款'
									multiline = {true}
									maxLength={200}
        							ref= "comment"
        							autoFocus={true}
        							placeholderTextColor="#999999"
        							onChangeText={(text) => this.textChanged({text})}/>
					</View>
					<View style={{flexDirection: 'row', backgroundColor: 'white'}}>
						<View style={{flex: 1}} />
						<Text>{this.state.textCount}/140</Text>
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
		} else if (rowID == 3) {
			return (
				<View style={{marginTop: 30,padding: 10,alignItems: 'center'}}>
					<Text style={{fontSize: 25,color: '#FF6634'}}>￥9.9元</Text>
				</View>
			);
		} else if (rowID == 4) {
			return (
				<View style={{flex: 1,padding: 20}}>
					<TouchableHighlight 
						style={{backgroundColor: '#FF6634', borderRadius: 5,height: 48,alignItems:'center',justifyContent: 'center'}}>
						<Text style={{color: 'white'}}>提交</Text>
					</TouchableHighlight>
				</View>
			);
		}
	},

	textChanged: function(text) {

		 this.setState({
              textCount: text.text.length,
         });

	}
});

ReactNative.AppRegistry.registerComponent('AskQuestionComponent', () => AskQuestionComponent);
