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
	TouchableHighlight,
	Image,
	AppRegistry,
	StyleSheet,
	RefreshControl,
	NativeModules
} = ReactNative;

var styles = StyleSheet.create({

});

var ds = new ListView.DataSource({
	rowHasChanged: (r1,r2) => r1!==r2
});

const RNStreamingKitManager = NativeModules.RNStreamingKitManager;

var GlobalEventEmitter = require('react-native-global-event-emitter');

var WendaCourseIntroComponent = React.createClass({

	componentDidMount: function() {

		 HttpService.get(Common.domain() + '/v1/wd_course?', {
     	 	wid: this.props.wid,
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

	getInitialState: function() {
		return {
			dataSource: ds.cloneWithRows([new Array()]),
			isLoading: true,
			wdcourse: [],
			isRefreshing: false
		};
	},


	render: function() {

		if (this.state.isLoading) {
			return Common.loading();
		}
		return (
			<View style={{backgroundColor: '#f1f1f1', flex: 1}}>
				<ListView
					dataSource={this.state.dataSource}
					renderRow={this._renderRow}
            	/>
			</View>
		);
	},

	_onRefresh: function() {

		console.log("log");
		this.setState({isRefreshing: true});
		HttpService.get(Common.domain() + '/v1/wd_course?', {
     	 	wid: this.props.wid,
    	}, (resp) => {
      		if (resp.errno == 0) {
        		this._handlerResponse(resp.data);
     	 	} else {
        		//request failed
     	}
      		console.log(resp.data);
    	});
	},

	_handlerResponse: function(data) {

		let list = new Array();

		list.push({
			type: 1
		});

		list.push({
			type: 2
		});

		list.push({
			type: 3
		});

		list.push({
			type: 4
		});

		this.setState({
      		isLoading: false,
      		dataSource: this.state.dataSource.cloneWithRows(list),
      		wdcourse: data.wdcourse,
      		isRefreshing: false
    	});
	},

	_renderRow: function(rowData,sectionID,rowID) {

		if (rowData.type == 1) {

			return this._renderCourse();
		} else if (rowData.type == 2) {

			return this._renderText();
		} else if (rowData.type == 3) {

			return this._renderImage();
		} else {

			return this._renderText();
		}
	},

	_renderCourse: function() {
		data = this.state.wdcourse;
		return (
			<TouchableHighlight
				underlayColor = '#f1f1f1'>
			<View style={{padding: 10,marginTop: 10,backgroundColor: 'white'}}>
				<View style={{flexDirection: 'row',alignItems: 'center'}}>
					<View>
						<TouchableHighlight
					    	onPress={() => this._playCourse(data)}
					    	underlayColor = '#f1f1f1' >
							<Image style={{width: 50,height: 50, alignItems: 'center',justifyContent: 'center'}}
							   	   source={{uri: data.cover}}>
							   	   <Image style={{width: 30,height: 30}}
							   		  	  source={require('image!play')} />
					    	</Image>
					    </TouchableHighlight>
					</View>
					<View style={{marginLeft: 10,flex: 1}}>
						<Text style={{fontSize: 13}}>{data.title}</Text>
						<View style={{flexDirection: 'row',alignItems: 'center',marginTop: 5}}>
							<Image style={{width: 15,height: 15}}
								   source={require('image!count')}/>
							<Text style={{fontSize: 11, color: '#999999'}}>{data.count}次</Text>
							<Image style={{width: 15,height: 15,marginLeft: 10}}
								   source={require('image!time')}/>
							<Text style={{fontSize: 11, color: '#999999'}}> {data.mins}分钟</Text>
						</View>
						<Text style={{fontSize: 11, color: '#999999',marginTop: 5}}>{data.startTime}</Text>
					</View>
				</View>
			</View>
			</TouchableHighlight>
		);
	},

	_renderImage: function() {
		
		data = this.state.wdcourse;
		return (
			<View style={{padding: 10}}>
				<Image style={{height: 120}}
					   source={{uri:data.cover}} />
			</View>
		);
	},

	_renderText: function() {

		data = this.state.wdcourse;
		return (
			<View style={{padding: 10}}>
				<Text>{data.desc}</Text>
			</View>
		);
	},

	_playCourse: function(course) {

		HttpService.get(Common.domain() + '/v1/wd_tCourseCount', {
			cid: this.props.wid
    	}, (resp) => {
      		if (resp.errno == 0) {
      			//不管结果
     	 	} else {

     		}
      		console.log(resp.data);
    	});

		console.log('start play audio');

		//判断微课内容
		if (course.content != ''){
			console.log(course.content);
			RNStreamingKitManager.play(course.content);
		}
	}
	
});

module.exports = WendaCourseIntroComponent;