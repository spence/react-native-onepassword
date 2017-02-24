'use strict';

var React = require('react-native');
var {
    NativeModules
} = React;

var NativeOnePassword = NativeModules.OnePassword;

var OnePassword = {
    isSupported() {
        return new Promise(function(resolve, reject) {
            NativeOnePassword.isSupported(function(error) {
                if (error) {
                    return reject(error.message);
                }

                resolve(true);
            });
        });
    },

    changeLogin(url, details, generationOptions) {
        return new Promise(function(resolve, reject) {
            NativeOnePassword.changeLogin(url, details, generationOptions, function(error, data) {
                if (error) {
                    return reject(error.message);
                }

                resolve(data);
            })
        });
    },

    findLogin(url) {
        return new Promise(function(resolve, reject) {
            NativeOnePassword.findLogin(url, function(error, data) {
                if (error) {
                    return reject(error.message);
                }

                resolve(data);
            });
        });
    },

    storeLogin(url, details, generationOptions) {
        return new Promise(function(resolve, reject) {
            NativeOnePassword.storeLogin(url, details, generationOptions, function(error, data) {
                if (error) {
                    return reject(error.message);
                }

                resolve(data);
            })
        });
    }
};

module.exports = OnePassword;
