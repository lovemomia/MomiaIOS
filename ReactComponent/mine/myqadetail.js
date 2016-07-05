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
	ActivityIndicatorIOS,
	Image,
	TouchableHighlight,
	NativeModules
} = ReactNative;

var RNCommon = NativeModules.RNCommon;
const RNStreamingKitManager = NativeModules.RNStreamingKitManager;

var GlobalEventEmitter = require('react-native-global-event-emitter');

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

	componentDidMount: function() {

		 HttpService.get(Common.domain() + '/v1/wd_qExpert?', {
     	 	qid:this.props.qid,
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

		 GlobalEventEmitter.addListener('stopAudio', (data) => {

      		console.log("收到通知，停止语音");
      		RNStreamingKitManager.stop();
    	});
	},

	componentWillUnmount: function() {
    	console.log("goodbye cruel world!")
    	RNStreamingKitManager.stop();
    	if(this.state.isPlay) { //组件卸载，停止播放语音
    		console.log('stop in unmount');
    		RNStreamingKitManager.stop();
    	}
    },

	_handlerResponse: function(data) {

		this.setState({
			loading: false,
			expert: data.expert,
			question: data.question,
			dataSource: ds.cloneWithRows([
				{id: 1},{id: 2}
			]),
			isPlay: false,
		});
	},
	
	getInitialState: function() {
		return {
			id:1,
			loading:true,
			dataSource: ds.cloneWithRows([
				 new Array()
			]),
			expert: '',
			question: ''
		};
	},

	render: function() {

		if (this.state.loading) {
			return this._renderLoadingView();
		}
		return (
			<View style={{flex: 1,backgroundColor: '#f1f1f1'}}>
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
				<View style={{backgroundColor: 'white',marginTop: 10}}>
					<View style={{padding: 10}}>
						<View style={{flexDirection: 'row', alignItems: 'center'}}>
							<Image style={{height: 48, width: 48, borderRadius: 24}}
								source={{uri: this.state.question.userAvatar}} />
							<Text style={{flex: 1,marginLeft: 10}}>{this.state.question.userName}</Text>
							<Text style={{marginRight: 10,color: 'red'}}>{this.state.question.price} ￥</Text>
						</View>
						<View style={{marginTop: 10}}>
							<Text numberOfLines={2}>{this.state.question.content}</Text>
						</View>
						<View style={{flexDirection:'row', padding:10, alignItems:'center'}}>
              				<Image style={{width: 30, height: 30, borderRadius: 15, marginRight: 5}} source={{uri:this.state.expert.cover}}/>
              				<TouchableHighlight onPress={() => this._answerPressed()}
                                  underlayColor='white'>
                				<Image style={{width: 200, height: 30, borderRadius: 15, marginLeft: 10, backgroundColor:'#9DDF59', justifyContent: 'center',alignItems: 'center'}}>
                  					<Text style={{fontSize: 13, color: 'white'}} numberOfLines={1}>点击播放</Text>
                				</Image>
              				</TouchableHighlight>
              				<Text style={{fontSize: 13, color: '#999999',paddingLeft:5}} numberOfLines={1}>60“</Text>
            			</View>
						<View style={{flexDirection:'row'}}>
							<Text style={{flex: 1}}>{this.state.question.addTime}</Text>
							<Text>公开回答，问答双方可见</Text>
						</View>
					</View>
				</View>
			);
		} else if (rowID == 1) {
			return (
				<TouchableHighlight
					onPress={() => this._pressExpertCell()}
					underlayColor='#f1f1f1' >
				<View style={{backgroundColor: 'white',marginTop: 10,justifyContent: 'center'}}>
					<View style={{padding: 10,flexDirection: 'row',alignItems: 'center'}}>
						<Image style={{width: 50, height: 50, borderRadius: 25}}
							   source={{uri: this.state.expert.cover}}/>
						<View style={{flex: 1,padding: 10}}>
							<View style={{flexDirection: 'row',flex: 1}}>
								<Text>{this.state.expert.name}</Text>
							</View>
							<Text style={{fontSize: 13, color: 'gray',marginTop: 5}} numberOfLines={2}>{this.state.expert.intro}</Text>
						</View>
						<Image style={{width: 15, height: 15,}} source={require('../common/image/arrow.png')} />
					</View>
				</View>
				</TouchableHighlight>
			);
		}
	},

	//点击Row
	_pressRow: function(rowID) {

	},

	//点击播放按钮，播放
	_answerPressed: function() {

		if (this.state.isPlay) {
			console.log("stop....");
			RNStreamingKitManager.stop();

			this.setState({
          		isPlay: false,
          	});

			return;
		}
		//判断登录
		RNCommon.isLogin((error, dic) => {
      		if (error) {
        		console.error(error);
      		} else if (dic.isLogin === 'true') {
        		this._requestQuestion(this.state.question.id);

      		} else {
        		RNCommon.openUrl('login');
      		}
    	});

	},

	_requestQuestion: function(questionId) {
		//偷听接口
    	HttpService.get(Common.domain() + '/v1/wd_hJoin?', {
      		qid: questionId
    	}, (resp) => {
      		if (resp.errno == 0) {
        	//判断结果是否可以直接播放了
        	if (resp.data.hasOwnProperty('question')) {
          	//TODO 直接播放
          	this.setState({
          		isPlay: true,
          	});
          	RNStreamingKitManager.play('http://195.154.217.103:8175/stream');
        	} else {
         	 //支付订单
          	WendaPayManager.pay(resp.data.order, (error, payResult) => {

          		//支付回调接口
          	});
        }

      } else {
        // 请求失败

      }
    });
  },

	_pressExpertCell: function() {
		//问专家
		RNCommon.openUrl('wdquestiondetail?qid=' + this.props.qid);
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