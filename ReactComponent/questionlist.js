'use strict';
console.disableYellowBox = true;

var SGStyles = require('../SGStyles');
var HttpService = require('../HttpService');
var Swiper = require('react-native-swiper')

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

var styles = ReactNative.StyleSheet.create({
  loadingContainer: {
    alignItems: 'center',
    justifyContent: 'center',
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
  subject_cover: {
    height: Dimensions.get('window').width * 180 / 320,
  },
  subject: {
    backgroundColor: 'white',
    flexDirection: 'column',
  },
  subject_title: {
    paddingTop: 10,
    paddingBottom: 20,
    alignItems: 'center',
    justifyContent: 'center',
    flexDirection: 'row',
  },
  subject_course_icon: {
    width: 80,
    height: 80,
    borderWidth: 1,
    borderRadius: 40,
    borderColor: '#555555'
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
      isLoading: true
    };
  }

  render() {
    return this.state.isLoading ? (<View style={[SGStyles.container, styles.loadingContainer]}><ActivityIndicatorIOS
      hidden='true'
      size='small'/></View>) : <View style={SGStyles.container}>
      <ListView 
      dataSource={this.state.dataSource}
      renderRow={this.renderRow.bind(this)}/>
      </View>
  }

  componentDidMount() {
    HttpService.get('http://i.momia.cn/v1/wd_home?', {
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
        if (i >= 3) {
          typeList.push({
            type: 5 //more
          });
          break;
        }
        typeList.push({
          type: 3,
          data: data.wdcourses[i]
        });
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
        <View style={styles.footer}/>
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
      <View style={styles.footer}/></View>
    }
  }

  _renderHeaderView(data) {
    return <View style={{height:44}}>
        <View style={styles.footer}/>
        <View style={styles.separator}/>
        <View style={{flex:1}}>
          <Text style={{fontSize: 15, color: '#333333',paddingLeft:5,paddingRight:5,textAlign:'left'}} numberOfLines={1}>{data}</Text></View>
        <View style={styles.separator}/>
      </View>
  }

  _renderCourseView(data) {
    return <View style={{flex:1}}>
        <View style={{flexDirection:'row', alignItems:'center'}}>
          <Image style={{width: 50, height: 50, borderRadius: 25}} source={{uri:events[0].img}}/>
          <Text style={{fontSize: 15, color: '#333333',paddingLeft:5,paddingRight:5}} numberOfLines={1}>韩丽娟</Text>
        </View>
        <View style={{flexDirection:'row'}}>
          <Text style={{fontSize: 15, color: '#333333',paddingLeft:5,paddingRight:5}} numberOfLines={1}>在孩子教育过程中...</Text>
          <Text style={{fontSize: 13, color: '#999999',paddingLeft:5,paddingRight:5}} numberOfLines={1}>美国宾西法利亚..</Text>
            <View>
              <Text style={{fontSize: 13, color: '#999999',paddingLeft:5,paddingRight:5}} numberOfLines={1}>20000次</Text>
              <Text style={{fontSize: 13, color: '#999999',paddingLeft:5,paddingRight:5}} numberOfLines={1}>50分钟</Text></View>
        </View>
        <View style={styles.separator}/>

      </View>
  }

  _renderQuestionView(data) {
    return <View style={{flexDirection:'row'}}>
            <Text style={{fontSize: 15, color: '#333333',paddingLeft:5,paddingRight:5}} numberOfLines={1}>在孩子教育过程中...</Text>
            <Text style={{fontSize: 13, color: '#999999',paddingLeft:5,paddingRight:5}} numberOfLines={1}>韩丽娟 ｜ 北师大副教授</Text>
            <View>
              <Image style={{width: 30, height: 30, borderRadius: 15, marginRight: 5}} source={{uri:events[0].img}}/>
              <Text style={{fontSize: 13, color: '#999999',paddingLeft:5,paddingRight:5}} numberOfLines={1}>1元偷听</Text>
              <Text style={{fontSize: 13, color: '#999999',paddingLeft:5,paddingRight:5}} numberOfLines={1}>60“</Text>
            </View>
          <View style={styles.separator}/>
        </View>
  }

  _renderMoreView() {
    return <View style={{height:44}}>
        <View style={{flex:1, alignItems: 'center', justifyContent: 'center'}}>
          <View style={{borderRadius:3, borderWidth:1, marginTop:10}}>
            <Text style={{fontSize: 13, color: '#333333', paddingTop:3, paddingLeft:3, paddingRight:3, textAlign:'center'}} numberOfLines={1}>查看更多</Text>
          </View>
        </View>
        <View style={styles.separator}/>
      </View>
  }

  _rowPressed(rowData) {
    if (rowData.type == 3) {
      RNCommon.openUrl('subjectdetail?id=' + rowData.data.id);
    } else if (rowData.type == 5) {
      var url = 'http://' + (this.props._debug == '0' ? 'm.sogokids.com' : 'm.momia.cn' + '/discuss/topic?id=' + rowData.data.id);
      RNCommon.openUrl('web?url=' + encodeURIComponent(url));
    } else if (rowData.type == 6) {
      Linking.openURL(rowData.data.action);
    }
  }

}


ReactNative.AppRegistry.registerComponent('WDHomeComponent', () => WDHomeComponent);