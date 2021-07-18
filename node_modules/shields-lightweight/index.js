// Duplicated then adapted from badges/shields

var fs = require('fs');
var path = require('path');
var dot = require('dot');

var colorscheme = require('./colorscheme');

dot.templateSettings.strip = false; // Do not strip whitespaces.

// cache templates.
var templates = {};
var templateFiles = fs.readdirSync(path.join(__dirname, 'templates'));
templateFiles.forEach(function(filename) {
  var templateData = fs.readFileSync(path.join(__dirname, 'templates', filename)).toString();
  templates[filename.split('.')[0]] = dot.template(templateData);
});

function escapeXml(s) {
  return s.replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&apos;');
}

exports.svg = function(subject, status, color, style) {
  var template = templates[style] || templates.plastic;

  var data = {
    subject: '' + subject,
    status: '' + status,
    colors: colorscheme[color] || colorscheme.red,
    escapeXml: escapeXml
  };

  // less clean way to calculate string length thant the original shields programm.
  // But prevents building and loading C++ addon 'canvas'.
  data.widths = [(data.subject.length * 6) + 10, (data.status.length * 6) + 10];

  return template(data);
};