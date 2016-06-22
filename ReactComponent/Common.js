'use strict';

import React, {
	Component
} from 'react';



class Common extends React.Component {

	static debug() {
		// set false when release
		return true;
	}

	static domain() {
		return Common.debug() ? 'http://i.momia.cn' : 'http://i.sogokids.com';
	}
}


module.exports = Common;