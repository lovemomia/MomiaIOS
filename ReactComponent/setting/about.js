'use strict';

var SGStyles = require('../SGStyles');

var React = require('react');
var {
  PropTypes
} = React;

var ReactNative = require('react-native');
var {
  Text,
  ListView,
  View,
  Image,
  TouchableHighlight,
  Linking
} = ReactNative;

var styles = ReactNative.StyleSheet.create({
  logo: {
    width: 80,
    height: 80,
    marginTop: 20
  },
  title: {
    marginTop: 10,
    marginBottom: 10,
    fontSize: 14,
    color: '#666666'
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

class AboutComponent extends React.Component {
  constructor(props) {
    super(props);
    var ds = new ListView.DataSource({
      rowHasChanged: (r1, r2) => r1 !== r2
    });
    this.state = {
      dataSource: ds.cloneWithRows([{
        index: 0,
        title: '喜欢我们，打分鼓励'
      }, {
        index: 1,
        title: '用户协议'
      }]),
    };
  }

  render() {
    return (
      <View style={SGStyles.container}>
      <ListView 
      dataSource={this.state.dataSource} 
      renderHeader = {this.renderHeader.bind(this)}
      renderRow={this.renderRow.bind(this)}/>
      </View>
    );
  }

  renderHeader() {
    return <View style={{flexDirection: 'column', alignItems:'center'}}>
        <Image
          style={styles.logo}
          source={{uri: 'IconCircleLogo'}}
        />
        <Text style={styles.title}>当前版本：V{this.props.version}</Text>
      </View>;
  }

  renderRow(rowData, sectionID, rowID) {
    return (
      <TouchableHighlight onPress={() => this._rowPressed(rowData.index)}
        underlayColor='#dddddd'>
      <View>
        <View style={styles.rowContainer}>
          <Text style={styles.menu} 
                  numberOfLines={1}>{rowData.title}</Text>
        </View>
        <View style={styles.separator}/>
      </View>
    </TouchableHighlight>
    );
  }

  _rowPressed(index) {
    if (index == 0) {
      Linking.openURL('https://itunes.apple.com/cn/app/apple-store/id1019473117?mt=8');
    } else if (index == 1) {
      Linking.openURL('duoladebug://web?url=' + encodeURI('http://www.sogokids.com/agreement.html'));

    }
  }

}


ReactNative.AppRegistry.registerComponent('AboutComponent', () => AboutComponent);