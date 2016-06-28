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
	RefreshControl
} = ReactNative;

var styles = StyleSheet.create({

});

var ds = new ListView.DataSource({
	rowHasChanged: (r1,r2) => r1!==r2
});

var WendaCourseIntroComponent = React.createClass({

	componentDidMount: function() {

		 HttpService.get(Common.domain() + '/v1/wd_course?', {
     	 	wid: 1,
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
	},

	getInitialState: function() {
		return {
			dataSource: ds.cloneWithRows([new Array()]),
			isLoading: true,
			wdcourse: [],
			refreshing: false
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
					    	onPress={() => this._playCourse()}
					    	underlayColor = '#f1f1f1' >
							<Image style={{width: 50,height: 50, alignItems: 'center',justifyContent: 'center'}}
							   	   source={{uri: data.cover}}>
							   	   <Image style={{width: 30,height: 30}}
							   		  	  source={require('../common/image/play.png')} />
					    	</Image>
					    </TouchableHighlight>
					</View>
					<View style={{marginLeft: 10,flex: 1}}>
						<Text style={{fontSize: 13}}>{data.title}</Text>
						<View style={{flexDirection: 'row',alignItems: 'center',marginTop: 5}}>
							<Image style={{width: 15,height: 15}}
								   source={require('../common/image/count.png')}/>
							<Text style={{fontSize: 11, color: '#999999'}}>{data.count}次</Text>
							<Image style={{width: 15,height: 15,marginLeft: 10}}
								   source={require('../common/image/time.png')}/>
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
				<Image style={{height: 120,backgroundColor: 'green'}}
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

	_playCourse: function() {

		console.log("play.....");
	}
	
});

AppRegistry.registerComponent('WendaCourseIntroComponent',() => WendaCourseIntroComponent);