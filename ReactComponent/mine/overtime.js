

var ReactNative = require('react-native');
var React = require('react');

var {
	View,
	Text,
	ListView
} = ReactNative;

var OverTimeComponent = React.createClass({


	getInitialState: function() {
		return {

		};
	},

	render: function() {
		return (
			<View style={{flex: 1,backgroundColor: '#f1f1f1',alighItems: 'center',justifyContent: 'center'}}>
				<Text style={{marginTop: 20,flex: 1}}>您提的问题已经过期了！相关的金额已经退到您的余额里了</Text>
			</View>
		);
	},


});

module.exports = OverTimeComponent;