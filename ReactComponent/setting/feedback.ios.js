'use strict';

var React = require('react');
var ReactNative = require('react-native');
var {
  Text,
  View,
  TextInput,
  TouchableHighlight,
} = ReactNative;

var styles = ReactNative.StyleSheet.create({
	container:{
		flex: 1,
		backgroundColor: '#f1f1f1',
		height:120
	},
	title:{
		marginTop: 20,
		marginLeft:20,
		marginRight:20,
		fontSize: 15,
		color: '#666666'
	},
	input:{
		marginTop: 20,
		marginBottom: 10,
		marginLeft:20,
		marginRight:20,
		height:80,
		fontSize: 15,
		backgroundColor:'white'
	},
	phoneContainer:{
		marginRight:20,
		marginLeft:20,
		alignItems: 'center',
		flexDirection: 'row'
	},
	phoneTextInput:{
		flex:1,
		backgroundColor:'white',
		fontSize: 15,
		height:32
	},
	commitContainer:{
		marginRight:20,
		marginLeft:20,
		marginTop:20,
		alignItems: 'center',
	}
});

class FeedBackComponent extends React.Component{
	render() {
    return (
      <View style={styles.container}>
      <Text style={styles.title}>
      欢迎您提出宝贵的意见和建议，您留下的每个字都将用来改善我们的产品。
      </Text>
      <TextInput placeholder="请输入您的反馈意见（200字以内）" style={styles.input}
      multiline={true} autoCorrect={false} autoCapitalize="none"/>

      <View style={styles.phoneContainer}>
        <Text>
         联系方式
        </Text>
        <TextInput style={styles.phoneTextInput} placeholder="请输入您的联系方式" />
      </View>

      <View style={styles.commitContainer}>
      <TouchableHighlight>
      <Text>
      提交
      </Text>
      </TouchableHighlight>
      </View>

      </View>
    );
  }
}

ReactNative.AppRegistry.registerComponent('FeedBackComponent', () => FeedBackComponent);