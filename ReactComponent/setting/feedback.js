'use strict';

var React = require('react');
var ReactNative = require('react-native');
var {
  Text,
  View,
  TextInput,
  TouchableHighlight,
  AlertIOS,
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
	phoneContainer:{
		marginRight:20,
		marginLeft:20,
		alignItems: 'center',
		flexDirection: 'row'
	},
	phoneTextInput:{
		flex:1,
		backgroundColor:'white',
		fontSize: 14,
		height:32,
    marginLeft:10
	},
	commitContainer: {
    padding:10,
		marginRight:50,
		marginLeft:50,
		marginTop:20,
		alignItems: 'center',
    backgroundColor:'#00c49d',
    borderRadius:5
	},
  multiline: {
    marginTop: 20,
		marginBottom: 10,
		marginLeft:20,
		marginRight:20,
		height:80,
		fontSize: 14,
		backgroundColor:'white',
    padding: 4
  },
  text: {
    color:'white'
  }
});

class FeedBackComponent extends React.Component{

  //构造方法
  constructor(props) {
    super(props);
    this.state={comment:'',contact:''};
  }

  //渲染
	render() {
    return (
      <View style={styles.container}>
      <Text style={styles.title}>
      欢迎您提出宝贵的意见和建议，您留下的每个字都将用来改善我们的产品。
      </Text>
      <TextInput
        placeholder="请输入您的反馈意见（200字以内)"
        multiline={true}
        style={styles.multiline}
        maxLength={200}
        ref= "comment"
        onChangeText={(comment) => this.setState({comment})}
        value={this.state.comment}
        autoFocus={true}
        />
      <View
      style={styles.phoneContainer}>
        <Text>
         联系方式
        </Text>
        <TextInput
          style={styles.phoneTextInput}
          placeholder="请输入您的联系方式"
          ref="contact"
          onChangeText={(contact) => this.setState({contact})}
          vale={this.state.contact}
          autoFocus={true} />
      </View>

      <View
      style={styles.commitContainer}>
      <TouchableHighlight
        onPress={this.onPressButton}>
        <Text style={styles.text}>
          提交
        </Text>
      </TouchableHighlight>
      </View>

      </View>
    );
  }

  onPressButton = () => {
    //1,拿到text 2，检查，3，提交
    let comment = this.state.comment;
    let contact = this.state.contact;
    //2 检查
    if(comment.length == 0){
      AlertIOS.alert(null,'评论不能为空！',[{text: '确定', onPress: () => console.log('Foo Pressed!')},]);
      return;
    } else if(contact.length == 0) {
      AlertIOS.alert(null,'联系方式不能为空！',[{text: '确定', onPress: () => console.log('Foo Pressed!')},]);
      return;
    }
    //3 提交

  }
}

ReactNative.AppRegistry.registerComponent('FeedBackComponent', () => FeedBackComponent);
