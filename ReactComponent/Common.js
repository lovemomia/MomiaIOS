'use strict';

import React, {
	Component
} from 'react';

var ReactNative = require('react-native');

var {
	View,
	ActivityIndicatorIOS
} = ReactNative;

var SGStyles = require('./SGStyles');

var styles = ReactNative.StyleSheet.create({
  loadingContainer: {
    alignItems: 'center',
    justifyContent: 'center',
  },
});

class Common extends React.Component {

	static debug() {
		// set false when release
		return true;
	}

	static domain() {
		return Common.debug() ? 'http://i.momia.cn' : 'http://i.sogokids.com';
	}

	static loading() {

		return (
			<View style={[SGStyles.container, styles.loadingContainer]}>
				<ActivityIndicatorIOS hidden='false'
      								  size='small'/>
      		</View>
		);
	}
}

module.exports = Common;