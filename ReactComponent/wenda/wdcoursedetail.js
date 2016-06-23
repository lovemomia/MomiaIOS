'use script';

var React = require('react');
var ReactNative = require('react-native');

var Common = require('../Common');
var SGStyles = require('../SGStyles');
var HttpService = require('../HttpService');

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

	componentDidMount: function() {

		 HttpService.get(Common.domain() + '/v1/wd_courseDetails?', {
     	 	start: 0,
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

	getDefaultProps: function() {
		return {
			
		};
	},

	getInitialState: function() {
		return {
			//typeList [1:课程，2，section头部，3，Question Cell ，4，expert Cell， 5，more course item ，6，more],data:数据
			dataSource: ds.cloneWithRows([
				new Array()
			]),
			isLoading: true
		};
	},

	render: function() {

		if (this.state.isLoading) {

			return Common.loading();
		}
		return (
			<View style={{flex: 1,backgroundColor: '#f1f1f1'}}>
				<View style={{flex: 1}}>
				<ListView
					style={{flex: 1}}
					dataSource={this.state.dataSource}
					renderRow={this._renderRow} />
				</View>
				<TouchableHighlight 
					style={{height: 48, backgroundColor: '#FF6634', justifyContent: 'center',alignItems: 'center'}}
					onPress={() => this._pressAskExpretButton()}
					underlayColor="#FF6634" >
					<Text style={{color: 'white'}}>向专家提问</Text>
				</TouchableHighlight>
			</View>
		);
	},

	_handlerResponse: function(data) {
		var typeList = new Array();

      	if (data.wdcourse) {
      		typeList.push({
      			type: 1,
      			data: data.wdcourse,
      		});
      	}
      	//互动问答
      	if (data.questions) {

      		typeList.push({
      			type: 2,
      			data: '互动问答',
      			icon: 'icon'
      		});
      		for (var i = 0; i < data.questions.length; i++) {
      			typeList.push({
      				type: 3,
      				data: data.questions[i],
      			});
      		}

      		typeList.push({
      			type: 6,
      			data: '查看更多'
      		});
      	}

      	//专家简介 Section
      	typeList.push({
      		type: 2,
      		data: '专家简介',
      		icon: 'icon'
      	});

      	typeList.push({
      		type: 4,
      		data: data.wdcourse
      	});

      	//更多微课
      	if (data.wdcourses) {
      		typeList.push({
      			type: 2,
      			data: '更多微课',
      			icon: 'icon'
      		});

      		for (var i = 0; i < data.wdcourses.list.length; i++) {
      			typeList.push({
      				type: 5,
      				data: data.wdcourses.list[i],
      			});
      		}

      		typeList.push({
      			type: 6,
      			data: '查看更多'
      		});
      	}

      	this.setState({
      		isLoading: false,
      		dataSource: this.state.dataSource.cloneWithRows(typeList),
      		wdcourse: data.wdcourse,
    	});
      	console.log(typeList);
	},

	_renderRow: function(rowData,sectionID,rowID) {

		if (rowData.type == 1) { //课程

			return this._renderCourse(rowData.data);
		} else if (rowData.type == 2) {

			return this._renderSection(rowData.data);
		} else if (rowData.type == 3) {

			return this._renderReAskQuRowItem(rowData.data);
		} else if (rowData.type == 6) {

			return this._renderMore(rowData.data);
		} else if (rowData.type == 4) {

			return this._renderExpert(rowData.data);
		} else if (rowData.type == 5) {

			return this._renderWDCourseRowItem(rowData.data);
		}
		return (
			<View>
				<Text>Hello CourseComponent!</Text>
			</View>
		);
	},

	_renderCourse: function(data) {

		return (
			<TouchableHighlight
				onPress={() => this._pressRowItem()}
				underlayColor = '#f1f1f1'>
			<View style={{padding: 10,marginTop: 10,backgroundColor: 'white'}}>
				<View style={{flexDirection: 'row',alignItems: 'center'}}>
					<View>
						<Image style={{width: 40,height: 40, backgroundColor: 'red'}}
							   source={{uri: data.cover}}/>
					</View>
					<View style={{marginLeft: 10,flex: 1}}>
						<Text style={{fontSize: 13}}>{data.title}</Text>
						<View style={{flexDirection: 'row',alignItems: 'center'}}>
							<Image style={{width: 20,height: 20, backgroundColor: 'red'}}
								   />
							<Text style={{fontSize: 11, color: '#999999'}}>{data.count}次</Text>
							<Image style={{width: 20,height: 20, backgroundColor: 'red'}}/>
							<Text style={{fontSize: 11, color: '#999999'}}> {data.mins}分钟</Text>
						</View>
						<Text style={{fontSize: 11, color: '#999999'}}>{data.startTime}</Text>
					</View>
					<Image style={{width: 10,height: 10,backgroundColor: 'green'}}/>
				</View>
			</View>
			</TouchableHighlight>
		);
	},

	//渲染微课Item
	_renderWDCourseRowItem: function(data) {
		return (
			<View style={{padding: 10,backgroundColor: 'white'}}>
				<View style={{flexDirection: 'row',alignItems: 'center'}}>
					<View>
						<Image style={{width: 40,height: 40, backgroundColor: 'red'}}
							   source={{uri: data.cover}}/>
					</View>
					<View style={{marginLeft: 10,flex: 1}}>
						<Text>{data.title}</Text>
						<View style={{flexDirection: 'row',alignItems: 'center'}}>
							<Image style={{width: 20,height: 20, backgroundColor: 'red'}}/>
							<Text style={{fontSize: 11, color: '#999999'}}>{data.count}次</Text>
							<Image style={{width: 20,height: 20, backgroundColor: 'red'}}/>
							<Text style={{fontSize: 11, color: '#999999'}}> {data.mins}分钟</Text>
						</View>
						<Text style={{fontSize: 11, color: '#999999'}}>{data.startTime}</Text>
					</View>
				</View>
				<View style={{height: 1,backgroundColor:'#f1f1f1',marginTop: 10}} />
			</View>
		);
 	},


	//渲染Section
	_renderSection: function(data) {

		return (
			<View style={{paddingLeft: 10,paddingRight: 10,paddingTop: 5,paddingBottom: 5,backgroundColor: 'white',marginTop: 10}}>
				<View style={{flexDirection: 'row',alignItems: 'center'}}>
					<Image style={{height: 20,width: 20,backgroundColor: 'green'}} />
					<Text style={{color: '#00c49d',marginLeft: 8}}>{data}</Text>
				</View>
				<View style={{height: 1,backgroundColor: '#f1f1f1',marginTop: 4}} />
			</View>
		);
	},

	//渲染互动问答Row
	_renderReAskQuRowItem: function(data) {

		return (
			<View style={{paddingLeft: 10,paddingRight: 10,paddingTop: 5,paddingBottom: 5,backgroundColor: 'white'}}>
				<View>
					<Text>{data.content}</Text>
				</View>
				<View style={{marginTop: 8}}>
					<Text style={{color: '#999999',fontSize: 12}}>{data.expert.name} | {data.expert.intro}</Text>
				</View>
				<View style={{flexDirection: 'row',alignItems: 'center',marginTop: 8}}>
					<Image style={{width: 40,height: 40,backgroundColor:'green',borderRadius: 20}}
						   source={{uri:data.expert.cover}} />
					<View style={{flexDirection: 'row',flex: 1,alignItems: 'center'}}>
						<Image style={{width: 120,height: 40,backgroundColor: '#9DDF59',marginLeft: 10}} />
						<Text style={{color: '#999999'}}> {data.mins} '</Text>
					</View>
					<Text style={{color: '#FF6634'}}>{data.count}人听过</Text>
				</View>
				<View style={{height: 1,backgroundColor: '#f1f1f1',marginTop: 10}} />
			</View>
		);
	},

	//渲染专家简介
	_renderExpert: function(data) {

		return (
			<View style={{alignItems: 'center',backgroundColor: 'white'}}>
				<Image style={{width: 120,height: 120, backgroundColor: 'green'}}
				       source={{uri:data.expert.cover}} />
				<Text>{data.expert.name}</Text>
				<View style={{padding: 10,backgroundColor: 'white'}}>
				<Text>{data.expert.intro}</Text>
			</View>
			</View>
	    );
	},

	//渲染查看更多
	_renderMore: function(data) {
		return (
			<View style={{height: 48,justifyContent: 'center',alignItems: 'center',backgroundColor: 'white'}}>
				<TouchableHighlight style={{borderRadius: 4,borderWidth: 1,borderColor: 'gray',padding: 5}}>
						<Text>{data}</Text>
				</TouchableHighlight>
			</View>
	 	);
	},

	_pressRowItem: function(rowData) {
		RNCommon.openUrl('wdcourseintro');
	},

	_pressAskExpretButton: function() {
		RNCommon.openUrl('askquestion?wid=' +this.state.wdcourse.id);
	},

});

AppRegistry.registerComponent('WendaCourseDetailComponent', () => WendaCourseDetailComponent);