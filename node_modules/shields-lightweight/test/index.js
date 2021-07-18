//var fs = require('fs');
var shields = require('../');

describe('shields lib', function(){
	it('should generate a lightweight SVG badges', function(){
		shields.svg('jshint', '10 errors', 'red');
		shields.svg('jshint', 'ok', 'green');
		// TODO add some asserts.

		//var badge = shields.svg('jshint', '10 errors', 'red', 'flat');
		//fs.writeFileSync('./test.svg', badge);
		//console.log(badge);
	});
});