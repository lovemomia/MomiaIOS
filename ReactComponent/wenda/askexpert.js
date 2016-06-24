/*
 * 问专家
 * mosl
 *
 */

'use script';

var ReactNative = require('react-native');
var React = require('react');

var {
	View,
	Text,
	ListView,
	AppRegistry,
	TouchableHighlight,
	Image,
	NativeModules,
} = ReactNative;


var Common = require('../Common');
var SGStyles = require('../SGStyles');
var HttpService = require('../HttpService');


var RNCommon = NativeModules.RNCommon;

var ds = new ListView.DataSource({
	rowHasChanged: (r1,r2) => r1!==r2
});

var styles = ReactNative.StyleSheet.create({

	separator: {
    	height: 0.5,
    	backgroundColor: '#dddddd'
  },

});
var AskExpertComponent = React.createClass({


	componentDidMount: function() {

		HttpService.get(Common.domain() + '/v1/wd_qExpert?', {
     	 	qid: 1,
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

	_handlerResponse: function(data) {

		let list = new Array();
		if (data.question) {
			list.push({
				type: 1,
				data: data.question,
			});
		}
		if (data.course) {

			list.push({
				type: 2,
				data: {text: '相关微课',image: 'course'} //1.微课 2.专家
			});
			list.push({
				type: 3,
				data: data.course
			});
		}
		if (data.expert) {

			list.push({
				type: 2,
				data: {text: '专家简介',image: 'expert'}
			});
			list.push({
				type:4,
				data: data.expert
			});
		}

		this.setState({
			isLoading: false,
			dataSource: this.state.dataSource.cloneWithRows(list),
			wdcourse: data.course,
		});
	},

	getInitialState: function() {
		return {
			dataSource: ds.cloneWithRows([
				new Array()
			]),
			isLoading: true,
			wdcourse: ''
		};
	},

	render: function() {

		if (this.state.isLoading) {
			return Common.loading();
		}
		return (
			<View style={{flex: 1,backgroundColor: '#f1f1f1'}}>
				<ListView
					style={{flex: 1}}
					dataSource={this.state.dataSource}
					renderRow={this._renderRow} />
				<TouchableHighlight 
					style={{height: 48, backgroundColor: '#FF6634', justifyContent: 'center',alignItems: 'center'}}
					onPress={() => this._pressAskExpretButton()}
					underlayColor="#FF6634" >
					<Text style={{color: 'white'}}>向专家提问</Text>
				</TouchableHighlight>
			</View>
		);
	},


	_renderRow: function(rowData,sectionID,rowID) {

		if (rowData.type == 1) {

			return this._renderQuestionView(rowData.data);
		} else if(rowData.type == 2) {

			return this._renderSection(rowData.data);
		} else if(rowData.type == 3) {

			return Common.courseCell(rowData.data,() => {console.log("onclick")});
		} else if (rowData.type == 4) {

			return this._renderExpert(rowData.data);
		}
		return (<View />);
	},

	//渲染专家
	_renderExpert: function(data) {
		console.log(data);
		return (
			<View style={{alignItems: 'center',backgroundColor: 'white'}}>
				<Image style={{width: 80,height: 80, backgroundColor: 'green',marginTop: 10}}
				        source={{uri:data.cover}}/>
				<Text style={{marginTop: 10}}>{data.name}</Text>
				<View style={{padding: 10,backgroundColor: 'white'}}>
				<Text>{data.intro}</Text>
			</View>
			</View>
	    );
	},

	//渲染Section
	_renderSection: function(data) {
		var image = '';
		if (data.image == 'expert') {
			image = require('../common/image/expert.png');
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

	//渲染课程
	_renderCourse: function(data) {

		return (
			<TouchableHighlight
				onPress={() => {}}
				underlayColor = '#f1f1f1'>
			<View style={{padding: 10,backgroundColor: 'white'}}>
				<View style={{flexDirection: 'row',alignItems: 'center'}}>
					<View>
						<Image style={{width: 50,height: 50}}
							   source={{uri: data.cover}}/>
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

	_renderQuestionView: function(data) {

    return <View>
    			<View style={{backgroundColor:'white', padding:10,marginTop: 15}}>
            		<Text style={{fontSize: 15, color: '#333333'}} numberOfLines={1}>{data.content}</Text>
            		<Text style={{fontSize: 13, color: '#999999',paddingTop:5}} numberOfLines={1}>{data.expert.name} | {data.expert.intro}</Text>
            		<View style={{flexDirection:'row', paddingTop:10, alignItems:'center'}}>
              			<Image style={{width: 30, height: 30, borderRadius: 15, marginRight: 5}} source={{uri:data.expert.cover}}/>
              			<Image style={{width: 200, height: 30, borderRadius: 15, marginLeft: 10, backgroundColor:'#00c49d', justifyContent: 'center',alignItems: 'center'}}>
                			<Text style={{fontSize: 13, color: 'white'}} numberOfLines={1}>1元偷听</Text>
              			</Image>
              			<Text style={{fontSize: 13, color: '#999999',paddingLeft:5}} numberOfLines={1}>60“</Text>
            		</View>
        		</View>
        		<View style={styles.separator}/>
        	</View>
    },

    //问专家
    _pressAskExpretButton: function() {
    	RNCommon.openUrl('askquestion?wid=' +this.state.wdcourse.id);
    },

});

AppRegistry.registerComponent('AskExpertComponent', () => AskExpertComponent);