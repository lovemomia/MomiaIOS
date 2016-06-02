/**
 *
 *  数据请求服务
 *
 **/

'use strict'

import React, {
	Component
} from 'react';

import ReactNative, {
	NativeModules
} from 'react-native';

var RNCommon = NativeModules.RNCommon;

class HttpService extends React.Component {

	/**
	 * - 业务层调用get请求 -
	 *
	 *url :请求地址
	 *params:参数(对象)
	 *callback:回调函数
	 */
	static get(url, params, callback) {
		RNCommon.wrapParams(params, (error, fullParams) => {
			if (error) {
				console.error(error);
			} else {
				var newUrl = url + HttpService.toQueryString(fullParams);
				console.log('Get: ' + newUrl);
				fetch(newUrl)
					.then((response) => response.json())
					.then((responseData) => {
						callback(responseData);
					}).catch((error) => {
						console.warn(error);
					}).done();
			}
		})
	}

	/**
	 * - 业务层调用post请求 -
	 *
	 *url :请求地址
	 *params:参数(对象)
	 *callback:回调函数
	 */
	static post(url, params, callback) {
		RNCommon.wrapParams(params, (error, fullParams) => {
			if (error) {
				console.error(error);
			} else {
				HttpService.postForm(url, fullParams, callback);
			}
		})
	}

	/**
	 * - post请求 -
	 *
	 *url :请求地址
	 *data:参数(Json对象)
	 *callback:回调函数
	 */
	static postJson(url, data, callback) {
		var fetchOptions = {
			method: 'POST',
			headers: {
				'Accept': 'application/json',
				//json形式
				'Content-Type': 'application/json',
				'User-Agent': 'API1.0(com.youxing.DuoLa;React)',
			},
			body: JSON.stringify(data)
		};

		fetch(url, fetchOptions)
			.then((response) => response.text())
			.then((responseText) => {
				callback(JSON.parse(responseText));
			}).catch((error) => {
				console.warn(error);
			}).done();
	}

	/**
	 * - post请求(表单) -
	 *
	 *url :请求地址
	 *data:参数(对象)
	 *callback:回调函数
	 */
	static postForm(url, data, callback) {
		var fetchOptions = {
			method: 'POST',
			headers: {
				'Accept': 'application/json',
				'Content-Type': 'application/x-www-form-urlencoded',
				'User-Agent': 'API1.0(com.youxing.DuoLa;React)',
			},
			body: toQueryString(data)
		};

		fetch(url, fetchOptions)
			.then((response) => response.text())
			.then((responseText) => {
				callback(JSON.parse(responseText));
			}).catch((error) => {
				console.warn(error);
			}).done();
	}

	static toQueryString(obj) {
		return obj ? Object.keys(obj).sort().map(function(key) {
			var val = obj[key];
			if (Array.isArray(val)) {
				return val.sort().map(function(val2) {
					return encodeURIComponent(key) + '=' + encodeURIComponent(val2);
				}).join('&');
			}

			return encodeURIComponent(key) + '=' + encodeURIComponent(val);
		}).join('&') : '';
	}

}

module.exports = HttpService;