'use strict';

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
    if (data.hasOwnProperty('events') && data.events.length > 0) {
      typeList.push({
        type: 2,
        data: data.events
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
            data: data.subjects[i]
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
    if (rowData.type == 1) {
      return this._renderBannelsView(rowData.data);

    } else if (rowData.type == 2) {
      return this._renderEventView(rowData.data);
    } else if (rowData.type == 3) {
      return this._renderSubjectCoverView(rowData.data);
    } else if (rowData.type == 4) {
      return this._renderSubjectView(rowData.data);
    }
    return <Text style={styles.menu} 
                  numberOfLines={1}>haha</Text>
  }

  _renderBannelsView(banners) {
    var dot = <View style={{backgroundColor:'rgba(0,0,0,.2)', width: 5, height: 5,borderRadius: 4, marginLeft: 3, marginRight: 3, marginTop: 3, marginBottom: 3,}} />;
    var activeDot = <View style={{backgroundColor: '#00c49d', width: 6, height: 6, borderRadius: 4, marginLeft: 3, marginRight: 3, marginTop: 3, marginBottom: 3,}} />;
    return <View style={styles.wrapper}><Swiper style={styles.wrapper} height={(Dimensions.get('window').width * 180 / 320)}
    showsButtons={false} autoplay={true} dot={dot} activeDot={activeDot} loop={true}>
        {banners.map(function(val, index){
          return <Image style={{flex: 1, backgroundColor:'#000000'}} source={{uri:banners[index].cover}}/>
        })}
      </Swiper>
      <View style={styles.separator}/>
        <View style={styles.footer}/></View>
  }

  _renderEventView(events) {
    return <Text style={styles.menu} 
                  numberOfLines={1}>haha</Text>
  }

  _renderSubjectCoverView(subject) {
    return <View style={styles.subject_cover}><Image style={{flex:1}} source={{uri:subject.cover}}/>
        <View style={styles.separator}/>
        <View style={styles.footer}/></View>
  }

  _renderSubjectView(subject) {
    return <View style={styles.subject}>
        <View style={styles.subject_title}>
            <Image style={{width: 12, height: 4}} source={{uri:'IconWave'}}/>
            <Text style={{fontSize: 15, color: '#333333',paddingLeft:5,paddingRight:5}} numberOfLines={1}>{subject.coursesTitle}</Text>
            <Image style={{width: 12, height: 4}} source={{uri:'IconWave'}}/>
        </View>
        <View style={{flexDirection:'row'}}>
        {
          subject.courses.map(function(val, index){
        return <View style={{flex:1, alignItems:'center'}}>
                 <Image style={{width: 80, height: 80, borderRadius: 40}} source={{uri:subject.courses[index].cover}}/>
                 <Text style={{fontSize: 14, color: '#333333', paddingTop:10}} 
                  numberOfLines={1}>{subject.courses[index].keyWord}</Text>
                  <Text style={{fontSize: 12, color: '#FF6633', paddingTop:5}}
                  numberOfLines={1}>{subject.courses[index].age}</Text>
                  <Text style={{fontSize: 12, color: '#999999', paddingTop:5, paddingBottom:10}}
                  numberOfLines={1}>{subject.courses[index].feature}</Text>
            </View>
          })
        }</View>
        <View style = {styles.separator}/>
        <View style={styles.footer}/>
    </View>
  }

  rowPressed(data) {
    RNCommon.setChoosedCity(data);
    RNCommon.dismissViewControllerAnimated(true);
  }

}


ReactNative.AppRegistry.registerComponent('HomeComponent', () => HomeComponent);