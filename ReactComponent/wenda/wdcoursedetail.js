'use script';

var React = require('react');
var ReactNative = require('react-native');

var {
	Text,
	View,
	Image,
	ListView,
	AppRegistry,
	NativeModules,
	TouchableHighlight
} = ReactNative;

var ds = new ListView.DataSource({
	rowHasChanged: (r1,r2) => r1!==r2
});

var RNCommon = NativeModules.RNCommon;

var styles = ReactNative.StyleSheet.create({

});

var WendaCourseDetailComponent = React.createClass({

	getDefaultProps: function() {
		return {
			
		};
	},


	getInitialState: function() {
		return {
			dataSource: ds.cloneWithRows([
				{id: 0},{id: 1},{id: 2},{id: 3},{id: 4},{id: 5},{id: 6},{id: 7}
			]) 
		};
	},

	render: function() {
		return (
			<View style={{flex: 1,backgroundColor: '#f1f1f1'}}>
				<View style={{flex: 1}}>
				<ListView
					style={{flex: 1}}
					dataSource={this.state.dataSource}
					renderRow={this._renderRow} />
				</View>
				<TouchableHighlight 
					style={{height: 48, backgroundColor: '#FF6634', justifyContent: 'center',alignItems: 'center'}}
					onPress={() => this._pressAskExpretButton()} >
					<Text>向专家提问</Text>
				</TouchableHighlight>
			</View>
		);
	},

	_renderRow: function(rowData,sectionID,rowID) {

		if (rowID == 0) {

			return this._renderHeaderView();
		} else if( rowID ==1 ) {
			return this._renderReAskQuHeader();
		} else if (rowID == 2|| rowID == 3) {
			return this._renderReAskQuRowItem();
		} else if (rowID == 4) {
			return this._renderReAskQuTailer();
		} else if(rowID == 5) {
			return this._renderExpertIntrHeader();
		} else if(rowID == 6) {
			return this._renderExpertImageWithName();
		} else if(rowID == 7) {
			return this._renderExpertIntrText();
		}
		return (
			<View>
				<Text>Hello CourseComponent!</Text>
			</View>
		);
	},

	_renderHeaderView: function(data) {

		return (
			<View style={{padding: 10,marginTop: 10,backgroundColor: 'white'}}>
				<View style={{flexDirection: 'row',alignItems: 'center'}}>
					<View>
						<Image style={{width: 40,height: 40, backgroundColor: 'red'}}/>
					</View>
					<View style={{marginLeft: 10,flex: 1}}>
						<Text>在孩子教育过程中，如何做到零吼叫？</Text>
						<View style={{flexDirection: 'row'}}>
							<Image style={{width: 20,height: 20, backgroundColor: 'red'}}/>
							<Text>20000次</Text>
							<Image style={{width: 20,height: 20, backgroundColor: 'red'}}/>
							<Text> 20分钟</Text>
						</View>
						<Text>2016年五月一日</Text>
					</View>
					<Image style={{width: 10,height: 10,backgroundColor: 'green'}}/>
				</View>
			</View>
		);
	},

	//渲染互动问答的头部
	_renderReAskQuHeader: function() {

		return (
			<View style={{padding: 10,backgroundColor: 'white',marginTop: 10}}>
				<View style={{flexDirection: 'row'}}>
					<Image style={{height: 20,width: 20,backgroundColor: 'green'}} />
					<Text>互动问答</Text>
				</View>
				<View style={{height: 1,backgroundColor: '#f1f1f1',marginTop: 4}} />
			</View>
		);
	},

	//渲染互动问答RowItem
	_renderReAskQuRowItem: function() {

		return (
			<View style={{padding: 10,backgroundColor: 'white'}}>
				<View>
					<Text>6岁男孩，父母抚养，遇到某些没遇到过的数学题，会直接说我不会做，这个主要是提高自信心吗？</Text>
				</View>
				<View>
					<Text>韩丽娟 | 北师大副教授，儿童教育专家</Text>
				</View>
				<View style={{flexDirection: 'row',alignItems: 'center'}}>
					<Image style={{width: 40,height: 40,backgroundColor:'green',borderRadius: 20}} />
					<View style={{flexDirection: 'row',flex: 1,alignItems: 'center'}}>
						<Image style={{width: 120,height: 40,backgroundColor: 'green',marginLeft: 10}} />
						<Text> 60 '</Text>
					</View>
					<Text>22人听过</Text>
				</View>
				<View style={{height: 1,backgroundColor: '#f1f1f1',marginTop: 6}} />
			</View>
		);
	},

	//渲染互动问答的尾部
	_renderReAskQuTailer: function() {

		return (
			<View style={{height: 48,justifyContent: 'center',alignItems: 'center',backgroundColor: 'white'}}>
				<TouchableHighlight style={{borderRadius: 4,borderWidth: 2,borderColor: 'black',padding: 5}}>
						<Text>查看更多</Text>
				</TouchableHighlight>
			</View>
		);
	},

	//渲染专家介绍的头部
	_renderExpertIntrHeader: function() {

		return (
			<View style={{padding: 10,backgroundColor: 'white',marginTop: 10}}>
				<View style={{flexDirection: 'row'}}>
					<Image style={{height: 20,width: 20,backgroundColor: 'green'}} />
					<Text>专家介绍</Text>
				</View>
				<View style={{height: 1,backgroundColor: '#f1f1f1',marginTop: 4}} />
			</View>
		);
	},

	//渲染专家介绍的头像和名字
	_renderExpertImageWithName: function() {

		return (
			<View style={{alignItems: 'center',backgroundColor: 'white'}}>
				<Image style={{width: 120,height: 120, backgroundColor: 'green'}} />
				<Text>方菁</Text>
			</View>
	    );
	},

	//渲染专家介绍的头像和名字
	_renderExpertIntrText: function() {

		return (
			<View style={{padding: 10,backgroundColor: 'white'}}>
				<Text>1970 年毕业于上海第一医学院医疗系。毕业后留校任中山医院内科住院医师、主治医师、副教授、教授，1986 年开始从事内科重症监护工作。1989 ～ 1990 获 WHO 奖学金赴澳大利亚进修急救医学。2000年任中山医院全科医学科主任，2001年当选为中华医学会全科医学分会委员,兼任复旦大学上海医学院全科医学系主任、硕士研究生导师。临床经验丰富，擅长内科疾病的诊断治疗，尤其是急症、危重病人的诊治。多年来开展各项科研工作，发表论文30余篇。主编《心脏病人的家庭康复》、《休克的基础和临床》等书，目前正在编写《脑卒中病人的家庭康复》</Text>
			</View>
		);
	},

	//渲染更多微课头部
	_renderMoreWDCourseHeader: function() {

		return (
			<View style={{padding: 10,backgroundColor: 'white',marginTop: 10}}>
				<View style={{flexDirection: 'row'}}>
					<Image style={{height: 20,width: 20,backgroundColor: 'green'}} />
					<Text>更多微课</Text>
				</View>
				<View style={{height: 1,backgroundColor: '#f1f1f1',marginTop: 4}} />
			</View>
		);
	},

	//渲染微课Item
	_renderWD
	_pressRowItem: function(rowData) {

	},

	_pressAskExpretButton: function() {

		RNCommon.openUrl('askquestion');
	},

});

AppRegistry.registerComponent('WendaCourseDetailComponent', () => WendaCourseDetailComponent);