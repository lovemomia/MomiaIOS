'use strict';
console.disableYellowBox = true;

var Common = require('../Common');
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
  loadingCell: {
    alignItems: 'center',
    justifyContent: 'center',
    height: 44
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

class WDQuestionListComponent extends React.Component {
  constructor(props) {
    super(props);
    var ds = new ListView.DataSource({
      rowHasChanged: (r1, r2) => r1 !== r2
    });
    this.state = {
      //用来存放列表数据（{type:'列表类型[1=course, 2=loading]', data:'数据'}）
      dataSource: ds.cloneWithRows([new Array()]),
      isLoading: true,
      hasNextPage: false,
      nextStart: 0
    };
  }

  render() {
    return <View style={SGStyles.container}>
      <ListView 
      dataSource={this.state.dataSource}
      renderRow={this.renderRow.bind(this)}/>
      </View>
  }

  componentDidMount() {
    HttpService.get(Common.domain() + '/v1/wd_questions?', {
      start: 0,
      wid: 0
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

  _loadNextPage() {
    HttpService.get(Common.domain() + '/v1/wd_questions?', {
      start: this.state.nextStart,
      wid: 0
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
    var typeList = new Array(this.state.dataSource);
    var hasNextPage = false;
    var nextStart = 0;
    if (this.state.hasNextPage) {
      typeList.pop(); // pop out the loading cell
    }

    // list
    if (data.hasOwnProperty('list') && data.list.length > 0) {
      for (var i = 0; i < data.list.length; i++) {
        typeList.push({
          type: 1,
          data: data.list[i]
        });
      }
    }

    if (data.hasOwnProperty('nextIndex') && data.nextIndex > 0 && typeList.length >= 20) {
      hasNextPage = true;
      nextStart = data.nextIndex;
      //header
      typeList.push({
        type: 2,
      });
    }

    this.setState({
      isLoading: false,
      dataSource: this.state.dataSource.cloneWithRows(typeList),
      hasNextPage: hasNextPage,
      nextStart: nextStart,
    });
  }

  renderRow(rowData, sectionID, rowID) {
    var rowView;
    if (rowData.type == 1) {
      rowView = <TouchableHighlight onPress={() => this._rowPressed(rowData)}
        underlayColor='#dddddd'>{this._renderQuestionView(rowData.data)}</TouchableHighlight>

    } else if (rowData.type == 2) {
      rowView = this._renderLoading();
    }

    return rowView == null ? <Text style={styles.menu} 
                  numberOfLines={1}></Text> : rowView
  }

  _renderLoading() {
    this._loadNextPage();
    return <View style={[SGStyles.container, styles.loadingCell]}><ActivityIndicatorIOS
      hidden='true'
      size='small'/></View>
  }

  _renderQuestionView(data) {
    return <View><View style={{backgroundColor:'white', padding:10}}>
            <Text style={{fontSize: 15, color: '#333333'}} numberOfLines={1}>{data.content}</Text>
            <Text style={{fontSize: 13, color: '#999999',paddingTop:5}} numberOfLines={1}>{data.expert.name} | {data.expert.intro}</Text>
            <View style={{flexDirection:'row', paddingTop:10, alignItems:'center'}}>
              <Image style={{width: 30, height: 30, borderRadius: 15, marginRight: 5}} source={{uri:data.expert.cover}}/>
              <Image style={{width: 200, height: 30, borderRadius: 15, marginLeft: 10, backgroundColor:'#00c49d', justifyContent: 'center',alignItems: 'center'}}>
                <Text style={{fontSize: 13, color: 'white'}} numberOfLines={1}>1元偷听</Text>
              </Image>
              <Text style={{fontSize: 13, color: '#999999',paddingLeft:5}} numberOfLines={1}>60“</Text>
            </View>
        </View>
        <View style={styles.separator}/>
        </View>
  }

  _rowPressed(rowData) {
    RNCommon.openUrl('wdquestiondetail?id=' + rowData.data.id);
  }

}


ReactNative.AppRegistry.registerComponent('WDQuestionListComponent', () => WDQuestionListComponent);