'use strict';

var SGStyles = require('../SGStyles');
var HttpService = require('../HttpService');

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
} = ReactNative;

var RNCommon = NativeModules.RNCommon;

var styles = ReactNative.StyleSheet.create({
  loadingContainer: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  header: {
    paddingLeft: 10,
    paddingTop: 15,
    paddingBottom: 15,
    height: 44,
    fontSize: 13,
    color: '#666666'
  },
  footer: {
    padding: 20,
    fontSize: 13,
    color: '#666666',
    textAlign: 'center'
  },
  rowContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 10,
    height: 44,
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
});

class CityListComponent extends React.Component {
  constructor(props) {
    super(props);
    var ds = new ListView.DataSource({
      rowHasChanged: (r1, r2) => r1 !== r2
    });
    this.state = {
      dataSource: ds.cloneWithRows([{
        id: 0,
        name: '上海'
      }, {
        id: 1,
        name: '北京'
      }]),
      isLoading: true
    };
  }

  render() {
    return this.state.isLoading ? (<View style={[SGStyles.container, styles.loadingContainer]}><ActivityIndicatorIOS
      hidden='true'
      size='small'/></View>) : <View style={SGStyles.container}>
      <ListView 
      dataSource={this.state.dataSource} 
      renderHeader = {this.renderHeader.bind(this)}
      renderFooter = {this.renderFooter.bind(this)}
      renderRow={this.renderRow.bind(this)}/>
      </View>
  }

  componentDidMount() {
    var params = {
      channel: this.props._channel,
      city: this.props._city,
      device: this.props._device,
      net: this.props._net,
      os: this.props._os,
      terminal: this.props._terminal,
      utoken: this.props._utoken,
      v: this.props._v
    };
    HttpService.get('http://i.momia.cn/city?', null, (resp) => {
      if (resp.errno == 0) {
        this.setState({
          isLoading: false,
          dataSource: this.state.dataSource.cloneWithRows(resp.data),
        });
      } else {
        // request failed
        this.setState({
          isLoading: false
        });
      }

      console.log(resp);
    });
  }

  renderHeader() {
    return <Text style={styles.header}>已开通城市列表</Text>;
  }

  renderFooter() {
    return <Text style={styles.footer}>更多城市即将开通</Text>;
  }

  renderRow(rowData, sectionID, rowID) {
    return (
      <TouchableHighlight onPress={() => this._rowPressed(rowData)}
        underlayColor='#dddddd'>
      <View>
        <View style={styles.rowContainer}>
          <Text style={styles.menu} 
                  numberOfLines={1}>{rowData.name}</Text>
        </View>
        <View style={styles.separator}/>
      </View>
    </TouchableHighlight>
    );
  }

  _rowPressed(data) {
    RNCommon.setChoosedCity(data);
    RNCommon.dismissViewControllerAnimated(true);
  }

}


ReactNative.AppRegistry.registerComponent('CityListComponent', () => CityListComponent);