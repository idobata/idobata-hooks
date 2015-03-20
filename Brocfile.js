var concat          = require('broccoli-concat');
var mergeTrees      = require('broccoli-merge-trees');
var pickFiles       = require('broccoli-static-compiler');
var renameFiles     = require('broccoli-rename-files');
var renderTemplates = require('broccoli-render-template');

var styles = concat('lib/hooks', {
  inputFiles: ['*/style.sass'],
  outputFile: '/styles/_idobata-hooks.sass'
});

var templates = pickFiles('lib/hooks', {
  srcDir:  '/',
  files:   ['*/help.html.haml'],
  destDir: 'templates/idobata-hooks'
});

templates = renderTemplates(templates);
templates = renameFiles(templates, {
  transformFilename: function(filename, basename, extname) {
    return basename.replace('.html', '.hbs');
  }
});

module.exports = mergeTrees([styles, templates]);
