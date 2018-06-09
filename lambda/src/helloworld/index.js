'use strict';

console.log('Loading function');

exports.handler = (event, context, callback) => {
    console.log('Received event:', JSON.stringify(event, null, 2));
    console.log("Hello World!");
    console.log("Hello World v2");
    callback(null);
};