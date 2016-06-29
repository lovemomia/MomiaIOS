'use script';

var React = require('react');
var ReactNative = require('react-native');

var Common = require('../Common');
var SGStyles = require('../SGStyles');
var HttpService = require('../HttpService');

var {
	View,
	Text,
	ListView,
	Image,
	TextInput,
	TouchableHighlight,
	NativeModules
} = ReactNative;

var CheckBox = require('react-native-checkbox');

var WendaPayManager = NativeModules.WendaPayManager;

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

	componentDidMount: function() {

		 HttpService.get(Common.domain() + '/v1/wd_course?', {
     	 	wid: this.props.wid,
    	}, (resp) => {
      		if (resp.errno == 0) {
        		this._handlerResponse(resp.data);
     	 	} else {
        		// 请求失败
     		}
    	});
	},

	getInitialState: function() {
		return {
			text: '',
			isLoading: true,
			textCount: 0,
			dataSource: ds.cloneWithRows([
				{id:1}
			]),
			expert: {}
		};
	},

	_handlerResponse: function(data) {

		this.setState({
      		isLoading: false,
      		wdcourse: data.wdcourse,
      		expert: data.wdcourse.expert,
      		dataSource: this.state.dataSource.cloneWithRows([
      			{id:1},{id:2},{id: 3},{id: 4},{id: 5}
      		]),
    	});

	},

	render: function() {

		if (this.state.isLoading) {
			return Common.loading();
		}
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

		let placeholder = '向' + this.state.expert.name+'老师提问，等TA语音回答，若超过48小时未回答，将按支付路径全额退款';
		if (rowID == 0) {
			return (
				<View style={{padding: 10, marginTop: 10, flexDirection: 'row',alignItems: 'center',backgroundColor: 'white'}}>
					<View>
						<Image style={{width: 68,height: 68, borderRadius: 34}}
							    source={{uri: this.state.expert.cover}}/>
					</View>
					<View style={{flex: 1, padding: 10}}>
						<Text>{this.state.expert.name}</Text>
						<Text>{this.state.expert.intro}</Text>
						<Text>已回答20次</Text>
					</View>
				</View>
			);
		} else if (rowID == 1 ) {
			return (
				<View style={{marginTop: 10}}>
					<View style={{height: 120, backgroundColor: 'white'}}>
						<TextInput style={styles.multiline}
									placeholder={placeholder}
									multiline = {true}
									maxLength={200}
        							ref= "comment"
        							autoFocus={true}
        							placeholderTextColor="#999999"
        							onChangeText={(text) => this.textChanged({text})}/>
					</View>
					<View style={{flexDirection: 'row', backgroundColor: 'white'}}>
						<View style={{flex: 1}} />
						<Text style={{color: 'gray'}}>{this.state.textCount}/140</Text>
					</View>
				</View>
			);
		} else if (rowID == 2 ) {
			return (
				<View style={{padding: 10,flexDirection:'row',alignItems: 'center'}}>
					<Image source={require('../common/image/check.png')} style={{width: 30,height: 30}}/>
					<Text style={{flex: 1,color: 'gray', fontSize: 13}}>公开提问，答案每被人偷听一次，你将从中分成0.5元</Text>
				</View>
			);
		} else if (rowID == 3) {
			return (
				<View style={{marginTop: 30,padding: 10,alignItems: 'center'}}>
					<Text style={{fontSize: 25,color: '#FF6634'}}>￥ {this.state.wdcourse.price}元</Text>
				</View>
			);
		} else if (rowID == 4) {
			return (
				<View style={{flex: 1,padding: 20}}>
					<TouchableHighlight 
						style={{backgroundColor: '#FF6634', borderRadius: 5,height: 48,alignItems:'center',justifyContent: 'center'}}
						onPress={() => this._submit()}
						underlayColor="#FF6634">
						<Text style={{color: 'white'}}>提交</Text>
					</TouchableHighlight>
				</View>
			);
		}
	},

	textChanged: function(text) {

		 this.setState({
              textCount: text.text.length,
              text: text.text
         });

	},

	//提交问题
	_submit: function() {

		//检查问题内容是否为空
		if (this.state.textCount == 0) {
			return;
		}
		HttpService.get(Common.domain() + '/v1/wd_qJoin?', {
     	 	courseId: this.props.wid,
     	 	utoken: this.props.utoken,
     	 	content: this.state.text
    	}, (resp) => {
      		if (resp.errno == 0) {
        		//this._handleSubmitResponse(resp.data);

            //支付
          	WendaPayManager.pay(resp.data, (error, payResult) => {

          	});

     	 	} else {
        		// request failed
     		}
      		console.log(resp.data);
    	});
	},


	_handleSubmitResponse: function(data) {

	}
});

ReactNative.AppRegistry.registerComponent('AskQuestionComponent', () => AskQuestionComponent);
