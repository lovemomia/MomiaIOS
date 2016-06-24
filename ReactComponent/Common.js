'use strict';

import React, {
	Component
} from 'react';

var ReactNative = require('react-native');

var {
	View,
	ActivityIndicatorIOS,
	TouchableHighlight,
	View,
	Text,
	Image,
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

	static courseCell(data,onClick) {

		return (
			<TouchableHighlight
				onPress={onClick}
				underlayColor = '#f1f1f1'>
			<View style={{padding: 10,backgroundColor: 'white'}}>
				<View style={{flexDirection: 'row',alignItems: 'center'}}>
					<View>
						<Image style={{width: 50,height: 50, alignItems: 'center',justifyContent: 'center'}}
							   source={{uri: data.cover}}>
							   <Image style={{width: 30,height: 30}}
							   		  source={require('./common/image/play.png')} />
					    </Image>
					</View>
					<View style={{marginLeft: 10,flex: 1}}>
						<Text style={{fontSize: 13}}>{data.title}</Text>
						<View style={{flexDirection: 'row',alignItems: 'center',marginTop: 5}}>
							<Image style={{width: 15,height: 15}}
								   source={require('./common/image/count.png')}/>
							<Text style={{fontSize: 11, color: '#999999'}}>{data.count}次</Text>
							<Image style={{width: 15,height: 15,marginLeft: 10}}
								   source={require('./common/image/time.png')}/>
							<Text style={{fontSize: 11, color: '#999999'}}> {data.mins}分钟</Text>
						</View>
						<Text style={{fontSize: 11, color: '#999999',marginTop: 5}}>{data.startTime}</Text>
					</View>
				</View>
			</View>
			</TouchableHighlight>
		);
	}
}

module.exports = Common;