'use script';

var React = require('react');
var ReactNative = require('react-native');

var {
	Text,
	View,
	ListView,
} = ReactNative;

var styles = ReactNative.StyleSheet.create({

});

var ds = new ListView.DataSource({
	rowHasChanged: (r1, r2) => r1 !== r2
});

class MyAccountComponent extends React.Component {

	constructor(props) {
	  super(props);
	
	  this.state = {};
	}

	render() {
		return (
		);
	}

	renderRow(rowData, sectionID, rowID) {
		return (
		);
	}

}

//注册组件
ReactNative.AppRegistry.registerComponent('MyAccountComponent', () => MyAccountComponent);