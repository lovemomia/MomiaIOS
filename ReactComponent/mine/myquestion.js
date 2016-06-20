'use script';

var React = require('react');
var ReactNative = require('react-native');

var {
	Text,
	View,
	ListView,
} = ReactNative;

//样式
var styles = ReactNative.StyleSheet.create({

});

var ds = new ListView.DataSource({
	rowHasChanged: (r1, r2) => r1 !== r2
});

class MyQuestionComponent extends React.Component {

	//构造函数
	constructor(props) {
	  super(props);
	
	  this.state = {
	  	dataSource: ds.cloneWithRows([
	  		{id: 0}, {id: 1},{id: 2},{id: 3},{id: 4}
	  	]) 
	  };
	}

	//渲染视图
	render() {
		return (
			<View>
				<ListView
					dataSource={this.state.dataSource}
					renderRow = {this.renderRow.bind(this)} />
			</View>
		);
	}

	//渲染rowItem View
	renderRow(rowData, sectionID, rowID) {

		return (
			<View>
				<Text>Hello , Boy !</Text>
			</View>
		);
	}
}

//注册组件
ReactNative.AppRegistry.registerComponent('MyQuestionComponent', () => MyQuestionComponent);