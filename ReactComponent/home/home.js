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

class HomeComponent extends React.Component {
  constructor(props) {
    super(props);
    var ds = new ListView.DataSource({
      rowHasChanged: (r1, r2) => r1 !== r2
    });
    this.state = {
      //用来存放列表数据（{type:'列表类型[1=banner, 2=event, 3=subject_cover, 4=subject, 5=topic, 6=recommend]', data:'数据'}）
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
    HttpService.get('http://i.momia.cn/v3/index?', {
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

    //event
    if (data.hasOwnProperty('events') && data.events.length == 2) {
      typeList.push({
        type: 2,
        data: data //注意：这里直接把整个data设置进去
      });
    }

    //subject
    if (data.hasOwnProperty('subjects') && data.subjects.length > 0) {
      for (var i = 0; i < data.subjects.length; i++) {
        typeList.push({
          type: 3,
          data: data.subjects[i]
        });
        typeList.push({
          type: 4,
          data: data.subjects[i]
        });
        if (data.hasOwnProperty('topics') && i < data.topics.length) {
          typeList.push({
            type: 5,
            data: data.topics[i]
          });
        }
      }
    }

    //recommend
    if (data.hasOwnProperty('recommends') && data.recommends.length > 0) {
      for (var i = 0; i < data.recommends.length; i++) {
        typeList.push({
          type: 6,
          data: data.recommends[i]
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
      rowView = this._renderEventView(rowData.data);

    } else if (rowData.type == 3) {
      rowView = <TouchableHighlight onPress={() => this._rowPressed(rowData)}
        underlayColor='#dddddd'>{this._renderSubjectCoverView(rowData.data)}</TouchableHighlight>

    } else if (rowData.type == 4) {
      rowView = this._renderSubjectView(rowData.data)

    } else if (rowData.type == 5) {
      rowView = <TouchableHighlight onPress={() => this._rowPressed(rowData)}
        underlayColor='#dddddd'>{this._renderTopicView(rowData.data)}</TouchableHighlight>

    } else if (rowData.type == 6) {
      rowView = <TouchableHighlight onPress={() => this._rowPressed(rowData)}
        underlayColor='#dddddd'>{this._renderRecommendView(rowData.data)}</TouchableHighlight>
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

  _renderEventView(data) {
    var events = data.events;
    var eventsTitle = data.eventsTitle;
    return <View style={styles.subject}>
        <View style={styles.subject_title}>
          <Image style={{width: 12, height: 4}} source={require('./img/IconWave.png')}/>
          <Text style={{fontSize: 15, color: '#333333',paddingLeft:5,paddingRight:5,textAlign:'center'}} numberOfLines={1}>{eventsTitle}</Text>
          <Image style={{width: 12, height: 4}} source={require('./img/IconWave.png')}/>
        </View>
        <View style={{flexDirection:'row'}}>
          <TouchableHighlight style={{flex:1}} onPress={() => {Linking.openURL(events[0].action)}} underlayColor='#ffffff'>
            <View style={{flex:1, padding:10, flexDirection:'row', alignItems:'center'}}>
              <View style={{flex:1}}>
                 <Text style={{fontSize: 14, color: '#333333'}} 
                  numberOfLines={1}>{events[0].title}</Text>
                 <Text style={{fontSize: 11, color: '#F67531', paddingTop:5}}
                  numberOfLines={1}>{events[0].desc}</Text>
              </View>
              <Image style={{width: 50, height: 50, borderRadius: 25}} source={{uri:events[0].img}}/>
            </View>
          </TouchableHighlight>
          <View style={{width:1, backgroundColor:'#EEEEEE', marginBottom:10}}/>
          <TouchableHighlight style={{flex:1}} onPress={() => {Linking.openURL(events[1].action)}} underlayColor='#ffffff'>
            <View style={{flex:1, padding:10, flexDirection:'row', alignItems:'center'}}>
              <View style={{flex:1}}>
                 <Text style={{fontSize: 14, color: '#333333'}} 
                  numberOfLines={1}>{events[1].title}</Text>
                 <Text style={{fontSize: 11, color: '#00C49D', paddingTop:5}}
                  numberOfLines={1}>{events[1].desc}</Text>
              </View>
              <Image style={{width: 50, height: 50, borderRadius: 25}} source={{uri:events[1].img}}/>
            </View>
          </TouchableHighlight>
        </View>
        <View style = {styles.separator}/>
        <View style={styles.footer}/>
    </View>
  }

  _renderSubjectCoverView(subject) {
    return <View style={styles.subject_cover}><Image style={{flex:1}} source={{uri:subject.cover}}/>
        <View style={styles.separator}/>
        <View style={styles.footer}/></View>
  }

  _renderSubjectView(subject) {
    return <View style={styles.subject}>
        <View style={styles.subject_title}>
          <Image style={{width: 12, height: 4}} source={require('./img/IconWave.png')}/>
          <Text style={{fontSize: 15, color: '#333333',paddingLeft:5,paddingRight:5,textAlign:'center'}} numberOfLines={1}>{subject.coursesTitle}</Text>
          <Image style={{width: 12, height: 4}} source={require('./img/IconWave.png')}/>
        </View>
        <View style={{flexDirection:'row'}}>
        {
          subject.courses.map(function(val, index){
        return <TouchableHighlight style={{flex:1, alignItems:'center'}} 
        onPress={() => {RNCommon.openUrl('coursedetail?id='+subject.courses[index].id)}} underlayColor='#ffffff'>
            <View style={{flex:1, alignItems:'center'}}>
                 <Image style={{width: 80, height: 80, borderRadius: 40}} source={{uri:subject.courses[index].cover}}/>
                 <Text style={{fontSize: 14, color: '#333333', marginTop:10,textAlign:'center'}} 
                  numberOfLines={1}>{subject.courses[index].keyWord}</Text>
                 <Text style={{fontSize: 12, color: '#FF6633', marginTop:5,textAlign:'center'}}
                  numberOfLines={1}>{subject.courses[index].age}</Text>
                 <Text style={{fontSize: 12, color: '#999999', marginTop:5, paddingBottom:10,textAlign:'center'}}
                  numberOfLines={1}>{subject.courses[index].feature}</Text>
            </View></TouchableHighlight>
          })
        }</View>
        <View style = {styles.separator}/>
        <View style={styles.footer}/>
    </View>
  }

  _renderTopicView(topic) {
    return <View style={styles.subject}>
        <View style={{paddingTop: 20, paddingBottom: 20, alignItems: 'center', justifyContent: 'center',}}>
          <Image style={{width: 43, height: 26}} source={require('./img/IconTopic.png')}/>
          <Text style={{fontSize: 15, color: '#333333', textAlign:'center',marginTop:10}} numberOfLines={1}>{topic.title}</Text>
          <View style={{paddingTop: 10, paddingBottom: 10, alignItems: 'center', justifyContent: 'center', flexDirection: 'row'}}>
          <View style={{width: 30, height: 1, backgroundColor:'#EEEEEE'}}/>
            <Text style={{fontSize: 13, color: '#999999',paddingLeft:10,paddingRight:10,textAlign:'center'}} numberOfLines={1}>{topic.subTitle}</Text>
            <View style={{width: 30, height: 1, backgroundColor:'#EEEEEE'}}/>
          </View>
          <Image style={{width: 35, height: 33}} source={require('./img/IconSongguo.png')}/>
          <View style={{borderRadius:3, borderWidth:1, marginTop:10}}>
            <Text style={{fontSize: 13, color: '#333333', paddingTop:3, paddingLeft:3, paddingRight:3, textAlign:'center'}} numberOfLines={1}>{topic.joined}人在讨论</Text>
          </View>
        </View>
        <View style = {styles.separator}/>
        <View style={styles.footer}/>
      </View>
  }

  _renderRecommendView(recommend) {
    return <View style={styles.rowContainer}>
             <View style={{flex:1, padding:10, flexDirection:'row', alignItems:'center'}}>
              <Image style={{width: 120, height: 90, borderRadius:3}} source={{uri:recommend.cover}}/>
              <View style={{flex:1, paddingLeft:10}}>
                 <Text style={{fontSize: 15, color: '#333333', lineHeight:20}} 
                  numberOfLines={2}>{recommend.title}</Text>
                 <Text style={{fontSize: 13, color: '#999999', paddingTop:15}}
                  numberOfLines={3}>{recommend.desc}</Text>
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


ReactNative.AppRegistry.registerComponent('HomeComponent', () => HomeComponent);