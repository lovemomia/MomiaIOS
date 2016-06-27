'use strict';
console.disableYellowBox = true;

var Common = require('../Common');
var SGStyles = require('../SGStyles');
var HttpService = require('../HttpService');
var Swiper = require('react-native-swiper')
var LoadingEffect = require('react-native-loading-effect');

var React = require('react');
var {
  PropTypes,
} = React;

var ReactNative = require('react-native');
var {
  Text,
  ListView,
  View,
  Image,
  TouchableHighlight,
  Linking,
  ActivityIndicatorIOS,
  NativeModules,
  Dimensions
} = ReactNative;

var RNCommon = NativeModules.RNCommon;
var WendaPayManager = NativeModules.WendaPayManager;

var styles = ReactNative.StyleSheet.create({
  loadingContainer: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  floatView: {
    position: 'absolute',
    top: (Dimensions.get('window').height) / 2 - 100,
    left: Dimensions.get('window').width / 2 - 40,

  },
  footer: {
    height: 10,
    backgroundColor: '#f1f1f1'
  },
  rowContainer: {
    backgroundColor: 'white'
  },
  separator: {
    height: 0.5,
    backgroundColor: '#dddddd'
  },
  menu: {
    fontSize: 14,
    color: '#333333'
  },
  wrapper: {

  },
});

class WDHomeComponent extends React.Component {
  constructor(props) {
    super(props);
    var ds = new ListView.DataSource({
      rowHasChanged: (r1, r2) => r1 !== r2
    });
    this.state = {
      //用来存放列表数据（{type:'列表类型[1=banner, 2=header, 3=course, 4=question, 5=more]', data:'数据'}）
      dataSource: ds.cloneWithRows([new Array()]),
      isLoading: true,
      isLoadingDialogVisible: false,
    };
  }

  render() {
    return this.state.isLoading ? <View style={[SGStyles.container, styles.loadingContainer]}><ActivityIndicatorIOS
      hidden='true'
      size='small'/></View> : (<View style={SGStyles.container}>
      <ListView 
      dataSource={this.state.dataSource}
      renderRow={this.renderRow.bind(this)}>
      </ListView>
      <View style={[SGStyles.container, styles.floatView]}>
        <LoadingEffect isVisible={this.state.isLoadingDialogVisible} text='加载中...'/>
      </View>
      </View>);
  }

  _showLoadingEffect() {
    this.setState({
      isLoadingDialogVisible: true
    });
  }

  _dismissLoadingEffect() {
    this.setState({
      isLoadingDialogVisible: false
    });
  }

  componentDidMount() {
    HttpService.get(Common.domain() + '/v1/wd_home?', {
      start: 0
    }, (resp) => {
      if (resp.errno == 0) {
        this._handlerResponse(resp.data);
      } else {
        // request failed
        this.setState({
          isLoading: false
        });
      }

      console.log(resp);
    });
  }

  //将网络请求数据解析成列表数据
  _handlerResponse(data) {
    var typeList = new Array();

    // banner
    if (data.hasOwnProperty('banners') && data.banners.length > 0) {
      typeList.push({
        type: 1,
        data: data.banners
      });
    }

    //header
    typeList.push({
      type: 2,
      data: '听微课'
    });

    //courses
    if (data.hasOwnProperty('wdcourses') && data.wdcourses.length > 0) {
      for (var i = 0; i < data.wdcourses.length; i++) {
        typeList.push({
          type: 3,
          data: data.wdcourses[i]
        });
        if (i >= 2) {
          typeList.push({
            type: 5, //more
            data: '听微课'
          });
          break;
        }
      }
    }

    //header
    typeList.push({
      type: 2,
      data: '问专家'
    });

    //questions
    if (data.hasOwnProperty('questions') && data.questions.length > 0) {
      for (var i = 0; i < data.questions.length; i++) {
        typeList.push({
          type: 4,
          data: data.questions[i]
        });
        if (i >= 2) {
          typeList.push({
            type: 5, //more
            data: '问专家'
          });
          break;
        }
      }
    }

    this.setState({
      isLoading: false,
      dataSource: this.state.dataSource.cloneWithRows(typeList),
    });
  }

  renderSectionHeader() {
    return <View style={styles.footer}/>;
  }

  renderRow(rowData, sectionID, rowID) {
    var rowView;
    if (rowData.type == 1) {
      rowView = this._renderBannelsView(rowData.data);

    } else if (rowData.type == 2) {
      rowView = this._renderHeaderView(rowData.data);

    } else if (rowData.type == 3) {
      rowView = <TouchableHighlight onPress={() => this._rowPressed(rowData)}
        underlayColor='#dddddd'>{this._renderCourseView(rowData.data)}</TouchableHighlight>

    } else if (rowData.type == 4) {
      rowView = <TouchableHighlight onPress={() => this._rowPressed(rowData)}
        underlayColor='#dddddd'>{this._renderQuestionView(rowData.data)}</TouchableHighlight>

    } else if (rowData.type == 5) {
      rowView = <TouchableHighlight onPress={() => this._rowPressed(rowData)}
        underlayColor='#dddddd'>{this._renderMoreView()}</TouchableHighlight>

    }

    return rowView == null ? <Text style={styles.menu} 
                  numberOfLines={1}></Text> : rowView
  }

  _renderBannelsView(banners) {
    if (banners.length == 1) {
      // on Android it's not work when only one item for using Swiper
      return <View style={{height:(Dimensions.get('window').width * 180 / 320)}}>
        <TouchableHighlight style={{flex:1}} onPress={() => {Linking.openURL(banners[0].action)}} underlayColor='#ffffff'>
          <Image style={{flex: 1, backgroundColor:'#000000'}} source={{uri:banners[0].cover}}/></TouchableHighlight>
        <View style={styles.separator}/>
      </View>

    } else {
      var dot = <View style={{backgroundColor:'rgba(0,0,0,.2)', width: 5, height: 5,borderRadius: 4, marginLeft: 3, marginRight: 3, marginTop: 3, marginBottom: 3,}} />;
      var activeDot = <View style={{backgroundColor: '#00c49d', width: 6, height: 6, borderRadius: 4, marginLeft: 3, marginRight: 3, marginTop: 3, marginBottom: 3,}} />;
      return <View style={styles.wrapper}><Swiper style={styles.wrapper} height={(Dimensions.get('window').width * 180 / 320)}
    showsButtons={false} autoplay={true} dot={dot} activeDot={activeDot} loop={true}>
        {banners.map(function(val, index){
        return <TouchableHighlight style={{flex:1}} onPress={() => {Linking.openURL(banners[index].action)}} underlayColor='#ffffff'>
          <Image style={{flex: 1, backgroundColor:'#000000'}} source={{uri:banners[index].cover}}/></TouchableHighlight>
        })}
      </Swiper>
      <View style={styles.separator}/>
      </View>
    }
  }

  _renderHeaderView(data) {
    return <View style={{height:44, backgroundColor:'white'}}>
        <View style={styles.footer}/>
        <View style={styles.separator}/>
        <View style={{flex:1,justifyContent: 'center'}}>
          <Text style={{fontSize: 15, color: '#00c49d',paddingLeft:5,paddingRight:5,textAlign:'left'}} numberOfLines={1}>{data}</Text></View>
        <View style={styles.separator}/>
      </View>
  }

  _renderCourseView(data) {
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
  }

  _renderQuestionView(data) {
    return <View><View style={{backgroundColor:'white', padding:10}}>
            <Text style={{fontSize: 15, color: '#333333'}} numberOfLines={1}>{data.content}</Text>
            <Text style={{fontSize: 13, color: '#999999',paddingTop:5}} numberOfLines={1}>{data.expert.name} | {data.expert.intro}</Text>
            <View style={{flexDirection:'row', paddingTop:10, alignItems:'center'}}>
              <Image style={{width: 30, height: 30, borderRadius: 15, marginRight: 5}} source={{uri:data.expert.cover}}/>
              <TouchableHighlight onPress={() => this._answerPressed(data)}>
                <Image style={{width: 200, height: 30, borderRadius: 15, marginLeft: 10, backgroundColor:'#00c49d', justifyContent: 'center',alignItems: 'center'}}>
                  <Text style={{fontSize: 13, color: 'white'}} numberOfLines={1}>1元偷听</Text>
                </Image>
              </TouchableHighlight>
              <Text style={{fontSize: 13, color: '#999999',paddingLeft:5}} numberOfLines={1}>60“</Text>
            </View>
        </View>
        <View style={styles.separator}/>
        </View>
  }

  _renderMoreView() {
    return <View style={{height:44, backgroundColor:'white'}}>
        <View style={{flex:1, alignItems: 'center', justifyContent: 'center'}}>
          <View style={{borderRadius:3, borderWidth:1}}>
            <Text style={{fontSize: 13, color: '#333333', paddingTop:3, paddingLeft:3, paddingRight:3, paddingBottom:3}} numberOfLines={1}>查看更多</Text>
          </View>
        </View>
        <View style={styles.separator}/>
      </View>
  }

  _rowPressed(rowData) {
    if (rowData.type == 3) { //微课
      RNCommon.openUrl('wdcoursedetail?id=' + rowData.data.id);
    } else if (rowData.type == 4) { //问专家
      RNCommon.openUrl('wdquestiondetail?id=' + rowData.data.id);
    } else if (rowData.type == 5) { //更多
      if (rowData.data === '听微课') {
        RNCommon.openUrl('wdcourselist'); //微课列表
      } else {
        RNCommon.openUrl('wdquestionlist'); //问题列表
      }
    }
  }

  _answerPressed(question) {
    RNCommon.isLogin((error, dic) => {
      if (error) {
        console.error(error);
      } else if (dic.isLogin === 'true') {
        this._requestQuestion(question.id);

      } else {
        RNCommon.openUrl('login');
      }
    });
  }

  _requestQuestion(questionId) {
    this._showLoadingEffect();
    HttpService.get(Common.domain() + '/v1/wd_hJoin?', {
      qid: questionId
    }, (resp) => {
      this._dismissLoadingEffect();
      if (resp.errno == 0) {
        //判断结果是否可以直接播放了
        if (resp.data.hasOwnProperty('question')) {
          //TODO 直接播放


        } else {
          //支付订单
          WendaPayManager.pay(resp.data.order, (error, payResult) => {

          });
        }

      } else {
        // request failed

      }
    });
  }

}


ReactNative.AppRegistry.registerComponent('WDHomeComponent', () => WDHomeComponent);