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
	TouchableHighlight,

} = ReactNative;

var ds = new ListView.DataSource({
	rowHasChanged: (r1,r2) => r1!==r2
});

var RNCommon = NativeModules.RNCommon;

var styles = ReactNative.StyleSheet.create({
	separator: {
    	height: 0.5,
    	backgroundColor: '#dddddd',
    	marginLeft: 10
  },
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
      			data: {text: '互动问答',image: 'question'}
      		});
      		for (var i = 0; i < data.questions.length; i++) {
      			typeList.push({
      				type: 3,
      				data: data.questions[i],
      			});
      		}

      		typeList.push({
      			type: 6,
      			data: {text: '查看更多',dataType: 1}, //1,互动问答， 2, 更多微课
      		});
      	}

      	//专家简介 Section
      	typeList.push({
      		type: 2,
      		data: {text:'专家简介',image: 'expert'}
      	});

      	typeList.push({
      		type: 4,
      		data: data.wdcourse
      	});

      	//更多微课
      	if (data.wdcourses) {
      		typeList.push({
      			type: 2,
      			data: {text:'更多微课',image:'course'}
      		});

      		for (var i = 0; i < data.wdcourses.list.length; i++) {
      			typeList.push({
      				type: 5,
      				data: data.wdcourses.list[i],
      			});
      		}

      		typeList.push({
      			type: 6,
      			data: {text: '查看更多',dataType: 2},
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

			return this._renderQuestionView(rowData.data);
		} else if (rowData.type == 6) {

			return this._renderMore(rowData.data);
		} else if (rowData.type == 4) {

			return this._renderExpert(rowData.data);
		} else if (rowData.type == 5) {

			return (
				<View>
				  {Common.courseCell(rowData.data,() => {RNCommon.openUrl('wdcoursedetail?id=' + rowData.data.id);})}
				  <View style={styles.separator}/>
				</View>
			);
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
					    <TouchableHighlight
					    	onPress={() => this.playCourse()}
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
					<Image style={{width: 20,height: 20}}
						   source={require('../common/image/arrow.png')} />
				</View>
			</View>
			</TouchableHighlight>
		);
	},

	//渲染Section
	_renderSection: function(data) {

		var image = '';
		if ( data.image == 'expert') {
			image = require('../common/image/expert.png');
		} else if (data.image == 'question') {
			image = require('../common/image/question.png');
		} else {
			image = require('../common/image/course.png');
		}
		return (
			<View style={{paddingLeft: 10,paddingRight: 10,paddingTop: 5,paddingBottom: 5,backgroundColor: 'white',marginTop: 10}}>
				<View style={{flexDirection: 'row',alignItems: 'center'}}>
					<Image style={{height: 20,width: 20}}
						   source={image} />
					<Text style={{color: '#00c49d',marginLeft: 8}}>{data.text}</Text>
				</View>
				<View style={{height: 1,backgroundColor: '#f1f1f1',marginTop: 4}} />
			</View>
		);
	},

	_renderQuestionView: function(data) {

    return (
    	<TouchableHighlight 
    		onPress={() => this.goToQuestionDetail(data)}
    		underlayColor = '#f1f1f1'>
    		<View>
    			<View style={{backgroundColor:'white', padding:10}}>
            		<Text style={{fontSize: 15, color: '#333333'}} numberOfLines={1}>{data.content}</Text>
            		<Text style={{fontSize: 13, color: '#999999',paddingTop:5}} numberOfLines={1}>{data.expert.name} | {data.expert.intro}</Text>
            		<View style={{flexDirection:'row', paddingTop:10, alignItems:'center'}}>
              			<Image style={{width: 30, height: 30, borderRadius: 15, marginRight: 5}} source={{uri:data.expert.cover}}/>
              				<Image style={{width: 200, height: 30, borderRadius: 15, marginLeft: 10, backgroundColor:'#9DDF59', justifyContent: 'center',alignItems: 'center'}}>
                				<Text style={{fontSize: 13, color: 'white'}} numberOfLines={1}>1元偷听</Text>
              				</Image>
              			<Text style={{fontSize: 13, color: '#999999',paddingLeft:5}} numberOfLines={1}>60“</Text>
            		</View>
        		</View>
        		<View style={styles.separator}/>
        	</View>
        </TouchableHighlight>
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
				<TouchableHighlight style={{borderRadius: 4,borderWidth: 1,borderColor: 'gray',padding: 5}}
									onPress={() => this._lookMore(data.dataType) }
									underlayColor='white'>
						<Text>{data.text}</Text>
				</TouchableHighlight>
			</View>
	 	);
	},

	_lookMore: function(dataType) {

		if (dataType == 1) { //互动问答，转向问题列表

			RNCommon.openUrl('wdquestionlist?wid=1');
		} else { //转向更多微课的列表

			RNCommon.openUrl('wdcourselist');
		}
	},

	_pressRowItem: function(rowData) {
		RNCommon.openUrl('wdcourseintro');
	},

	_pressAskExpretButton: function() {
		RNCommon.openUrl('askquestion?wid=' +this.state.wdcourse.id);
	},

	goToQuestionDetail: function(data) {

		RNCommon.openUrl('wdquestiondetail?wid=1');
	},

	playCourse: function() {

		console.log('start play audio');
	}

});

AppRegistry.registerComponent('WendaCourseDetailComponent', () => WendaCourseDetailComponent);