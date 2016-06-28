'use script';

var React = require('react');
var ReactNative = require('react-native');

var {
	Text,
	View,
	ListView,
} = ReactNative;


var Common = require('../Common');
var SGStyles = require('../SGStyles');
var HttpService = require('../HttpService');

var styles = ReactNative.StyleSheet.create({
	container: {
		flex: 1,
		padding: 10,
		alignItems: 'center',
	},
	headContainer: {
		flex: 1,
		alignItems: 'center'
	},
	cc: {
		flexDirection: 'row',
	},
	totalFee: {
		marginTop: 20
	},
	shuoming: {
		marginTop: 20
	}
});

var ds = new ListView.DataSource({
	rowHasChanged: (r1, r2) => r1 !== r2
});

class MyAssetComponent extends React.Component {

	componentDidMount() {

		 HttpService.get(Common.domain() + '/v1/wd_myAsset?', {
     	 	utoken: this.props.utoken,
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
	}

	_handlerResponse(data) {

		this.setState({
			isLoading: false,
			dataSource: ds.cloneWithRows([
	  		{id: 0},{id: 2},{id: 3}
	  	    ]),
	  	    asset: data,

		})
	}

	constructor(props) {
	  super(props);
	
	  this.state = {
	  	isLoading: true,
	  	dataSource: ds.cloneWithRows([
	  		new Array()
	  	]),
	  	asset: {number: 0}
	  };
	}

	render() {

		if (this.state.isLoading) {

			return Common.loading();
		}
		return (
			<View style={styles.container}>
				<ListView
					dataSource = {this.state.dataSource}
					renderRow = {this.renderRow.bind(this)} />
			</View>
		);
	}

	renderRow(rowData, sectionID, rowID) {

		if (rowID == 0) {
			return (
				<View style={styles.headContainer}>
					<View style={styles.cc}>
						<Text>账户余额 : ￥</Text>
						<Text>{this.state.asset.number}</Text>
					</View>
				</View>
			);
		} else if(rowID == 1) {
			return (
				<View style={styles.totalFee}>
					<Text>您总共回答了100个问题，累计收入10000元</Text>
				</View>
			);
		} 
		return (
			<View style={styles.shuoming}>
				<Text>提现说明：自动体现功能正在开发中，当前如需体现，可以添加松果亲子客服微信sogokids01</Text>
			</View>
		);
	}

}

//注册组件
ReactNative.AppRegistry.registerComponent('MyAssetComponent', () => MyAssetComponent);