'use script';

var ReactNative = require('react-native');

var React = require('react');

var {
	View,
	Text,
} = ReactNative;

var WaitExpertComponent = React.createClass({

	render: function() {

		return (
		<View style={{flex: 1,alignItems: 'center'}}>
			<Text style={{marginTop: 20}}>您的问题专家还未回答，请等待</Text>
		</View>
		);

	}
});

module.exports = WaitExpertComponent;