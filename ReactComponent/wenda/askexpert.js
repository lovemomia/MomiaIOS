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
} = ReactNative;


var Common = require('../Common');
var SGStyles = require('../SGStyles');
var HttpService = require('../HttpService');

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
				data: {text: '相关微课'}
			});
			list.push({
				type: 3,
				data: data.course
			});
		}
		if (data.expert) {

			list.push({
				type: 2,
				data: {text: '专家简介'}
			});
			list.push({
				type:4,
				data: data.expert
			});
		}

		this.setState({
			isLoading: false,
			dataSource: this.state.dataSource.cloneWithRows(list),
		});
	},

	getInitialState: function() {
		return {
			dataSource: ds.cloneWithRows([
				new Array()
			]),
			isLoading: true,
		};
	},

	render: function() {
		return (
			<View>
				<ListView
					dataSource={this.state.dataSource}
					renderRow={this._renderRow} />
			</View>
		);
	},


	_renderRow: function(rowData,sectionID,rowID) {

		if (rowData.type == 1) {
			return this._renderQuestionView(rowData.data);
		} else if(rowData.type == 2) {
			return this._renderSection(rowData.data);
		} else if(rowData.type == 3) {

			return this._renderCourseView(rowData.data);
		} else if (rowData.type == 4) {

			return this._renderExpert(rowData.data);
		}
		return (<View />);
	},

	_renderExpert: function(data) {
		console.log(data);
		return (
			<View style={{alignItems: 'center',backgroundColor: 'white'}}>
				<Image style={{width: 120,height: 120, backgroundColor: 'green'}}
				        source={{uri:data.cover}}/>
				<Text>{data.name}</Text>
				<View style={{padding: 10,backgroundColor: 'white'}}>
				<Text>{data.intro}</Text>
			</View>
			</View>
	    );
	},

	//渲染Section
	_renderSection: function(data) {

		return (
			<View style={{paddingLeft: 10,paddingRight: 10,paddingTop: 5,paddingBottom: 5,backgroundColor: 'white',marginTop: 10}}>
				<View style={{flexDirection: 'row',alignItems: 'center'}}>
					<Image style={{height: 20,width: 20,backgroundColor: 'green'}} />
					<Text style={{color: '#00c49d',marginLeft: 8}}>{data.text}</Text>
				</View>
				<View style={{height: 1,backgroundColor: '#f1f1f1',marginTop: 4}} />
			</View>
		);
	},

	_renderCourseView: function(data) {

		console.log(data);
    	return <View><View style={{flex:1,flexDirection:'row',backgroundColor:'white'}}>
        	<View style={{alignItems:'center',padding:10}}>
          		<Image style={{width: 50, height: 50, borderRadius: 25}} source={{uri:data.expert.cover}}/>
          	<Text style={{fontSize: 13, color: '#333333',paddingTop:5}} numberOfLines={1}>{data.expert.name}</Text>
        </View>
        <View style={{paddingTop:10, paddingBottom:10, paddingRight:10}}>
          <Text style={{fontSize: 15, color: '#333333'}} numberOfLines={1}>{data.title}</Text>
          <Text style={{flex:1, fontSize: 13, color: '#999999',paddingTop:5}} numberOfLines={1}>{data.subhead}</Text>
          <View style={{flexDirection:'row', justifyContent: 'flex-end'}}>
              <Text style={{fontSize: 13, color: '#999999',paddingRight:10}} numberOfLines={1}>20000次</Text>
              <Text style={{fontSize: 13, color: '#999999'}} numberOfLines={1}>50分钟</Text></View>
        </View>
      </View>
      <View style={styles.separator}/>
      </View>
    },

	_renderQuestionView: function(data) {
    return <View><View style={{backgroundColor:'white', padding:10}}>
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

	_pressEvent: function() {

	},

});

AppRegistry.registerComponent('AskExpertComponent', () => AskExpertComponent);